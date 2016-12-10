_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect
cp    = require 'child_process'

{random, PI} = Math

# Reed organy sound

tonic = 20
tones = [
  1       # 1/1
  1.167   # 7/6
  1.333   # 4/3
  1.524   # 32/21
  1.75    # 7/4
]

inharmonicity = 1.01

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
      sum[k] = (length) ->

        phase = random() * PI

        harmonics = [
          { a: 0.1,    freq: freq / 3.9 }
          { a: 0.15,   freq: freq       }
          { a: 0.0525, freq: freq * 3.1 }
          { a: 0.0357, freq: freq * 5.2 }
        ]

        harmonics = _.map harmonics, 
          (h) ->
            gen.sine
              amplitude: h.a
              tone:      h.freq
              sustain:   length
              phase:     phase


        _.reduce harmonics, 
          (sum, h) -> Nt.mix sum, h
          (_.times length, -> 0)

      sum
    {}


