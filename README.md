# Five Stage Datapath

This project is a slightly simplified version of a MIPS assembly architecture
based datapath, created for my Computer Organization and Design class. This
circuit is based off the pipelined CPU implementation from Yamin Li's
_Computer Principles and Design in Verilog HDL, First Edition_ textbook.
These circuits in particular come from chapter eight - Design of Pipelined CPU
with Precise Interrupt in Verilog HDL. The implemented circuit schematic from
the text is shown below.

![img](https://cdn.discordapp.com/attachments/708493375745032213/742434915919855706/unknown.png)

## Overview

The project is a 32-bit datapath designed to execute MIPS assembly code. It also
contains a RAM and ROM module, both of which are byte addressed. It runs on the
Xilinx Zynq-7000 Programmable System on a Chip (package XC7Z010CLG400-1)
field-programmable gate array.

The datapath at its current stage is capable of executing twenty-one individual
MIPS assembly instructions. Using forwarding and delayed branching, the datapath
does not encounter any errors with normal ALU instructions, and uses at most one
stall to handle data hazards after memory read functions.

The functionality is split across five individual stages - Instruction Fetch,
Instruction Decode, Execution, Memory Access, and Write-Back. These individual
pipeline stages execute one instruction per clock cycle each, and thanks to this
pipelined design can execute up to five instructions concurrently.

Thirty-five instructions are preloaded into the ROM (Instruction Memory) and are
all accessible via byte-addressed schemes. These instructions demonstrate the
datapath's capability to execute arithmetic/logical instructions, memory access
and data loading instructions, branching instructions, and jumping instructions.
The instructions also demonstrate the datapath's capability to avoid data and
control hazards through forwarding, delayed branching and delay slots, and (if
all else fails) through employing stalls.

In this project, the control unit contains the ALU control as well. Though these
units are generally separated, for the purposes of the project it serves little
purpose to separate them.

The individual pipeline registers are enabled through a clock signal, which
itself has an enable input which allows the datapath to keep processing
instructions.

The project's sources directory also contains a pair of helper source code files
which are extremely useful for testing, understanding, and implementing the
project itself. The python file `binToHexConverter.py` converts assembly code in
hexadecimal instructions into binary code for easy byte-addressing, which I used
to automatically generate the verilog code in the ROM and RAM. The assembly file
`ProjectInstructions.asm` contains the thirty-five instructions written in MIPS
assembly, which can be ran through MARS MIPS simulator. Together with the links
posted below, the project becomes far simpler to implement successfully.

## Detailed Functionality

The following is a (fairly oversimplified) explanation of how the datapath
project functions. Since the project handles information in five stages, I will
proceed to explain its functionality split into five simpler stages. The circuit
diagram above splits portions of the circuit physically into the stages (as
shown by the legend on the bottom).

The large red blocks shown in the circuit are pipeline registers, which do
nothing but pass through data untouched. However, they only update on the
positive edge of their clock input, and as such serve as barriers to ensure all
signals are passing to the next stages at the same times. This also ensures that
no errors occur with information processing too fast in certain parts, and being
loaded in while other data is still being processed.

Finally, at the top right of the circuit display, the three main MIPS
instruction formats are shown. In order, they are: Register format (r-format),
Immediate format (i-format), and Jump format (j-format). More information about
the individual MIPS instructions and their formatting can be found in the links
below.

The **Instruction Fetch** stage is responsible for fetching instructions from
the instruction memory (ROM) and passing them through. Since instructions in the
ROM are placed in sequential order, a program counter (PC) can be iterated with
an adder circuit to iterate through and access all ROM instructions.
Instructions are read out as 32-bit binary (or hexadecimal) addresses, but since
the ROM is byte-addressed, the PC needs to be iterated by 4 to ensure it only
accesses full 32-bit addresses (in MIPS, also known as words) instead of partial
splices of addresses.

Since the PC is utilized to reference which instruction the program is loading,
the iterated PC can be swapped out with various other values to jump to other
parts of the program. The multiplexer accomplishes this, using a line from the
control unit to select between the iterated PC, the target address of a
branching instruction, the target address of a register jump instruction, or
the target address of a normal jumping instruction.

Finally, in the event of any data hazards that cannot be solved through other
means, the pipeline registers of the instruction fetch stage (PC and IF/ID) are
enabled from the control unit. In the event of an unavoidable hazard, the
control unit can disable updating of these registers in order to halt loading of
new instructions.

The **Instruction Decode** stage is responsible for taking the binary
instruction and decoding it into the requisite signals needed for the rest of
the datapath to function. In this stage, register values are loaded from the
registry memory and sent along. There is a number of other functions that this
stage performs, as well.

First and foremostly, the control unit takes in signals from future stages in an
event to "predict" and circumvent any data hazards. In most cases, hazards will
not occur, so the register file output values can be fed through (using the
forwarding multiplexers, shown at the outputs `qa` and `qb` from the register
file). However, if some hazards occur, the control unit sends separate signals
to forward already-processed data from other instructions. Without having to
wait for those other instructions to be written back into the register files,
this can circumvent any unnecessary stalling and speed up the circuit's
execution substantially. Forwarding is done from the ALU output of the previous
instruction's (current) execution stage, from the ALU output of the second
previous instruction's memory access stage, and from the previous instruction's
data out stage.

It's important to note that delay slots are implemented to avoid hazards in code
execution. However, they are (in my opinion) extremely counter-intuitive, as the
delay slots themselves are executed and data _is written to the registers or
memory upon completion._ Programmers and compilers alike will often put
instructions here that do not affect other program flow, but these instructions
are not flushed.

In that last forwarding path, the previous instruction (if it is loading from
the data memory, or RAM) still needs one extra cycle to complete. The control
unit in this case will have to stall instructions, by setting the enable signal
of the PC and IF/ID pipeline registers to low. This will freeze the instructions
in those stages. However, instruction data will still be loaded into the
Instruction Decode stage. To prevent this, the current instruction is "flushed"
by sending signals to disable memory and register writing. The effect is that
the instruction is executed twice, but only the second execution step will
affect the state of the datapath.

In order to cut unnecessary stalls on branch instructions, branch equality is
checked at this stage. Similar to how the stalled instructions are "flushed",
the instruction after the branch instruction is always processed and executed,
but if the branch is not taken, that instruction is expressly disallowed to
modify data memory or write to registers.

Finally, certain signals are calculated and either passed back or passed through
to the next stages. In particular, any jump and branch targets are spliced from
the original instruction, and sent back to the Instruction Fetch stage to change
the program counter and affect program flow. Any destination register numbers
are selected by the control unit and are passed through. The "immediate" portion
of the instruction is extended, and the control unit determines whether this
extension is signed or unsigned. That value is passed along as well.

Many instructions might not use these calculated values, but for the sake of
simplicity all values are calculated at all times. The values that are not
needed are ignored later.

The control unit implements several control signals, and while the individual
control signals vary based on the source, this project utilizes the control
signals specified by Li's textbook. However, as long as all signals match up
with other circuitry, any arbitrary control signals should theoretically work.
A comprehensive table of control signals is given below.

| Instruction | `pcsrc` | `wreg` | `m2reg` | `wmem` | `jal` | `aluc` | `aluimm` | `shift` | `regrt` | `sext` |
| ----------- | ------- | ------ | ------- | ------ | ----- | ------ | -------- | ------- | ------- | ------ |
| `add`       | `00`    | `1`    | `0`     | `0`    | `0`   | `x000` | `0`      | `0`     | `0`     | `x`    |
| `sub`       | `00`    | `1`    | `0`     | `0`    | `0`   | `x100` | `0`      | `0`     | `0`     | `x`    |
| `and`       | `00`    | `1`    | `0`     | `0`    | `0`   | `x001` | `0`      | `0`     | `0`     | `x`    |
| `or`        | `00`    | `1`    | `0`     | `0`    | `0`   | `x101` | `0`      | `0`     | `0`     | `x`    |
| `xor`       | `00`    | `1`    | `0`     | `0`    | `0`   | `x010` | `0`      | `0`     | `0`     | `x`    |
| `sll`       | `00`    | `1`    | `0`     | `0`    | `0`   | `0011` | `0`      | `1`     | `0`     | `x`    |
| `srl`       | `00`    | `1`    | `0`     | `0`    | `0`   | `0111` | `0`      | `1`     | `0`     | `x`    |
| `sra`       | `00`    | `1`    | `0`     | `0`    | `0`   | `1111` | `0`      | `1`     | `0`     | `x`    |
| `jr`        | `10`    | `0`    | `0`     | `0`    | `0`   | `xxxx` | `0`      | `0`     | `0`     | `x`    |
| `nop`       | `00`    | `0`    | `x`     | `0`    | `0`   | `xxxx` | `x`      | `x`     | `x`     | `x`    |
| `addi`      | `00`    | `1`    | `0`     | `0`    | `0`   | `x000` | `1`      | `0`     | `1`     | `1`    |
| `andi`      | `00`    | `1`    | `0`     | `0`    | `0`   | `x001` | `1`      | `0`     | `1`     | `0`    |
| `ori`       | `00`    | `1`    | `0`     | `0`    | `0`   | `x101` | `1`      | `0`     | `1`     | `0`    |
| `xori`      | `00`    | `1`    | `0`     | `0`    | `0`   | `x010` | `1`      | `0`     | `1`     | `0`    |
| `lw`        | `00`    | `1`    | `1`     | `0`    | `0`   | `x000` | `1`      | `0`     | `1`     | `1`    |
| `sw`        | `00`    | `0`    | `x`     | `1`    | `0`   | `x000` | `1`      | `0`     | `x`     | `1`    |
| `beq`       | `0?`    | `0`    | `x`     | `0`    | `0`   | `x010` | `1`      | `0`     | `x`     | `1`    |
| `bne`       | `0?`    | `0`    | `x`     | `0`    | `0`   | `x010` | `1`      | `0`     | `x`     | `1`    |
| `lui`       | `00`    | `1`    | `0`     | `0`    | `0`   | `x110` | `1`      | `0`     | `1`     | `0`    |
| `j`         | `11`    | `0`    | `x`     | `0`    | `0`   | `xxxx` | `x`      | `0`     | `x`     | `x`    |
| `jal`       | `11`    | `1`    | `x`     | `0`    | `1`   | `xxxx` | `x`      | `0`     | `x`     | `x`    |

Certain signals are listed as "don't-cares", as their state is unnecessary for
functionality. For more information on what each individual signal does, see the
module definition for the control unit.

In the **Execution** stage, all calculations are performed. First and foremostly
the arithmetic logic unit handles the majority of all calculations, receiving
an ALU control signal from the control unit and performing the relevant function
given this ALU control signal. A comprehensive list of ALU control signals is
given below.

| `aluc` | Function | Meaning                | Expression      |
| ------ | -------- | ---------------------- | --------------- |
| `x000` | `ADD`    | Add                    | `out = a + b`   |
| `x100` | `SUB`    | Subtract               | `out = a - b`   |
| `x001` | `AND`    | Bitwise AND            | `out = a & b`   |
| `x101` | `OR`     | Bitwise OR             | `out = a \| b`  |
| `x010` | `XOR`    | Bitwise XOR            | `out = a ^ b`   |
| `x110` | `LUI`    | Load Upper Immediate   | `out = b << 16` |
| `0011` | `SLL`    | Shift Left Logical     | `out = b << a`  |
| `0111` | `SRL`    | Shift Right Logical    | `out = b >> a`  |
| `1111` | `SRA`    | Shift Right Arithmetic | `out = b >>> a` |

The inputs to the ALU can also be changed based on certain control signals. The
A input will either be the register/forwarded value from before, or the shift
amount, extracted from the immediate value portion of the original instruction.
The B input will either be the register/forwarded value from before, or the full
immediate value portion of the original instruction.

Finally, since the `jal` instruction has to not only calculate the return
address based on the original instruction's program counter reference, but also
store this value in the `$ra` return address register (register 31), this
instruction calculates it in this stage. Since the datapath uses a jump delay
slot, the true `jal` address has to be calculated to the program counter value
plus eight, or two instructions past the `jal` instruction. Finally, the switch
at the bottom sets the destination register number at 31 if the instruction is
a `jal` instruction.

The **Memory Access** stage has one singular component - the program's data
memory, or the RAM. If the instruction is a `sw` store word instruction, the
value out is written into the data memory. Otherwise, the data memory is just
read.

Finally, the **Write-Back** stage of the datapath is the final stage where
information is rewritten into the registers for storage and later use. A single
multiplexer selects whether the data written into the registers is coming from
the RAM or the ALU output. Finally, the data is sent alongside the destination
register number and a write-enable signal to the register file.

The register file is in use by the instruction decode stage of the third
previous instruction to the current one. In order to both read and write to the
registry memory in one clock cycle, the register file is written to at the
positive edge of the clock cycle and read from at the negative. This ensures
that data is properly updated, and the same resource isn't accessed for two
different purposes at the same time.

## Register-Transfer Level Schematic

A schematic of the working circuit is depicted below. This is automatically
generated thanks to Xilinx Vivado's built-in RTL analysis.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743343867654307872/unknown.png)

## Output Waveforms

The following are the waveforms generated by the project. Blue dividers split
the individual stages, and each image has and displays five individual assembly
instructions. The instructions as well as small descriptions of their functions
are listed below each image. Redundant or unnecessary signals (such as signals
that are purely repeated across pipeline registers, without any modification)
are excluded from this analysis. For simplicity's sake, signals are split into
groupings of five.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743273024177831946/unknown.png)

