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

    a /= 3

    firstHarmonic = gen.sine
      amplitude: a
      tone:      tone * 2
      sustain:   bellDuration
    sounds.push firstHarmonic

    a /= 3

    secondHarmonic = gen.sine
      amplitude: a
      tone:      tone * 3.01
      sustain:   bellDuration
    sounds.push secondHarmonic


    a /= 3

    thirdHarmonic = gen.sine
      amplitude: a
      tone:      tone * 4.02
      sustain:   bellDuration
    sounds.push thirdHarmonic


    a /= 3
    

    fourthHarmonic = gen.sine
      amplitude: a
      tone:      tone * 5.04
      sustain:   bellDuration
    sounds.push fourthHarmonic


    a /= 3


    fifthHarmonic = gen.sine
      amplitude: a
      tone:      tone * 7.1
      sustain:   bellDuration
    sounds.push fifthHarmonic


    a /= 4


    sixthHarmonic = gen.sine
      amplitude: a
      tone:      tone * 8.2
      sustain:   bellDuration
    sounds.push sixthHarmonic



    sounds.unshift (gen.silence sustain: bellDuration)

    output = _.reduce sounds, (mix, sound) ->
      Nt.mix sound, mix, 0

    output = eff.vol (eff.ramp output), factor: 0.5

    fileName = 'bellM/bellM'
    fileName += octaveIndex 
    fileName += toneIndex 
    fileName += '.wav'
    
    Nt.buildFile fileName, [ Nt.convertTo64Bit output ]
    cmd = './convolveMono '
    cmd += fileName + ' home_clap_1.wav convolveItem.wav'
    cmd += ' 0.05'
    cp.execSync cmd

    convolvedOut = Nt.open 'convolveItem.wav'
    convolvedOut = Nt.convertToFloat convolvedOut[0]

    output = Nt.mix (Nt.convertToFloat output), convolvedOut, 0
    Nt.buildFile fileName, [ Nt.convertTo64Bit output ]

    console.log tone

    0

