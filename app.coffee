_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

stdin = process.openStdin()

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
channeler   = require './channels'

m           = require './m'
l           = require './l'



project =
  name:       'm-cartel'
  root:       './score'
  parts: [
    { name: 'part0.csv', length: 128 }
    { name: 'part0.csv', length: 128 }
  ]
  lines:      []
  beatLength: 5002
  voices:     [ 
    m(), m(), l(), l(), l() 
  ]

timings       = makeTimings project
project.times = makeTimes timings


build = (from, to) ->
  say 'building'

  from          = 0 unless from?
  { times }     = project
  { voices }    = project 
  {beatLength}  = project
  score         = getScore project
  project.score = _.map score, 
    (part) -> part.slice from, to

  times   = times.slice from, to
  times   = zero times
  to      = times[0].length unless to?
  length  = times[0][ to - 1 ] 
  length += 200

  vl      = voices.length
  lines   = _.times vl, -> 
    _.times length, -> 0

  _.extend project, {lines}
  _.extend project, {times}
  lines    = makeLines project

  channels = channeler lines
  channels = _.map channels, (ch) ->
    Nt.convertTo64Bit ch

  say 'compiling'
  { name } = project
  name    += '.wav'
  Nt.buildFile name, channels

  timings       = makeTimings project
  project.times = makeTimes timings


buildLines = ->
  say 'building'

  { times }     = project
  { voices }    = project 
  {beatLength}  = project
  score         = getScore project
  project.score = score

  times   = zero times
  l       = times[0].length
  length  = times[0][ l - 1 ] 
  length += 200

  _.times voices.length, (li) ->
    dummy       = _.cloneDeep project
    dummy.lines = [ _.times length, -> 0 ]
    dummy.score = dummy.score.slice li, li + 1
    dummy.times = dummy.times.slice li, li + 1

    lines = makeLines dummy
    line  = lines[0]
    line  = Nt.convertTo64Bit line
    fn    = dummy.name + '-line' 
    fn   += li + '.wav'
    console.log 'LINE ', li 
    Nt.buildFile fn, [ line ]

  timings       = makeTimings project
  project.times = makeTimes timings





say 'ready'
console.log project.name + ' terminal:'
stdin.addListener 'data', (d) ->
  d = d.toString().trim().split ' '

  switch d[0]

    when 'finish'

      buildLines()

    when 'build'

      if d[1]?
        build d[1], d[2]
      else
        build()

      console.log '*************************'

    when 'play'

      if d[1]?
        say 'playing', =>
          play d[1] + '.wav'  
      else
        say 'playing', =>
          play project.name + '.wav'









