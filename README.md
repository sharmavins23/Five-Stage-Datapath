# Five Stage Datapath

This project is a simplified version of a MIPS assembly architecture based
datapath, created for my computer architecture class. The finalized circuit is
shown below.

![img](https://camo.githubusercontent.com/3508ea9870ab67374ad443b21253e9b657eb7d16/68747470733a2f2f63646e2e646973636f72646170702e636f6d2f6174746163686d656e74732f3730383439333337353734353033323231332f3733303838353437353436333732353135362f756e6b6e6f776e2e706e67)

## Overview

The project is a 32-bit CPU designed to execute MIPS assembly code loaded in. It
runs on the XC7Z010CLG400-1 FPGA.

Currently, it is capable of several instructions, but mostly has implementations
for `lw: load memory word` and `sw: store memory word`. At the current stage of
the project, the first four stages (Instruction Fetch, Instruction Decode,
Execution, and Memory Access) are implemented. Four `lw` instructions are
preloaded into the instruction memory, and several data values are preloaded
into the data memory block. These instructions are loaded and executed to load
data memory values.

The clock signal has an enable input that, when high, allows the register to
keep processing. In the testbench, the individual clock cycles are also tracked
to show where the individual programs are in the datapath.

The current version of the design faces many issues with timing hazards, as
while the processor is pipelined, instructions that require synchronous
execution will load false data values ahead of each other. However, the project
is still a work in progress.

## Circuit Schematic

A schematic of the working circuit is depicted below. This is automatically
generated thanks to Xilinx Vivado's built-in RTL analysis.

![img](https://cdn.discordapp.com/attachments/708493375745032213/735331637214183457/unknown.png)

## Sample Waveforms

This is a sample of the waveform output that the project currently generates.

![img](https://cdn.discordapp.com/attachments/708493375745032213/735330083807559691/unknown.png)

## Project Filestructure

The modules are individually sorted into folders depending on their stage in the
datapath. At the highest level, the Datapath module contains all of the wiring
and connecting instructions for all other modules, excluding the clock module.

    Five-Stage-Datapath.srcs
    ├───modules                     # Contains all design sources
    │   ├───execution
    │   ├───instruction-decode
    │   ├───instruction-fetch
    │   ├───memory-access
    │   └───pipeline
    └───simulation                  # Contains all simulation sources

## To-do

This project is in an unfinished version, and as such, there's a lot of work in
optimization, functionality implementation, and documentation left to do.

-   Add functionality for write-back stage
-   Fix data hazards with stalls
-   Fix data hazards with forwarding
-   Add branching functionality
-   Add jump functionality
-   Add branch prediction functionality (mostly static)
-   Update documentation with information about MIPS instruction set
-   Update documentation with information about MIPS datapath

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
