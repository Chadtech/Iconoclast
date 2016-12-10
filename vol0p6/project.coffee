project =
  name:       'vol0p6'
  root:       './score'
  parts: [
    { name: 'part-a.csv', length: 110 }
    { name: 'part0.csv', length: 288 }
    { name: 'part1.csv', length: 256 }
    { name: 'part2.csv', length: 256 }
    { name: 'part3.csv', length: 256 }
    { name: 'part4.csv', length: 256 }
    { name: 'part5.csv', length: 256 }
    { name: 'part6.csv', length: 256 }
    { name: 'part7.csv', length: 256 }
    { name: 'part8.csv', length: 256 }
  ]
  lines:      []
  beatLength: 3525
  voices:     [ 
    bellsG(), 
    bellsG(), 
    bellsG(), 
    bellsG(),
    bellsH(),
    bellsH(),
    bellsH(),
    bellsH()
    p,
    p
  ]