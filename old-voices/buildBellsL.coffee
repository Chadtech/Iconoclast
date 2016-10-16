_     = require 'lodash'
Nt    = require './noitech.coffee'
gen   = Nt.generate
eff   = Nt.effect
cp    = require 'child_process'

tonic = 20
tones = [
  1       # 1/1
  1.143   # 8/7
  1.3125  # 21/16
  1.524   # 32/21
  1.75    # 7/4
]

inharmonicity = 1.01
bellDuration = 44100 * 4

octaves = [ 0 .. 8 ]
octaves = _.map octaves, (octave) ->
  _.map tones, (tone, toneIndex) ->
    output = tonic * (2 ** octave) * tone
    output *= inharmonicity ** ((toneIndex + (octave * tones.length)) // tones.length)
    output

noteTotal = octaves.length * octaves[0].length

octaves = _.map octaves, (octave, octaveIndex) ->
  _.map octave, (tone, toneIndex) ->

    noteTotal

    sounds = []

    a = 0.5

    fundamental = gen.sine
      amplitude: a
      tone:      tone
      sustain:   bellDuration
    sounds.push fundamental

    a /= 4

    secondHarmonic = gen.sine
      amplitude: a
      tone:      tone * 2.01
      sustain:   bellDuration
    sounds.push secondHarmonic


    a /= 4

    thirdHarmonic = gen.sine
      amplitude: a
      tone:      tone * 4.04
      sustain:   bellDuration
    sounds.push thirdHarmonic

    


    sounds.unshift (gen.silence sustain: bellDuration)

    output = _.reduce sounds, (mix, sound) ->
      Nt.mix sound, mix, 0

    output = eff.ramp output

    fileName = 'bellL/bellL'
    fileName += octaveIndex 
    fileName += toneIndex 
    fileName += '.wav'
    
    Nt.buildFile fileName, [ Nt.convertTo64Bit output ]
    cmd = './convolveMono '
    cmd += fileName + ' home_clap_1.wav convolveItem2.wav'
    cmd += ' 0.05'
    cp.execSync cmd

    convolvedOut = Nt.open 'convolveItem2.wav'
    convolvedOut = Nt.convertToFloat convolvedOut[0]

    output = Nt.mix (Nt.convertToFloat output), convolvedOut, 0
    Nt.buildFile fileName, [ Nt.convertTo64Bit output ]

    console.log tone

    0

