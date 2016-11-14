_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

{random, PI} = Math

# Gamelan Bar

tonic = 20
tones = [
  1       # 1/1
  1.125   # 9/8
  1.2     # 6/5
  1.5     # 3/2
  1.8     # 9/5
]

inharmonicity = 1.01
d             = 44100 * 3

module.exports = ->
  octaves = _.times 8, (octave) ->
    _.map tones, (tone, ti) ->

      # just a bit of variance
      # away from the act tone
      r  = random() - 0.5
      r /= 100
      r++

      # The tendency for higher
      # frequencies to 'stretch'
      # higher
      h  = octave * tones.length
      h += ti
      h  = h // tones.length
      h  = inharmonicity ** h

      # The tone, in this octave
      o  = tonic * (2 ** octave)
      o *= tone

      o * h * r

  octaves = _.reduce octaves,
    (sum, octave, oi) ->
      _.forEach octave, (tone, ti) ->
        key      = oi + '' + ti
        sum[key] = tone
      sum
    {}

  _.reduce (_.keys octaves), 
    (sum, k) =>
      freq   = octaves[k]
      sum[k] = ->

        harmonics = [
          # {a: 0.2,   freq: freq,        dur: d * 0.8   , phase: 0}
          {a: 0.4,   freq: freq * 2,    dur: d * 0.8   , phase: 0}
          # {a: 0.2,   freq: freq * 4,    dur: d * 0.3   , phase: 0}
          {a: 0.1, freq: freq * 3.1,  dur: 1000  , phase: Math.PI}
          {a: 0.066, freq: freq * 4.26, dur: 100  , phase: 0}
          {a: 0.043, freq: freq * 5.55, dur: 320  , phase: Math.PI}
          {a: 0.030, freq: freq * 7.02, dur: 500  , phase: Math.PI}
          {a: 0.027, freq: freq * 8.1,  dur: 600  , phase: 0}
          {a: 0.023, freq: freq * 9.2,  dur: 400  , phase: Math.PI}
          {a: 0.011, freq: freq * 10.5, dur: 320  , phase: 0}
        ]

        harmonics = _.map harmonics, 
          (h, j) ->

            o = gen.sine
              amplitude: h.a
              tone:      h.freq
              sustain:   h.dur
              phase:     h.phase

            _.times 1, ->
              o = eff.fadeOut o 
              0
            pad = _.times d - o.length, -> 0
            o.concat pad

        _.reduce harmonics, 
          (sum, h) -> Nt.mix sum, h
          (_.times d, -> 0)

      sum
    {}


