_                = require 'lodash'
Nt               = require './noitech/noitech'
{convertToFloat} = Nt
{max}            = Math

perc  = './perc/'

hats  = _.times 5, (i) ->
  fn  = perc + 'decHat_'
  fn += i + '.wav'
  f   = (Nt.open fn)[0]
  _.map f, (s) -> s * 0.1

getSamples = (name, amount, vol) ->
  samples  = _.times amount, 
    (i) ->
      fn   = perc + name
      fn  += i + '.wav'
      f    = (Nt.open fn)[0]
      f    = convertToFloat f
      _.map f, (s) -> s * vol

  longest  = _.reduce samples,
    (sum, s) -> max sum, s.length
    0

  _.map samples, (s) ->
    pad = longest - s.length
    pad = _.times pad, -> 0
    h.concat pad


combiners =
  5: (c) ->
    vol  = _.random 0.5, true
    c[1] = _.map c[1],
      (s) -> s * (0.5 - vol)
    c[2] = _.map c[2],
      (s) -> s * vol
    c

  4: (c) ->
    vol  = _.random 1, true
    c[1] = _.map c[1],
      (s) -> s * vol 
    c

generator  = (samples, var) ->
  (duration) ->
    {length} = samples

    ss = []
    until ss.length is length - 2
      r = _.random length - 1
      unless r in ss
        ss.push r

    ss = _.map ss, (n) ->
      samples[n]

    ss = combiners[length] ss

    output = _.reduce ss,
      (sum, _ss) ->
        offset    = _.random var
        offset    = _.times 0, -> 0
        _ss       = offset.concat _ss
        {length}  = sum
        remainder = _ss.slice length
        _ss       = _ss.slice 0, length

        _.forEach _ss, (s, i) ->
          sum[i] += s

        (sum.concat remainder).slice 30

      _.times longest, -> 0

    output.slice 0, duration


percussion = 
  'hc': generator (getSamples 'hat_',       5, 0.1), 10
  'ho': generator (getSamples 'hat-open_',  4, 0.1), 10
  'sn': generator (getSamples 'snare',      4, 0.1), 10
  'sl': generator (getSamples 'snare-lite', 4, 0.1), 10
  'cl': generator (getSamples 'click',      5, 0.1), 10    

module.exports = percussion


# hat         5
# hat-open    4
# snare       4
# snare-lite  4
# click       5