```asm
main:
		lui 		$at, 0
		ori 		$a0, $at, 80
		jal 		sum

dslot1:
		addi 		$a1, $zero, 4

sum:
		add 		$t0, $zero, $zero
```

The fourth instruction (`addi`) is placed in the delay slot here, executed, and
its data is written to the registers. The program counter jumps to the proper
address and continues execution.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743303717788319804/unknown.png)

```asm
loop:
		lw  		$t1, 0($a0)
stall:
		add 		$t0, $t0, $t1
		addi 		$a1, $a1, -1
		bne 		$a1, $0, loop
dslot5:
		addi 		$a0, $a0, 4
```

A stall occurs on the second instruction, which halts fetching of new
instructions during the third instruction, and prevents writing until the stall
has completed.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743302185059614740/unknown.png)

```asm
loop:
		lw  		$t1, 0($a0)
stall:
		add 		$t0, $t0, $t1
		addi 		$a1, $a1, -1
		bne 		$a1, $0, loop
dslot5:
		addi 		$a0, $a0, 4
```

This portion is the checking and recursing portion of the looping functionality.
It's revealed here that the delay slot value, being executed on every jumping
instruction, is the iterator for the loop. This cheeky implementation allows
the iteration to occur and process while the change in program counter is being
processed, thus better streamlining execution.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743306423554932816/unknown.png)

