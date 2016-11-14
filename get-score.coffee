{readFileSync} = require 'fs'
_              = require 'lodash'

# Input
# project :=
#   .parts :=
#     .name := string
#     .length := number
# Transformation := f()
        

# Output
# List of parts :=
#   f( 
#     List of columns :=
#       List of notes :=
#         List of Strings :=
#   )

load = (project, transformation) ->
  {parts, root} = project

  _.map parts, (p) ->
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
    

    p = transformation p, length


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

rotate2DArray = (part, length) -> 
  # Transform the part from
  # an array of row containing
  # columns, into an array of 
  # columns containing rows
  part = part.slice 0, length
  part = _.reduce part, 
    (sum, row) ->
      _.map sum, (c, i) ->
        c.concat row[i]


# Input
# List of parts

# Output
# Part

combine = (score) ->
  _.reduce score, (sum, p) ->
    _.map sum, (row, i) -> 
      row.concat p[i]


getScore = (project) ->
  combine (load project, rotate2DArray)

getScore.combine = combine
getScore.load    = load


module.exports = getScore
