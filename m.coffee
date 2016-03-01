_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect
cp    = require 'child_process'

{ random, PI } = Math

tonic = 20
tones = [
  1       # 1/1   
  1.111   # 10/9
  1.25    # 5/4
  1.333   # 4/3
  1.481   # 40/27
  1.667   # 5/3
  1.778   # 16/9
  1.875   # 15/8
]

inharmonicity = 1.01

module.exports = ->
  octaves = _.times 8, (octave) ->
    _.map tones, (tone, ti) ->

      # just a bit of variance
      # away from the act tone
      r  = random() - 0.5
      r /= 200
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

  keys = _.keys octaves
  _.reduce keys, 
    (sum, k) =>
      freq   = octaves[k]
      sum[k] = (length) ->

        harmonics = [
          { a: 0.5,    freq: freq        }
          { a: 0.1667, freq: freq * 2    }
          { a: 0.0533, freq: freq * 3.01 }
          { a: 0.0138, freq: freq * 4.02 }
          { a: 0.0089, freq: freq * 5.04 }
          { a: 0.0025, freq: freq * 7.1  }
          { a: 0.0005, freq: freq * 8.2  }
        ]

        harmonics = _.map harmonics, (h) ->
          gen.sine
            amplitude: h.a
            tone:      h.freq
            sustain:   length
            phase:     random() * PI

        _.reduce harmonics, 
          (sum, h) -> Nt.mix sum, h
          gen.silence sustain: length 

      sum
    {}

