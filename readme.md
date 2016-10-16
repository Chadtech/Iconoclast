This is Iconoclast, my music production code. I made it in early 2016. Iconoclast reads musical scores stored as csv files, and then assembles them into wav files. It relies on a lot of different technology that Ive worked on, and the subtle arrangement of how these different pieces work together would be hard to describe here. This repo itself it very messy! Let me describe some of the files here.

# app.coffee

app.coffee is the primary file. You run it, and it awaits a command like 'build' or 'play', which builds audio files and plays audio files respectively. To use app.coffee, you are also going to have to open up and modify app.coffee.

# channels.coffee

This takes an arrangement of musical voices, as well as their position in space, and then does a good job combining these musical voices into left and right audio tracks that sound as if those voices were located in those positions in space.

# convolve

Convolving is a process of simulating how certain rooms sound with given audio inputs. Anything called 'convolve' is a variety of this effect. I usually use it in post production

# get-score.coffee

This takes a csv file of and formats a it a bit into a musical score

# l.coffee, m.coffee, n.coffee, p.coffee, q.coffee

These are files that synthesize musical voices. p is percussion, l sounds a bit like a organ. I regret naming these single letters.

# make-lines.coffee

A line is a single string of musical notes. This file was difficult to name. It takes a line of musical notes, and given a voice, it produces an audio file of that musical voice playing that sequence of notes.

# make-timings.coffee make-times.coffee

So these two are tricky. Iconoclast deliberately makes the times on which notes are played imperfect. The timing of each note is generated, and goes through two stages. First, an array of beat durations is generated, where all beat durations are a number (say 500ms).Then, we convert this array from relative timings to absolute timings. Relative timings meaning, times relative to the previous note played, to timings relative to the very beginning of the piece. So [ 500, 500, 500 ] becomes [ 0, 500, 1000 ]. After that random numbers between say -30ms and 30ms are added to each time too make things a little bit imperfect. So [0, 500, 1000] plausibly becomes [ 3, 490, 1013 ].

The word choice of 'times' and 'timings' was supposed to reflect this difference of purpose within the data

# mcartel, vol0p1, vol0p2, vol0p3, vol0p4

These are scores and audio files from distinct music projects made using Iconoclast

# Noitech

Noitech is my audio library that I use to make audio files

# old-voices

A disorganized collection of synthesizers and audio files from the previous projects and technology before I developed Iconoclast

# perc

A collection of percussion samples used by p.coffee

# samples

Samples that could be used in either percussion or convolution

# Score

Score is where app.coffee looks for csvs

# Util

These files do things like use the macintosh speech synthesizer, use Sox to play audio files, and format file names. They probably wont work on your computer.



