_  = require 'lodash'
Nt = require './noitech/noitech'

convolve = (sound, seed) ->
  oLength = sound.length + seed.length
  output  = _.times oLength, -> 0
  _.forEach sound, (s_, i) ->
    _.forEach seed, (s, j) ->
      output[ i + j ] +=  s_ * (s ** 3) * 0.3
  output


convolveB = (sound, seed) ->
  length  = sound.length + seed.length
  output  = _.times length - 1, -> 0
  sound_  = sound.slice 1
  _.forEach sound_, (s_, i) ->
    _.forEach seed, (s, j) ->
      s__ = sound[i]
      output[ i + j ] +=  (s_ - s__) * s
  output


input = Nt.open 'vol0p2.wav'
_.forEach input, (ch) ->
  ch = Nt.convertToFloat ch

clap    = Nt.open 'noise_clap_e.wav'
clap    = Nt.convertToFloat clap[0]

output = _.map input, (ch) -> 
  Nt.convertTo64Bit (convolveB (convolveB ch, clap), clap)

Nt.buildFile 'output.wav', output


convolve = (sound, seed) ->
  ###
    The seed is model of reflected sound
    When pulse of sound is fired into a room
    it reflects off each surface and reaches
    the listener innumerable times along
    a period after its firing
                               
      listener ->  *
                     \
                       \     <- Path of sound    
                         \         
                           \
                             \  #
        * -------------------  ##
                              ##&
        ^
        |
       source of sound
     
    f(t) = n
    where n is the number of reflections
    that reach the listener at t

    seed =
      [ t0, t1 .. tn-1 ] -> [ f(t0), f(t1) .. f(tn-1) ]

    We model the seed, as, the number of times
    the pulse reaches the listener  across time,
    like so
      
            |
            |
    volume  |
      of    |
   arrivals |   |
      at    |  | |
    time t  |  | |
            | |  |
            |--  |      
            |    |        |-------| 
            |    |-   |---|       |--|
            |      |--|              |----|
            ----------------------------------
            t ->
            
     seed = [ ------ volume at time t ------ ]
  

    [ ------- sound ------- ][ - reflection - ]
    | ---------------- length --------------- |
    time ->

    the output of this function, will have a 
    length that is the sounds length, plus
    the seeds length.
  ###
  length = sound.length + seed.length

    # [ ------- sound ------- ][ - reflection - ]
    # [ ---------------- output --------------- ]
    # time ->       
  output = _.times length, -> 0

  ###
    where r0 is the reflection at time 0 and
    where s0 is the sample of audio at time 0

    [ r0 * s0, r1 * s1, r2 * s2]
          |       |        |  
          |       v        v
  +       |  [ r0 * s1, r1 * s2, r2 * s3 ]
          |       |        |        |
          |       |        v        v                      
  +       |       |   [ r0 * s3, r1 * s3, r2 * s3 ]
          |       |        |        |       |           
          v       v        v        v       v      
  = [ ----------------- output ------------------ ]

  ###
  _.forEach sound, (sample, i) ->
    _.forEach seed, (reflection, j) ->
      output[ i + j ] += sample * (reflection ** 2) * 0.1

  output





