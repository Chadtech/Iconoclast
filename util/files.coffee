module.exports = 

  fileName: (fp) ->
    i = fp.length - 1
    i-- until  fp[i] is '/'
    fp.slice i + 1, fp.length

  removeExtension: (fn) ->
    i = 0
    i++ until fn[i] is '.'
    fn.slice 0, i

  getExtension: (fn) ->
    i = 0
    i++ until fn[i] is '.'
    fn.slice i