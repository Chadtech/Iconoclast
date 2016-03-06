_     = require 'lodash'
Nt    = require './noitech/noitech'
{max} = Math

perc  = './perc/'

hats  = _.times 5, (i) ->
  fn  = perc + 'decHat_'
  fn += i + '.wav'
  f   = (Nt.open fn)[0]
  _.map f, (s) -> s * 0.1

longest = _.reduce hats, 
  (sum, h) -> max sum, h.length
  0

hats = _.map hats, (h) ->
  pad = longest - h.length
  pad = _.times pad, -> 0
  h.concat pad


hat = ->
  h = []
  until h.length is 3
    r = _.random hats.length - 1
    unless r in h
      h.push r

  h = _.map h, (n) ->
    hats[n]

  vol  = _.random 1, true

  h[1] = _.map h[1], 
    (s) -> s * vol

  h[2] = _.map h[2],
    (s) -> s * (1 - vol)

  _.reduce h, 
    (sum, _h) ->
      # o is short for offset
      # r is short for remainder
      o  = _.random 15
      o  = _.times o, -> 0
      _h = o.concat _h
      r  = _h.slice sum.length
      _h = _h.slice 0, sum.length
      
      _.forEach _h, (s, i) ->
        sum[i] += s

      (sum.concat r).slice 30

    _.times longest, -> 0


minute = 44100 * 120
track  = _.times minute, -> 0
rate   = 10004

_.times 120, (i) ->
  _hat = hat()
  _.forEach _hat, (s, hi) ->
    _i  = rate * i
    _i += 100
    _i += hi
    v   = 1
    v   = 0.25 if (i % 2) is 1
    track[_i] = s * v


Nt.buildFile 'percTest.wav', [ track ]

console.log 'DONE'


