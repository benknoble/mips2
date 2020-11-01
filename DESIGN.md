## Final project: A/V MIPS Interpreter

### Idea

1. Interprets a MIPS program from data memory by faithfully executing
   instructions (chosen via menu/etc.: can have more than one option)
1. Sound based on current instruction (A)
1. Display registers, memory, instruction, PC, ? (V)

### Samples

- should put "answer" in a register or similar

- Recursive/iterative factorial (of some fair-sized number)
- recursive/iterative Fibonacci?
- sort? (**!!**)
- the interpreter on a fixed program? (**!!!**)

### How it works

- memory locations are labeled as registers, PC, etc.

1. **!** Pick a program in memory (labeled)
1. Loop (while instruction != 0x00000000):
  1. Load instruction from memory based on `PROGRAM + PC`
  1. **!** Play sound based on instruction
  1. Decode (pull out relevant pieces)
  1. Execute it (a giant if-else/switch-case on `opcode`/`funct`)
  1. **!** Update screen with any changes

- optionally: single-instruction-step (only on key-press)

#### Memory

- 32 words for registers
- 1 word for PC
- 1 word to hold current program base
- enough for all my sample programs
- a small amount reserved for program data (`DATA_SIZE`:
  [mem.mips](./mips/mem.mips))
- my interpreter is stackless (except where it calls provided IO routines), so
  my stack (`$sp`, `$fp`) *is* the interpreted program's stack

- all memory references (including to instruction memory for loading) is kept as
  absolute as it is in the original program
- when a load or store is actually performed, the address is made relative by
  subtracting `TEXT_START` or `DATA_START`, and then computed relative to
  `progbase` or `data` as the case may be
- the exception is when a data load/store is relative to `$sp` and `$fp`. These
  are assumed to be small (stack conventions in MIPS), and thus not translated
  at all (remember that these two registers are actually mirrored by the
  interpreter's registers, since its stack is the program's stack)

#### Samples

- must assume data is 0-initialized (i.e., you fill your own data) and limited
  to `DATA_SIZE` words
- put the "answer" in `$v0`

Provided:
- `iter-fact-12`: iteratively computes 12!, the largest factorial that fits in
32 bits
- `rec-fact-12`: idem., but recursively
- `iter-fib-47`: iteratively computes fib(47), the largest Fibonacci number that
fits in 32 bits
- `rec-fib-12`: idem., but recursively and only up to 12 (so that it doesn't
take too long or require excessive amounts of memory to memoize)
- `bubblesort`: `bubblesort`s 10 random 32-bit integers in memory
  - puts a 1 in `$v0` if sorted, and puts the array of 10 integers in `$t0`-`$t9`
  to prove it

#### Screen memory & Character codes

- see `bmp/*` for the bitmaps
- the original screen memory (`init.smem`) places all the labels in the correct
place, and 0s at all the values (generated automatically by the makefile)
- a table of character codes based on `init.bmem` is in `bmem-map` (both are
generated automatically by the makefile)

#### Display design

- 30 x 40 characters
- each register takes up 8 digits/1 per character = 8 characters, plus 1 label,
  1 equals, 1 0x (11 total)
- fit into a grid of 16 rows by 2 columns (L = 0x DDDD DDDD)
  - grid column out of 2 = register-number mod 2 = register-number & 0x00000001
    - screen columns [1 + (grid column x 28), 11 + (grid column x 28)]
    - screen columns 0, 39, and 12-27 will be blank
  - grid row out of 16 = register-number div 2 = register-number >> 1
    - screen row = grid row
- this leaves 14 rows
- use one more for PC (L = 0x DDDD DDDD: 11 chars)
- and instruction (idem.)
- one row to put the 5 (6: kill?) controls (the digits 0-5 (+k?))
- leaves 11 unused ??? (padding on top/bottom?

#### Sound

- put the 32-bit instruction in the sound register (will automatically turn off
  when the program finishes 0x00000000)
