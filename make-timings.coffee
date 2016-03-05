_          = require 'lodash'
{ random } = Math

variance = 100

module.exports = MakeTimings = (p) ->
  { parts, beatLength } = p
  { voices }            = p
  length = _.reduce parts, 
    (sum, p) -> sum + p.length
    0

  base = _.times length, 
    -> beatLength
  base.unshift 0

  vl = voices.length
  _.times vl, ->
    _.map base, (t) ->
      o  = random()
      o *= variance
      o -= variance / 2
      o += t
      o // 1
