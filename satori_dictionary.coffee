### (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 ###

if require
	fs = require 'fs'
	path = require 'path'

unless MiyoFilters?
	MiyoFilters = {}

MiyoFilters.satori_dictionary_initialize = type: 'through', filter: (argument, request, id, stash) ->
	@SatoriDictionaryLoader = {}
	@SatoriDictionaryLoader.load_file = (dictionary, file, options) =>
		str = fs.readFileSync file, 'utf8'
		@SatoriDictionaryLoader.load_str dictionary, str, file, options
	@SatoriDictionaryLoader.load_str = (dictionary, str, filepath='(data)', {aitalk_id}) ->
		aitalk_id ='OnSatoriAITalk' unless aitalk_id?
		lines = str.split /\r?\n/
		escape = false
		entries = {}
		current_entry = null
		for line in lines
			if not escape and (match = line.match /^([＊＠])(.*)$/)
				id = match[2]
				unless id.length
					id = aitalk_id
				unless entries[id]?
					entries[id] = []
				current_entry = type: match[1], value: []
				entries[id].push current_entry
			else if current_entry? and (escape or not line.match /^＃/)
				if line.length
					if escape
						current_entry.value[current_entry.value.length - 1] += '\r\n' + line
					else
						current_entry.value.push line
			escape = false
			if line.match /^(?:φ.|[^φ])*φ$/
				escape = true
		for id, content of entries
			if not dictionary[id]?
				dictionary[id] = []
			else if not (dictionary[id] instanceof Array)
				throw "satori_dictionary error: [#{filepath}] dictionary id=#{id} is not Array"
			for entry in content
				if entry.type == '＊'
					dictionary[id].push entry.value.join('\r\n') + '\r\n'
				else
					dictionary[id] = dictionary[id].concat entry.value
	argument

MiyoFilters.satori_dictionary_load = type: 'through', filter: (argument, request, id, stash) ->
	files = argument.satori_dictionary_load.files
	directories = argument.satori_dictionary_load.directories
	aitalk_id = argument.satori_dictionary_load.aitalk_id
	cwd = process.cwd()
	filepaths = []
	if files?
		if typeof files == 'string' or files instanceof String
			files = [files]
		for file in files
			filepaths.push path.join cwd, file
	if directories?
		if typeof directories == 'string' or directories instanceof String
			directories = [directories]
		for directory in directories
			directorypath = path.join cwd, directory
			files = fs.readdirSync directorypath
			for file in files
				filepaths.push path.join directorypath, file
	unless @SatoriDictionaryLoader?
		@call_filters {filters: ['satori_dictionary_initialize']}, null
	for filepath in filepaths
		@SatoriDictionaryLoader.load_file @dictionary, filepath, aitalk_id: aitalk_id
	argument

if module? and module.exports?
	module.exports = MiyoFilters
