cp = require 'child_process'

module.exports = (what) ->
  cp.exec 'say ' + what