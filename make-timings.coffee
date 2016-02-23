_          = require 'lodash'
{ random } = Math

variance = 100

module.exports = MakeTimings = (p) ->
  { parts, beatLength } = p
  { voices }            = p
  length = _.reduce parts, 
    (sum, p) -> 
      sum + p.length
    0

  base = [ 0 ]
  _.times length, ->
    base.push beatLength

  v = voices.length
  timings = [ 0 .. v - 1 ]
  _.map timings, ->
    _.map base, (t) ->
      o  = random()
      o *= variance
      o -= variance / 2
      o += t
      o // 1