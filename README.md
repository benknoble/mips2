## MIPS interpreting MIPS

[![This project is considered experimental](https://img.shields.io/badge/status-experimental-critical.svg)](https://benknoble.github.io/status/experimental/)

Interprets the relatively complete subset of MIPS built on hardware for UNC Comp
541 in the same subset.

Takes advantage of memory-mapped IO from hardware to play sounds based on the
current instruction and to display the current set of registers.

Design documentation to come.

### Building examples into the interpreter

The `makefile` can build `.hex` files (suitable for inclusion in the
interpreter) and `.{i,d}mem` files (raw hex-codes of the instructions and data
values, suitable for inclusion in a Verilog description with `$readmemh`) from
the corresponding `.mips` file, provided you have

- a java installation; and
- the MARS jar ([MARS
  homepage](http://courses.missouristate.edu/kenvollmar/mars/index.htm)).

Set the environment or make variable `MARS` to the path to the jar.

Hex and memory dumps of all the examples are included with the repository.

Programs to be interpreted should declare data as `.space 4*n_words` or as
`.word 0:n_words`; that is, they must assume that data is 0-initialized.
(Otherwise the interpreter would need to store data for each program in its own
data segment, which is not as modular as I would like. If anyone has
suggestions for getting around this limitation, let me know.)

This effectively means that the only relevant `.dmem` file will be that of
`mips/mips2.mips`, since it (implicitly) contains all the `.imem`s of the
programs it can interpret. And, of course, the `.imem` file of `mips/mips2.mips`
will be the one relevant to load on the CPU we've built.

The `makefile` can also runs mars, under the same conditions, as a convenience.

---

### About the sprites

The sprites were generated using (a version of) a friend's tool,
[spritemaker](https://github.com/abrahampost/spritemaker.git).

The script `bin/bmp` uses `pbpaste` (macOS) to automatically convert the
clipboard contents into a `.bmp` file and commit it. Users on other platforms
could replace `pbpaste` with, e.g., `xsel ...` or another program.

The script `bin/no-bmps-the-same` double-checks that all bitmaps differ (but it
is quadratic in the number of bitmaps, so expect to wait).