```asm
loop:
		lw  		$t1, 0($a0)
stall:
		add 		$t0, $t0, $t1
		addi 		$a1, $a1, -1
		bne 		$a1, $0, loop
dslot5:
		addi 		$a0, $a0, 4
```

This is the third iteration of our loop. As seen in the `eregisterQA` signal in
the fourth instruction's execution stage, the value is still not equal to zero,
so the cycle continues.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743311577700237413/unknown.png)

```asm
loop:
		lw  		$t1, 0($a0)
stall:
		add 		$t0, $t0, $t1
		addi 		$a1, $a1, -1
		bne 		$a1, $0, loop
dslot5:
		addi 		$a0, $a0, 4
```

This is the fourth and final iteration of the loop. The `eregisterQA` signal in
the fourth instruction's execution stage is equal to zero, so the loop has
finally ended at this point.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743319238063947787/unknown.png)

```asm
		jr  		$ra
dslot6:
		sll 		$v0, $t0, 0

return:
		sw  		$v0, 0($a0)
		lw  		$t1, 0($a0)
		sub 		$t0, $t1, $a0
```

The `lw` instruction (the fourth instruction) incurs a stall on the following
`sub` instruction.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743321224947564604/unknown.png)

```asm
		addi		$a1, $zero, 3
loop2:
		addi    	$a1, $a1, -1
		ori     	$t0, $a1, 0xffff 		# Immediate value: 65535
		xori    	$t0, $t0, 0x5555 		# Immediate value: 21845
		addi    	$t1, $zero, -1
```

