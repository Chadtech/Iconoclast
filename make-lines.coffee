_     = require 'lodash'
Nt    = require './noitech/noitech'
gen   = Nt.generate
eff   = Nt.effect

say           = require './util/say'

ramp = 60


module.exports = (project) ->
  { voices, score } = project
  {  times, lines } = project
  { beatLength }    = project

  _.map lines, (l, i) ->
    s = score[i]
    v = voices[i]

    _.forEach s, (n, ni) -> 
      t = times[i][ni]
      isQ  = n[0] is 'Q'
      unless n[0] is ''
        unless v[n[0]]? or isQ
          say 'ERRORORORR'
          console.log n, i, ni
        else
          clearing = sustain: 44100 * 4
          silence  = gen.silence clearing
          r        = t - ramp
          seg      = l.slice r, t
          seg      = eff.fadeOut seg
          silence  = seg.concat silence
          l = Nt.displace silence, l, r

          unless isQ
            volume = parseInt n[2], 16
            volume++
            volume = volume // 16
            volume = factor: volume

            if isNaN volume.factor
              say 'volume isnt number'
              console.log i, ni, volume
            if volume > 1 or 0 > volume
              say 'volume isnt possible'
              console.log i, ni, volume

            duration  = parseInt n[1], 16
            duration++
            duration *= beatLength

            fade = parseInt n[3], 16
            
            n = v[n[0]] duration
            n = eff.vol n, volume
            _.times fade, ->
              n = eff.fadeOut n
            n = eff.rampOut n
            n = eff.rampIn n

            l = Nt.mix n, l, t
    l