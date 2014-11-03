chai = require 'chai'
chai.should()
expect = chai.expect
sinon = require 'sinon'
Miyo = require 'miyojs'
MiyoFilters = require '../satori_dictionary.js'

describe 'load', ->
	ms = null
	request = null
	id = null
	stash = null
	beforeEach ->
		dictionary =
			OnTest: 'test'
		ms = new Miyo(dictionary)
		for name, filter of MiyoFilters
			ms.filters[name] = filter
		request = sinon.stub()
		id = 'OnTest'
		stash = null
	it 'should load dictionary file', ->
		entry =
			filters: ['satori_dictionary_load']
			argument:
				satori_dictionary_load:
					files: ['test/dic_test.txt']
		return_value = ms.call_filters entry, null, '_load', stash
		return_value.should.be.equal entry.argument
		ms.dictionary.should.deep.equal
			OnTest: 'test'
			'テスト1': ['次に続くφ\r\n続くφ\r\n＊続く\r\n続いてるφ\r\n＠まだいく\r\nいける\r\n終わる\r\n']
			'単語リスト': [ '普通', '普通2', '続くφ\r\nよ', '続くφ\r\n＠よ', '続くφ\r\n＊よ', '終わり' ]
			OnSatoriAITalk: ['AIトークだよ\r\n']
			"テスト2": ["とと\r\n", "ねみぎ\r\n"]
	it 'should load dictionary directory', ->
		entry =
			filters: ['satori_dictionary_load']
			argument:
				satori_dictionary_load:
					directories: ['test/dir']
		return_value = ms.call_filters entry, null, '_load', stash
		return_value.should.be.equal entry.argument
		ms.dictionary.should.deep.equal
			OnTest: 'test'
			'てす': ['てす\r\n', 'てすてす\r\n']
			'なんとか': ["かんとか\r\n"]
	it 'should throw on conflict', ->
		entry =
			filters: ['satori_dictionary_load']
			argument:
				satori_dictionary_load:
					files: ['test/dic_conflict.txt']
		(-> ms.call_filters entry, null, '_load', stash).should.throw /Array/
