# FPGBA

GBA on FPGA

GBA Implementation in VHDL for FPGA from scratch.

In scope:
- all videomodes including affine and special effects
- all soundchannels
- saving as in GBA
- Fast Forward(2-4x Speed depending on game)
- pixelperfect-scaling with framebuffer
- CPU Turbo mode
- Savestates
- Rewind
- Color optimization
- Cheats engine

Out of scope:
- Multiplayer features like Serial
- GBA Module function(e.g. Boktai sun sensor)
- debugging on hardware (VHDL simulation should be enough)
- all Peripheral like VGA/HDMI, SDRAM, Controller, ....

# Target Boards
1. Terasic DE2-115 (done)
2. Terasic DE-10 Nano(Mister) (done)
3. Nexys Video (done)
4. Analogue Pocket(if jailbreak possible) - future work

# Status: 

~1600 games tested until ingame:
- 99% without major issues (no crash, playable)

# FPGA Ressource usage (GBA only, without Framebuffer)

- 37000 LE (LUTS+FF), 13000 CPU, 9000 GPU
- 1,3Mbit Ram used for WRAM fast, VRAM, Palette, OAM
- 600Kbit used for Framebuffer
- WRAM Slow, Gamepak and Saves(EEPROM, SRAM, Flash) are on SDRam/DDRRam.

# Accuracy

(Status 03.02.2020)

>> Attention: the following comparisons are NOT intended for proving any solution is better than the other.
>> This is solely here for the purpose of showing the status compared to other great emulators available.
>> It is not unusual that an emulator can play games fine and still fail tests. 
>> Furthermore some of these tests are new and not yet addressed by most emulators.

There is great testsuite you can get from here: https://github.com/mgba-emu/suite
It tests out correct Memory, Timer, DMA, CPU, BIOS behavior and also instruction timing. It works 100% on the real GBA.
The suite itself has several thousand single tests.

Testname      | TestCount | FPGBA | mGBA | VBA-M | Higan
--------------|-----------|-------|------|-------|-------
Memory        |      1552 |  1552 | 1552 |  1338 | 1552
IOREAD        |       123 |   123 |  116 |   100 |  123
Timing        |      1660 |  1554 | 1540 |   692 | 1424
Timer         |       936 |   445 |  610 |   440 |  457
Timer IRQ     |        90 |    65 |   70 |     8 |   36
Shifter       |       140 |   140 |  140 |   132 |  132
Carry         |        93 |    93 |   93 |    93 |   93
BIOSMath      |       625 |   625 |  625 |   625 |  625
DMATests      |      1256 |  1248 | 1232 |  1032 | 1136
EdgeCase      |        10 |     3 |    7 |     3 |    1
Layer Toggle  |         1 |  pass | pass |  pass | fail 
OAM Update    |         1 |  fail | fail |  fail | fail


A complex CPU only testuite can be found here: https://github.com/jsmolka/gba-suite

Testname | FPGBA | mGBA | VBA-M | Higan
---------|-------|------|-------|-------
ARM      |  Pass | Fail |  Fail |  Fail
THUMB    |  Pass | Fail |  Fail |  Fail


# Buscycle Accuracy

This core is NOT buscycle accurate.
It does not try to be it and it was no goal when developing it.
Instead it aims to be instruction cycle accurate.
Reasons:

- It's difficult. The ARM7TDMI in GBA is not like the ARM7TDMI in the ARM documentation. It has bugs, it has gamepak prefetch, it has different timing behavior.
Most of the changes/bugs are not properly documented. Emulators sourcecodes are helping a bit, bus as they all are not buscycle accurate...

- The GBA doesn't need it for most of the games. GBA games are typically not written in Assembler and not on the edge with timing.

- The GBA does not (always?) support mid line graphical changes.
So the games usually don't do it and if things look strange it most times due to incorrect behavior and not due to timing.

- The hardware would need to guarantee memory access speed.
Full speed means down to 2 cycles = ~119ns random access time and ~59ns sequential access time for the fastest gamepaks. Guaranteed!
With SRAM no problem, but 32Mbyte SRAM is hard to get. With SDRam and refresh...

- To compensate for that, the core uses microbuffering that runs up to ~100 cycles ahead, 
so the core has some time to compensate if the game is doing things that the core can't do fast enough.
As the core is on average 2x as fast, this usually is enough and 100 cycles is not noticable.
This is below 0.001% of speed jitter and below 0.3% even for single sound samples.

However, it still has the advantages of an FPGA implementation:
- zero additional input latency
- steady output without any flicker, tearing, delay
- low power standalone device

# BIOS:

The BIOS is NOT provided in the repo obviously. Instead there is a script to convert the bios to the VHDL module.
You need to provide the BIOS yourself or use the one checked in, which is opensource. 
However, this opensource-BIOS will crash in the test, so it's unsure how good it is.
All credit goes to Normmatt.

# How to Build

## Terasic DE2-115

- Use the files checked in and put them into a Quartus 18.1 project
- Connect your own SDRAM(Gamepak) and SDRAM/SRAM/Blockram interface for the other RAMs
- Connect your video and sound output to the ports
- Provide some way of input
- If you need assistance with some parts, contact me

- Help for Audio: https://github.com/AntonZero/WM8731-Audio-codec-on-DE10Standard-FPGA-board 
- Help for SDRam: https://github.com/bonfireprocessor/bonfire-soc/blob/master/sdram/SDRAM_Controller.vhd
- Help for Video: seriously, there are thousands of VGA cores

## Terasic DE-10 Nano

See 
https://github.com/MiSTer-devel/GBA_MiSTer


## Nexys Video

- Use the files checked in and put them into a Vivado 2019.2 project
- Replace some files with the ones in the nexysvideo folder (see below)
- Instantiate a MIG7 native DDR3 interface and connect ALL Memory Busses to it (that works, as they never access at the same time)
- Connect your video and sound output to the ports
- Provide some way of input
- If you need assistance with some parts, contact me

- Help for Video: https://github.com/fcayci/vhdl-hdmi-out
- Help for Audio: https://github.com/Digilent/NexysVideo/tree/master/Projects/Looper


Thanks to Xilinx bad synthesis and optimizations tools, some files need to be changed. Reasons:

- Vivado doesn't like Dualport Memories within a single process. 
While this is completly correct and the only way to simulate the memory, 
they just state that you have written it that way, but they don't give you Blockram until you rewrite your code so it's no longer valid VHDL,
as now the signal is driven from two processes instead of one.

- When doing a mod by 256 or 512 on an Integer, that's just a nice way to write that I want to just take the last 8 or 9 bits.
Having it convert to Signed/Unsigned, taking the bits, and convert back looks very ugly instead.
However, Vivado decides to do a full division instead(on all 20 Bits) and fails the timing.

- When multiplying by either 16, 32, 64 or 128, it should be obvious, that this is just a shift by either 4,5,6 or 7.
Again Vidado instead wants to do a full multiplication at this point with DSP slices and fails the timing.

- There is still a bug inside the 3rd soundchannel on some GBA Register, because Vivado just can't convert internal tristate busses to and/or combined logic correct.
To do this properly, the tristate bus must be at least split from record to single signals, 
as Vivado does detect tristate busses in records as multiple driver signals, which is nothing more than a bug.

It is worth noting, that Altera/Intel gets all these things easily detected and optimized correct, so that the FPGA behaves like the simulation does.

# Open Bugs/Features

All tracked in the issues list. If you find new bugs or features missing, feel free to enter a new issue.
