# MIPS interpreting MIPS

[![This project is considered experimental](https://img.shields.io/badge/status-experimental-critical.svg)](https://benknoble.github.io/status/experimental/)

Interprets the relatively complete subset of MIPS built on hardware for UNC Comp
541 in the same subset.

Takes advantage of memory-mapped IO from hardware to play sounds based on the
current instruction and to display the current set of registers.

[Design documentation](./DESIGN.md)

## Controls when choosing a program (no sound playing)

- <kbd>0</kbd>: toggle "step mode"
- <kbd>1</kbd>: compute `12! = 479001600 = 0x1C8CFC00` into `$v0` iteratively
- <kbd>2</kbd>: compute `12!` into `$v0` recursively
- <kbd>3</kbd>: compute `Fib(47) = 2971215073 = 0xB11924E1` into `$v0` iteratively
- <kbd>4</kbd>: compute `Fib(12) = 144 = 0x00000090` into `$v0` recursively
- <kbd>5</kbd>: sort 10 pre-generated random 32-bit integers in memory using
  bubblesort, and set `$v0` to `1` if they are sorted after the algorithm runs.
  Also copies the integers into `$t0` through `$t9` for inspection. The original
  integers are
  - 0xc69020dc
  - 0xc3848f98
  - 0x40c0016f
  - 0x55282432
  - 0x81dfe057
  - 0x52957459
  - 0x25c0a1e3
  - 0x47a7a168
  - 0xbf60aa02
  - 0x683dd5b0

## Controls when running a program (sound playing; only in step mode)

- <kbd>Space</kbd>: execute next instruction
- <kbd>k</kbd>: quit interpreter and go back to menu

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
