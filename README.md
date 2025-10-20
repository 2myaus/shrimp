# SHRIMP
SHRIMP is short for SPLENDIDLY NAMED COMPUTER

This is a personal project aiming to design a custom CPU, assembler, compiler target, and operating system. My goals are to learn VHDL and gain a better understanding of computer architecture from the physical level. As of writing this, the processer/memory is functioning and a basic assembler can compile binary programs from human-readable Shrimp Assembly (shrasm).

As of writing, the following have been completed:
- Functional CPU, Hardware/Logic design in VHDL (ALU, memory file, registers, instruction counter, instruction decoder, etc)
- 16-bit instruction definitions
- Human-readable assembly (shrasm) and assembler to compile binaries, in C++

Some current goals are:
- Better documentation of SHRASM instructions and best practices
- Memory mapped IO
- more pseudoinstructions like jump, load upper, etc
- C code compiling to SHRASM
- Linker memory layout definitions
