_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

{random, PI} = Math

# Bells G

tonic = 20
tones = [
  1       # 1/1
  1.143   # 8/7
  1.313   # 21/16
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
      r /= 250
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


        a_ = 1 - ((parseInt k) / 40) * 0.8 

        harmonics = [
          {f: 2, a: 0.5,         freq: freq,        dur: d * 0.6 ,  phase: 0}
          {f: 2, a: 0.25,        freq: freq * 2,    dur: d * 0.15,  phase: 0}
          {f: 2, a: 0.25,        freq: freq / 2,    dur: d,         phase: 0}
          {f: 2, a: 0.13 * a_,   freq: freq * 3,    dur: d * 0.2,   phase: 0}
          {f: 3, a: 0.07 * a_,   freq: freq * 4.26, dur: d * 0.3,   phase: 0}
          {f: 3, a: 0.035 * a_,  freq: freq * 5.55, dur: d * 0.26,  phase: 0}
          {f: 4, a: 0.033 * a_,  freq: freq * 7.02, dur: d * 0.15 , phase: 0}
          {f: 4, a: 0.014 * a_,  freq: freq * 8.1,  dur: d * 0.14 , phase: 0}
          {f: 4, a: 0.01 * a_,   freq: freq * 9.2,  dur: d * 0.14 , phase: 0}
          {f: 4, a: 0.003 * a_,  freq: freq * 10.5, dur: d * 0.11 , phase: 0}
          {f: 4, a: 0.001 * a_,  freq: freq * 11.6, dur: d * 0.1 ,  phase: 0}
          {f: 4, a: 0.001 * a_,  freq: freq * 12.7, dur: d * 0.1 ,  phase: 0}
          {f: 4, a: 0.001 * a_,  freq: freq * 16.3, dur: d * 0.1 ,  phase: 0}
        ]

        harmonics = _.map harmonics, 
          (h, j) ->
            o = gen.sine
              amplitude: h.a * 2
              tone:      h.freq
              sustain:   h.dur
              phase:     h.phase

            _.times h.f, ->
              o = eff.fadeOut o 
              0
            pad = _.times d - o.length, -> 0
            o.concat pad

        _.reduce harmonics, 
          (sum, h) -> Nt.mix sum, h
          (_.times d, -> 0)

      sum
    {}


