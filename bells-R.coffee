_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

{random, PI} = Math

# These are meant to 
# resemble the way
# industrial bar
# sounds

# Lots of complicated high harmonics
# Short duration

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
      sum[k] = (d) ->

        d *= 4

        harmonics = [
          {fo: 1, a: 0.05, freq:  freq / 2,    dur: d * 0.02, phase: 0}
          {fo: 1, a: 0.3,  freq:  freq,        dur: d * 0.2, phase: 0}
          {fo: 1, a: 0.3,  freq:  freq * 2,    dur: d * 0.3, phase: 0}
          {fo: 1, a: 0.2,  freq:  freq * 3,    dir: d * 0.3, phase: Math.PI}
          {fo: 1, a: 0.2,  freq:  freq * 4.2,  dir: d * 0.6, phase: 0 }
          {fo: 1, a: 0.07, freq:  freq * 5.17, dir: d * 0.2, phase: Math.PI}
          {fo: 1, a: 0.05, freq:  freq * 7.4,  dir: d * 0.4, phase: Math.PI}
          {fo: 1, a: 0.1,  freq:  freq * 8.1,  dir: d,       phase: 0}
          {fo: 1, a: 0.05, freq:  freq * 9.2,  dir: d * 0.3, phase: Math.PI}
        ]

        harmonics = _.map harmonics, 
          (h, j) ->
            o = gen.sine
              amplitude: h.a * 2
              tone:      h.freq
              sustain:   h.dur
              phase:     h.phase

            _.times h.fo, ->
              o = eff.fadeOut o 
              0

            pad = _.times d - o.length, -> 0
            o.concat pad

        _.reduce harmonics, 
          (sum, h) -> Nt.mix sum, h
          (_.times d, -> 0)

      sum
    {}


