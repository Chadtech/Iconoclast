cp = require 'child_process'

module.exports = (what) ->
  cp.exec 'play ' + what