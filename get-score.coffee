{readFileSync} = require 'fs'
_              = require 'lodash'

module.exports = (project) ->
  {parts, root} = project

  score = _.map parts, (p) ->
    { length, name } = p

    # Lets open the file and 
    # convert it into an array
    # of rows, which are arrays
    # of columns, which are 
    # an array containing a
    # single string
    fn = root + '/' + name
    p  = readFileSync fn, 'utf8'
    p  = p.split '\n'
    p  = _.map p, (line) ->
      line = line.split ','
      _.map line, (note) -> 
        [ note ]

    # If its not long enough
    # add padding
    if p.length < length
      rowL = p[0].length
      pad  = [ [''] ]
      until pad.length is rowL
        pad.push ['']
      until p.length is length
        p.push pad
    
    # Transform the part from
    # an array of row containing
    # columns, into an array of 
    # columns containing rows
    p = p.slice 0, length
    p = _.reduce p, 
      (sum, row) ->
        _.map sum, (c, i) ->
          c.concat row[i]

    # Transform the notes in
    # each column, which are
    # strings, into arrays
    # of characters
    _.map p, (col) ->
      _.map col, (note) ->
        [
          note.slice 0, 2
          note.slice 2, 3
          note.slice 3, 4
          note.slice 4, 5
        ]

  _.reduce score, (sum, p) ->
    _.map sum, (row, i) -> 
      row.concat p[i]


