_   = require 'lodash'
Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect

module.exports = ( channels, l ) ->
  
  #                        v7
  # 6                             
  # 5    v6    v0    v2    v4    v1    v3    v5
  # 4                               
  # 3                        
  # 2                     
  # 1  
  #      -4  -3  -2  -1    0    1    2    3    4  
  # 
  #                    Listener
  #
  #

  levels = [
    [ 0.7,  0.4  ]
    [ 0.5,  0.6  ]
    [ 0.6,  0.4  ]
    [ 0.4,  0.7  ]
    [ 0.5,  0.5  ]
    [ 0.2,  0.9  ]
    [ 0.9,  0.2  ]
    [ 0.4,  0.4  ]
  ]

  sqrt  = (a) -> Math.sqrt a
  m     = 0.00777 * 40

  delays = [
    [  (sqrt 34) * m,         ((sqrt 34) * m) - 0.15 ]
    [ ((sqrt 16) * m) - 0.05,  (sqrt 16) * m         ]
    [  (sqrt 16) * m,         ((sqrt 16) * m) - 0.05 ]
    [ ((sqrt 34) * m) - 0.15,  (sqrt 34) * m         ]
    [  (sqrt 25) * m,          (sqrt 25) * m         ]
    [ ((sqrt 39) * m ) - 0.25, (sqrt 39) * m         ]
    [  (sqrt 39) * m,         ((sqrt 39) * m) - 0.25 ]
    [   7 * m,                  7 * m                ]
  ]

  _.forEach l, (line, li) ->
    mixedl = [ line, line ]
    level  = levels[ li ]
    delay  = delays[ li ]

    mixedl = _.map [ line, line ], (ch, chi) ->
      ch = eff.shift ch,  shift: delay[ chi ]
      ch = eff.vol   ch, factor: level[ chi ]
      ch


    channels[0] = _.map channels[0], (sample, si) ->
      if mixedl[0].length > si
        sample += mixedl[0][si]
      sample

    channels[1] = _.map channels[1], (sample, si) ->

      if mixedl[1].length > si
        sample += mixedl[1][si]
      sample


  i = channels[0].length - 1
  isEmpty = (ci, si) -> channels[ ci ][ si ] is 0
  i-- while (isEmpty 0, i) and (isEmpty 1, i) and (i > 0)
  channels = _.map channels, (ch) -> ch.slice 0, i
  
  channels