The second looping portion of code is entered at this point.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743326192865902644/unknown.png)

```asm
		andi    	$t2, $t1, 0xffff 		# Immediate value: 65535
		or      	$a2, $t2, $t1
		xor     	$t0, $t2, $t1
		and 		$a3, $t2, $a2
		beq     	$a1, $zero, shift
```

The first iteration of this loop completes with a check, as well as a delayed
slot directly after.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743328231360561253/unknown.png)

```asm
dslot2:
		nop

		j   		loop2
dslot3:
		nop

loop2:
		addi    	$a1, $a1, -1
		ori     	$t0, $a1, 0xffff 		# Immediate value: 65535
```

In this second loop, the delay slot is not utilized to process the iteration.
Instead, `nop` instructions are inserted to ensure no control hazards take
place.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743329703015874600/unknown.png)

```asm
		xori    	$t0, $t0, 0x5555 		# Immediate value: 21845
		addi    	$t1, $zero, -1
		andi    	$t2, $t1, 0xffff 		# Immediate value: 65535
		or      	$a2, $t2, $t1
		xor     	$t0, $t2, $t1
```

These signals are more of the second loop portion.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743331039329517629/unknown.png)

```asm
		and 		$a3, $t2, $a2
		beq     	$a1, $zero, shift
dslot2:
		nop

		j   		loop2
dslot3:
		nop
```

