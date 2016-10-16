_                = require 'lodash'
Nt               = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect
{convertToFloat} = Nt
{max}            = Math

perc  = './perc/'

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
    s.concat pad


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

generator  = (samples, offset) ->
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
        offset    = _.random offset
        offset    = _.times 0, -> 0
        _ss       = offset.concat _ss
        {length}  = sum
        remainder = _ss.slice length
        _ss       = _ss.slice 0, length

        _.forEach _ss, (s, i) ->
          sum[i] += s

        (sum.concat remainder).slice 30

      _.times samples[0].length, -> 0

    output.slice 0, duration


bassDrum = (tone_, dur) ->
  ->
    f = gen.sine
      amplitude: 0.1
      tone: tone_
      sustain: dur
    f = eff.fadeOut f

    si = gen.sine
      amplitude: 0.05
      tone: tone_ * 6
      sustain: dur
    si = eff.fadeOut f

    se = gen.sine
      amplitude: 0.05
      tone: tone_ * 7
      sustain: dur
    se = eff.fadeOut f

    s = gen.sine
      tone: (_.random tone_ / 2, tone_)
      sustain: 7105
      amplitude: 0.5
    s = eff.fadeOut s

    t = gen.sine
      tone: (_.random tone_ / 2, tone_ * 0.8)
      sustain: 3105
      amplitude: 0.1
    t = eff.fadeOut t

    fo = gen.sine
      tone: (_.random tone_ * 2, tone_ * 1.6)
      sustain: 5105
      amplitude: 0.4
    fo = eff.fadeOut t

    fi = gen.sine
      tone: (_.random tone_ * 2, tone_ * 4)
      sustain: dur / 2
      amplitude: 0.4
    fi = eff.fadeOut t

    _.forEach [s, t, fo, fi, si, se], (h) ->
      _.forEach h, (_s, i) ->
        f[i] += h[i]
        0

    f


percussion = 
  'hc': generator (getSamples 'hat_',        5, 0.35), 10
  'ho': generator (getSamples 'hat-open_',   4, 0.35), 10
  'sn': generator (getSamples 'snare_',      4, 0.6),  10
  'sl': generator (getSamples 'snare-lite_', 4, 0.6),  10
  'cl': generator (getSamples 'click_',      4, 0.5),  10 
  'bd': bassDrum(140, 14210)
  'lb': bassDrum(70,  24820)
  # 'bd': bassDrum(280, 14210)
  # 'lb': bassDrum(140,  24820)

module.exports = percussion


# hat         5
# hat-open    4
# snare       4
# snare-lite  4
# click       5