_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

{random, PI} = Math

# Saw Wave

tonic = 10
tones = [
  1       # 1/1
  1.125   # 9/8
  1.2     # 6/5
  1.5     # 3/2
  1.8     # 9/5
]

inharmonicity = 1.01
# d             = 51000

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

  _.reduce (_.keys octaves), 
    (sum, k) =>
      freq   = octaves[k]
      sum[k] = (length) ->

        gen.realSaw
          amplitude: 0.4
          tone:      octaves[k]
          sustain:   102000

      sum
    {}


