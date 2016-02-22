_ = require 'lodash'


module.exports = MakeTimes = (timings) ->
  _.map timings, (timing) ->
    _.map timing, (x, i) ->
      t = timing.slice 0, i + 1
      _.reduce t, (sum, s) ->
        sum + s