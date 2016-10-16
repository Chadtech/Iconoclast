_   = require 'lodash'
Nt  = require './noitech/noitech'
gen = Nt.generate
eff = Nt.effect

{abs, sqrt, max} = Math

preShift = (l, delay) ->
  intDelay = delay // 1
  if delay > 0
    l = l.slice intDelay
  else
    pad = _.times intDelay,
      -> 0
    l = pad.concat l
  l

module.exports = (lines, pos, ensembleSize) ->

  longest = _.reduce lines, 
    (m, l) -> max m, l.length
    0
  longest += 200

  channels = _.times 2, ->
    _.times longest, -> 0

  positions = [
    [ -3, 4 ]
    [  1, 5 ]
    [ -2, 3 ]
    [  2, 3 ]
    [ -2, 5 ]
    [ -1, 5 ]
    [  3, 4 ]
    [  0, 1 ]
  ]

  if pos?
    positons = [ positions[pos] ]

  levels = _.map positions, (p) ->
    d  = abs p[0]
    d += abs p[1]
    l  = p[0] / d
    if l < 0 then  [ 1 + l, -l    ]
    else           [ l,     1 - l ]

  delays  = _.map positions, (p) ->
    dist  = p[0] ** 2
    dist += p[1] ** 2
    dist  = sqrt dist
    dir   = p[0] / dist
    _.map p, (_p, i) ->
      o  = 15.397
      o *= dist * dir
      o *= (i * 2) - 1
      o
  
  lines = _.map lines, (l) ->
    _l = 1 / lines.length
    console.log "ensembleSize_", ensembleSize
    if ensembleSize?
      _l = 1 / ensembleSize
    eff.vol l, factor: _l

  _.map channels, (ch, i) ->
    _.reduce lines, 
      (_ch, l, li) ->
        delay = delays[li][i]
        l     = preShift l, delay
        delay = delay % 1
        delay = shift: delay
        l     = eff.shift l, delay

        level = levels[li][i]
        level = factor: level
        l     = eff.vol l, level

        _l    = l.length
        r     = _ch.slice _l
        _ch   = _ch.slice 0, _l
        _ch   = _.map _ch, 
          (s, si) -> s + l[si]
        
        _ch.concat r
      ch