The values in the registers `eregisterQA` and `eregisterQB` are not equal again
(in the second instruction listed in execution) so the loop is continued.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743333471367331900/unknown.png)

```asm
loop2:
		addi    	$a1, $a1, -1
		ori     	$t0, $a1, 0xffff 		# Immediate value: 65535
		xori    	$t0, $t0, 0x5555 		# Immediate value: 21845
		addi    	$t1, $zero, -1
		andi    	$t2, $t1, 0xffff 		# Immediate value: 65535
```

This is the second and final iteration of the second loop.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743337222815875162/unknown.png)

```asm
		or      	$a2, $t2, $t1
		xor     	$t0, $t2, $t1
		and 		$a3, $t2, $a2
		beq     	$a1, $zero, shift
dslot2:
		nop
```

The final iteration of the loop ends with the fourth instruction in execution
having `eregisterQA` and `eregisterQB` equivalent. This ends the loop and jumps
to the shift portion of the code.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743341554915213342/unknown.png)

```asm
shift:
		addi 		$a1, $zero, -1
		sll 		$t0, $a1, 15
		sll 		$t0, $t0, 16
		sra 		$t0, $t0, 16
		srl 		$t0, $t0, 15
```

These are the last major instructions that execute - shifting the bits back and
forth.

![img](https://cdn.discordapp.com/attachments/385581009653202945/743342828176015392/unknown.png)

```asm
finish:
		j   		finish
dslot4:
		nop

finish:
		j   		finish
dslot4:
		nop
# This cycle repeats infinitely.
```

The program "ends" with an infinite loop, with the `nop` instruction in the
delay slot constantly executing and doing nothing.

## Project Filestructure

The modules are individually sorted into folders depending on their stage in the
datapath. At the highest level, the Datapath module contains all of the wiring
and connecting instructions for all other modules, excluding the clock module.

    Five-Stage-Datapath.srcs
    ├───helper                      # Contains project helper code
    ├───modules                     # Contains all design sources
    │   ├───execution
    │   ├───instruction-decode
    │   ├───instruction-fetch
    │   ├───memory-access
    │   ├───pipeline
    │   └───write-back
    └───simulation                  # Contains all simulation sources

## Helpful Links

Here are some helpful links that are useful to read up alongside the project.

-   [MARS Mips Simulator](http://courses.missouristate.edu/kenvollmar/mars/):
    A MIPS assembler and runtime simulation applet written in Java.
-   [MIPS Instruction Styleguide](https://cs233.github.io/mipsstyle.html):
    A style-guide for help with MIPS formatting.
-   [MIPS Converter](https://www.eg.bucknell.edu/~csci320/mips_web/):
    A tool developed by Bucknell University for converting MIPS assembly code to
    binary and hexadecimal instructions.
-   [MIPS Instruction Reference](http://www.mrc.uidaho.edu/mrc/people/jff/digital/MIPSir.html):
    This is a reference of all MIPS instructions and their meanings/syntax.
-   [Computer Principles and Design in Verilog HDL](https://www.amazon.com/Computer-Principles-Design-Verilog-HDL/dp/1118841093/):
    This is the textbook from which the original circuit design comes from. I
    mainly used this to get the control signals for the project.

# License TL;DR

This project is distributed under the MIT license. This is a paraphrasing of a
[short summary](https://tldrlegal.com/license/mit-license).

This license is a short, permissive software license. Basically, you can do
whatever you want with this software, as long as you include the original
copyright and license notice in any copy of this software/source.

This project is a curriculum-based project. I do NOT condone any re-use of this
code or intellectual property that results in academic integrity violations.
Furthermore, I am not responsible for any re-use of this code that creates any
academic integrity violations.

## What you CAN do:

-   You may commercially use this project in any way, and profit off it or the
    code included in any way;
-   You may modify or make changes to this project in any way;
-   You may distribute this project, the compiled code, or its source in any
    way;
-   You may incorporate this work into something that has a more restrictive
    license in any way;
-   And you may use the work for private use.

## What you CANNOT do:

-   You may not hold me (the author) liable for anything that happens to this
    code as well as anything that this code accomplishes. The work is provided
    as-is.

## What you MUST do:

-   You must include the copyright notice in all copies or substantial uses of
    the work;
-   You must include the license notice in all copies or substantial uses of the
    work.

If you're feeling generous, give credit to me somewhere in your projects.
