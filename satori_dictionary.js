// Generated by CoffeeScript 1.8.0

/* (C) 2014 Narazaka : Licensed under The MIT License - http://narazaka.net/license/MIT?2014 */
var MiyoFilters, fs, path;

if (require) {
  fs = require('fs');
  path = require('path');
}

if (typeof MiyoFilters === "undefined" || MiyoFilters === null) {
  MiyoFilters = {};
}

MiyoFilters.satori_dictionary_initialize = {
  type: 'through',
  filter: function(argument, request, id, stash) {
    this.SatoriDictionaryLoader = {};
    this.SatoriDictionaryLoader.load_file = (function(_this) {
      return function(file, options) {
        var str;
        str = fs.readFileSync(file, 'utf8');
        return _this.SatoriDictionaryLoader.load_str(str, file, options);
      };
    })(this);
    this.SatoriDictionaryLoader.load_str = (function(_this) {
      return function(str, filepath, _arg) {
        var aitalk_id, content, current_entry, entries, entry, escape, line, lines, match, _i, _len, _results;
        if (filepath == null) {
          filepath = '(data)';
        }
        aitalk_id = _arg.aitalk_id;
        if (aitalk_id == null) {
          aitalk_id = 'OnSatoriAITalk';
        }
        lines = str.split(/\r?\n/);
        escape = false;
        entries = {};
        current_entry = null;
        for (_i = 0, _len = lines.length; _i < _len; _i++) {
          line = lines[_i];
          if (!escape && (match = line.match(/^([＊＠])(.*)$/))) {
            id = match[2];
            if (!id.length) {
              id = aitalk_id;
            }
            if (entries[id] == null) {
              entries[id] = [];
            }
            current_entry = {
              type: match[1],
              value: []
            };
            entries[id].push(current_entry);
          } else if ((current_entry != null) && (escape || !line.match(/^＃/))) {
            if (line.length) {
              if (escape) {
                current_entry.value[current_entry.value.length - 1] += '\r\n' + line;
              } else {
                current_entry.value.push(line);
              }
            }
          }
          escape = false;
          if (line.match(/^(?:φ.|[^φ])*φ$/)) {
            escape = true;
          }
        }
        _results = [];
        for (id in entries) {
          content = entries[id];
          if (_this.dictionary[id] == null) {
            _this.dictionary[id] = [];
          } else if (!(_this.dictionary[id] instanceof Array)) {
            throw "satori_dictionary error: [" + filepath + "] dictionary id=" + id + " is not Array";
          }
          _results.push((function() {
            var _j, _len1, _results1;
            _results1 = [];
            for (_j = 0, _len1 = content.length; _j < _len1; _j++) {
              entry = content[_j];
              if (entry.type === '＊') {
                _results1.push(this.dictionary[id].push(entry.value.join('\r\n') + '\r\n'));
              } else {
                _results1.push(this.dictionary[id] = this.dictionary[id].concat(entry.value));
              }
            }
            return _results1;
          }).call(_this));
        }
        return _results;
      };
    })(this);
    return argument;
  }
};

MiyoFilters.satori_dictionary_load = {
  type: 'through',
  filter: function(argument, request, id, stash) {
    var aitalk_id, cwd, directories, directory, directorypath, file, filepath, filepaths, files, _i, _j, _k, _l, _len, _len1, _len2, _len3;
    files = argument.satori_dictionary_load.files;
    directories = argument.satori_dictionary_load.directories;
    aitalk_id = argument.satori_dictionary_load.aitalk_id;
    cwd = process.cwd();
    filepaths = [];
    if (files != null) {
      if (typeof files === 'string' || files instanceof String) {
        files = [files];
      }
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        filepaths.push(path.join(cwd, file));
      }
    }
    if (directories != null) {
      if (typeof directories === 'string' || directories instanceof String) {
        directories = [directories];
      }
      for (_j = 0, _len1 = directories.length; _j < _len1; _j++) {
        directory = directories[_j];
        directorypath = path.join(cwd, directory);
        files = fs.readdirSync(directorypath);
        for (_k = 0, _len2 = files.length; _k < _len2; _k++) {
          file = files[_k];
          filepaths.push(path.join(directorypath, file));
        }
      }
    }
    if (this.SatoriDictionaryLoader == null) {
      this.call_filters({
        filters: ['satori_dictionary_initialize']
      }, null);
    }
    for (_l = 0, _len3 = filepaths.length; _l < _len3; _l++) {
      filepath = filepaths[_l];
      this.SatoriDictionaryLoader.load_file(filepath, {
        aitalk_id: aitalk_id
      });
    }
    return argument;
  }
};

if ((typeof module !== "undefined" && module !== null) && (module.exports != null)) {
  module.exports = MiyoFilters;
}

//# sourceMappingURL=satori_dictionary.js.map