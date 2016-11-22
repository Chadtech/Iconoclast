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
makeTimings = require './make-timings'
makeTimes   = require './make-times'
makeLines   = require './make-lines'
channeler   = require './channels'

m           = require './m'
l           = require './l'
p           = require './p'
n           = require './n'
q           = require './q'

bellsG      = require './bells-G'
bellsH      = require './bells-H'

bellsR      = require './bells-R'

saw         = require './saw-wave'

project =
  name:       'vol0p7'
  root:       './score'
  parts: [
    { name: 'beginning-pad.csv', length: 16  }
    { name: 'part-h.csv',        length: 192 }
    { name: 'part-i.csv',        length: 192 }
    { name: 'part-j.csv',        length: 48  }
    { name: 'part-jppp.csv',     length: 48  }
    { name: 'part-j.csv',        length: 48  }
    { name: 'part-jp.csv',       length: 48  }
    { name: 'part-ip.csv',       length: 192 }
    { name: 'part-jpp.csv',      length: 48  }
    { name: 'part-k.csv',        length: 192 }
    { name: 'part-l.csv',        length: 192 }
    { name: 'part-m.csv',        length: 192 }
    { name: 'part-mp.csv',       length: 192 }
    { name: 'part-mn.csv',       length: 96 }
    { name: 'part-n.csv',       length: 192 }
    { name: 'part-np.csv',       length: 192 }
    { name: 'part-np.csv',       length: 192 }
    { name: 'part-np.csv',       length: 192 }
  ]
  lines:      []
  beatLength: 2125
  voices:     [ 
    p
    p
    q()
    bellsR()
    bellsR()
    saw()
    l()
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

  console.log "score"
  times   = _.map times, (t)->
    t.slice from, to

  console.log "times"
  times   = zero times
  to      = times[0].length unless to?
  length  = times[0][ to - 1 ] 
  length += 200

  console.log "lines"
  vl      = voices.length
  lines   = _.times vl, -> 
    _.times length, -> 0

  _.extend project, {lines}
  _.extend project, {times}
  lines    = makeLines project

  console.log "channels"
  channels = channeler lines
  channels = _.map channels, (ch) ->
    ch = eff.vol ch, factor: 4
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
    dummy        = _.cloneDeep project
    dummy.lines  = [ _.times length, -> 0 ]
    dummy.score  = dummy.score.slice li, li + 1
    dummy.times  = dummy.times.slice li, li + 1
    dummy.voices = [ voices[li] ]

    lines = makeLines dummy

    channels = channeler lines, li, project.voices.length
    channels = _.map channels, (ch) ->
      ch = eff.vol ch, factor: 4
      Nt.convertTo64Bit ch

    # line  = lines[0]
    # line  = Nt.convertTo64Bit line
    fn    = dummy.name + '-line' 
    fn   += li + '.wav'
    console.log 'LINE ', li 
    Nt.buildFile fn, channels

  say "finished"

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
        if d[2]?
          build d[1], d[2]
        else
          build d[1]
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









