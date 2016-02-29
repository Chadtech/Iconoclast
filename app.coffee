_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

{addListener} = process.openStdin()

zero = (a) -> 
  _.map a, (b) ->
    _.map b, (t) -> 
      t - b[0] + 100

# Utilities
{
  fileName 
  removeExtension
  getExtention
}             = require './util/files'
say           = require './util/say'
play          = require './util/play'
cp            = require 'child_process'
fs            = require 'fs'  
{addListener} = process.openStdin()

# Processes
getScore    = require './get-score'
# getVoices   = require './get-voices'
makeTimings = require './make-timings'
makeTimes   = require './make-times'
makeLines   = require './make-lines'
channels    = require './channels'

m           = require './m'
l           = require './l'



project =
  name:       'm-cartel'
  root:       './score'
  parts: [
    {name: 'part0.csv', length: 80}
    {name: 'part0.csv', length: 80}
  ]
  lines:      []
  # beatLength: 2756
  beatLength:   11100
  voices:     [ 
    m(), m(), m(), m(),
    l(), l(), l(), l() 
  ]

timings       = makeTimings project
project.times = makeTimes timings

getLines = (project, length) ->
  {voices} = project
  vLength  = voices.length
  lines    = [ 0 .. vLength - 1 ]
  _.map lines, (line) ->
    o = []
    _.times length, ->
      o.push 0
    o

build           = (from, to) ->
  { times }     = project
  { voices }    = project 
  {beatLength}  = project
  score         = getScore project
  project.score = _.map score, 
    (part) -> part.slice from, to

  times   = times.slice from, to
  times   = zero times
  length  = times[0][ to - 1 ] 
  length += 200

  vl      = voices.length
  lines   = _.times vl, -> 
    _.times length, -> 0

  project.lines = lines
  project.times = times
  lines         = makeLines project
  # say lines.length
  # lines         = lines.slice 0, 2

  # lines         = [lines[1]]

  # channels      = lines
  # Nt.buildFile 'Test-line.wav', 
  #   [ Nt.convertTo64Bit lines[0] ]

  channels = channels lines
  channels = _.map channels, (ch) ->
    Nt.convertTo64Bit ch

  { name } = project
  name    += '.wav'
  Nt.buildFile name, channels
  console.log 'DONE!!!!!'




build 0, 60
say 'DONE'


# ye   = m['37'] 176400
# ye   = eff.vol ye, factor: 0.25
# dank = m['41'] 176400
# dank = eff.vol dank, factor: 0.25
# ye   = Nt.mix ye, dank
# dope = m['45'] 176400
# dope = eff.vol dope, factor: 0.25
# ye   = Nt.mix ye, dope
# # console.log 'YE IS', ye
# ye = Nt.convertTo64Bit ye

# Nt.buildFile 'testtt.wav', [ye]

# cp.exec 'play testtt.wav' 
# console.log 'Done!'
# addListener 'data', (d) ->
#   d = d.toString().trim().split ' '
