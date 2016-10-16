Nt  = require './noitech.coffee'
gen = Nt.generate
eff = Nt.effect
say = require './say.coffee'



octavesOfBellL = []


getBells = (name) ->

  octavesOfBell = []
  thisOctave     = []

  for i in [ 0 .. 44 ]

    n = i % 5
    n += ''
    n = (i // 5) + n

    fp = './' + name
    fp += '/' + name + n
    fp += '.wav'

    thisBell = Nt.open fp
    thisBell = Nt.convertToFloat thisBell[0]
    thisBell = eff.vol thisBell, factor: 0.5
    
    thisOctave.push thisBell

    if (i % 5) is 4
      octavesOfBell.push thisOctave
      thisOctave = []

  octavesOfBell


octavesOfBellM = getBells 'BellM'
octavesOfBellL = getBells 'BellL'



bellTypeM =
  '11': -> octavesOfBellM[2][1]
  '12': -> octavesOfBellM[2][2]
  '13': -> octavesOfBellM[2][3]
  '14': -> octavesOfBellM[2][4]
  '20': -> octavesOfBellM[3][0]
  '21': -> octavesOfBellM[3][1]
  '22': -> octavesOfBellM[3][2]
  '23': -> octavesOfBellM[3][3]
  '24': -> octavesOfBellM[3][4]
  '30': -> octavesOfBellM[4][0]
  '31': -> octavesOfBellM[4][1]
  '32': -> octavesOfBellM[4][2]
  '33': -> octavesOfBellM[4][3]
  '34': -> octavesOfBellM[4][4]
  '40': -> octavesOfBellM[5][0]
  '41': -> octavesOfBellM[5][1]
  '42': -> octavesOfBellM[5][2]
  '43': -> octavesOfBellM[5][3]
  '44': -> octavesOfBellM[5][4]
  '50': -> octavesOfBellM[6][0]
  '51': -> octavesOfBellM[6][1]
  '52': -> octavesOfBellM[6][2]
  '53': -> octavesOfBellM[6][3]
  '54': -> octavesOfBellM[6][4]
  '60': -> octavesOfBellM[7][0]


bellTypeL = 
  '10': -> octavesOfBellL[2][0]
  '11': -> octavesOfBellL[2][1]
  '12': -> octavesOfBellL[2][2]
  '13': -> octavesOfBellL[2][3]
  '14': -> octavesOfBellL[2][4]
  '20': -> octavesOfBellL[3][0]
  '21': -> octavesOfBellL[3][1]
  '22': -> octavesOfBellL[3][2]
  '23': -> octavesOfBellL[3][3]
  '24': -> octavesOfBellL[3][4]
  '30': -> octavesOfBellL[4][0]
  '31': -> octavesOfBellL[4][1]
  '32': -> octavesOfBellL[4][2]
  '33': -> octavesOfBellL[4][3]
  '34': -> octavesOfBellL[4][4]

voice0 = bellTypeL
voice1 = bellTypeL
voice2 = bellTypeL

voice3 = bellTypeM
voice4 = bellTypeM
voice5 = bellTypeM


# openPerc = (what, vol) ->
#   filePath = './perc/' + what + '.wav'
#   perc = Nt.open filePath
#   perc = Nt.convertToFloat perc[0]
#   perc = eff.vol perc, factor: vol
#   perc

# voice5 =
#   'k0': openPerc 'decKick_0',       0.5
#   'k1': openPerc 'zach_dec_kick_0', 0.07
#   'h0': openPerc 'StealH0_closed',  0.25
#   'h1': openPerc 'StealH0_open',    0.25
#   'c0': openPerc 'home_clap_1',     0.4
#   's0': openPerc 'StealSnar2',      0.5
#   's1': openPerc 'StealSnar1',      0.5
#   'r0': openPerc 'decRide_0',       0.15


# voice6 =
#   'k0': openPerc 'decKick_0',       0.5
#   'k1': openPerc 'zach_dec_kick_0', 0.07
#   'h0': openPerc 'StealH0_closed',  0.25
#   'h1': openPerc 'StealH0_open',    0.25
#   'c0': openPerc 'home_clap_1',     0.4
#   's0': openPerc 'StealSnar2',      0.5
#   's1': openPerc 'StealSnar1',      0.5
#   'r0': openPerc 'decRide_0',       0.15
  
# voice7 =
#   'k0': openPerc 'decKick_0',       0.5
#   'k1': openPerc 'zach_dec_kick_0', 0.07
#   'h0': openPerc 'StealH0_closed',  0.25
#   'h1': openPerc 'StealH0_open',    0.25
#   'c0': openPerc 'home_clap_1',     0.4
#   's0': openPerc 'StealSnar2',      0.5
#   's1': openPerc 'StealSnar1',      0.5
#   'r0': openPerc 'decRide_0',       0.15


voices =  [
  voice0
  voice1
  voice2
  voice3
  voice4
  voice5
]


module.exports = voices