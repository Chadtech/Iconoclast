_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

{addListener} = process.openStdin()


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

m           = require './m'

project =
  name:       'm-cartel'
  root:       './score'
  parts: [
    {name: 'part0.csv', length: 80}
    {name: 'part0.csv', length: 80}
  ]
  lines:      []
  beatLength: 2756
  # v:          getVoices



build = (from, to) ->
  score = getScore project
  score = _.map score, (part) ->
    part.slice from, to

  timings = makeTimings project
  times   = makeTimes timings

ye   = m['37'] 44100
ye   = eff.vol ye, factor: 0.25
dank = m['41'] 44100
dank = eff.vol dank, factor: 0.25
ye   = Nt.mix ye, dank
dope = m['45'] 44100
dope = eff.vol dope, factor: 0.25
ye   = Nt.mix ye, dope
# console.log 'YE IS', ye
ye = Nt.convertTo64Bit ye

Nt.buildFile 'testtt.wav', [ye]
console.log 'Done!'
# addListener 'data', (d) ->
#   d = d.toString().trim().split ' '
