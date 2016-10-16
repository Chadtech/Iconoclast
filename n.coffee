_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect
cp    = require 'child_process'

{random, PI} = Math

# Gongs

tonic = 20
tones = [
  1       # 1/1
  1.167   # 7/6
  1.333   # 4/3
  1.524   # 32/21
  1.75    # 7/4
]

inharmonicity = 1.01
d             = 44100 * 4

module.exports = ->
  octaves = _.times 8, (octave) ->
    _.map tones, (tone, ti) ->

      # just a bit of variance
      # away from the act tone
      r  = random() - 0.5
      r /= 150
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
          {a: 0.25,  freq: freq * 1.01, dur: d * 0.6  , phase: 0}
          {a: 0.25,  freq: freq,        dur: d * 0.6  , phase: 0}
          {a: 0.05,  freq: freq * 2,    dur: d * 0.05 , phase: 0}
          {a: 0.2,   freq: freq / 2,    dur: d        , phase: 0}
          {a: 0.1,   freq: freq * 3,    dur: d * 0.01  , phase: Math.PI}
          {a: 0.066, freq: freq * 4.1, dur: d * 0.01  , phase: 0}
          {a: 0.033, freq: freq * 5.55, dur: d * 0.016 , phase: Math.PI}
          {a: 0.017, freq: freq * 7.02, dur: d * 0.015 , phase: Math.PI}
          {a: 0.007, freq: freq * 8.1,  dur: d * 0.014 , phase: 0}
          {a: 0.003, freq: freq * 9.2,  dur: d * 0.012 , phase: Math.PI}
          {a: 0.001, freq: freq * 10.5, dur: d * 0.011 , phase: 0}
        ]

        harmonics = _.map harmonics, 
          (h, j) ->
            o = gen.sine
              amplitude: h.a * 2
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


