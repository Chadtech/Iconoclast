cp = require 'child_process'

module.exports = (what, next) ->
  what = 'say ' + what
  cp.exec what, =>
    next?()