# FPGBA

GBA on FPGA

GBA Implementation in VHDL for FPGA from scratch.

In scope:
- all videomodes including affine and special effects
- all soundchannels
- saving as in GBA
- turbomode(target is 2x Speed)
- pixelperfect-scaling with framebuffer

Out of scope:
- Multiplayer features like Serial
- GBA Module function(e.g. Boktai sun sensor)
- savestates
- debugging on hardware (VHDL simulation should be enough)
- all Peripheral like VGA/HDMI, SDRAM, Controller, ....

# Target Boards
1. Terasic DE2-115 (done)
2. Terasic DE-10(Mister) (done)
3. Analogue Pocket(if jailbreak possible) - future work
4. Xilinx ZCU104 - future work

# Status: 

~1600 games tested until ingame:
- 95% without major issues (no crash, playable)
- some crashes open due to CPU bugs (don't happen in software model)
- some bugs open due to unknown reasons (also happen in software model)

VHDL:
- CPU done
- Graphic implemented
- Sound implemented
- Turbomode fully working
- saving with EEPROM/SRam/FLASH ok
- all registers implemented

Missing big parts:
- none

Software model, instruction-cycle-based Emulator in C#:
- all features done
- Armwrestler Tests 100% pass
- ~300 Games tested (due to lack of time, most only until getting ingame)
-> considered complete for now, can be used as "known good" for 99%.

# FPGA Ressource usage (GBA only, without Framebuffer)

- 26000 LE (LUTS+FF), 9500 CPU, 8000 GPU
- 2Mbit Ram used for WRAM fast, VRAM, Palette, OAM
- WRAM Slow, Gamepak and Saves(EEPROM, SRAM, Flash) are on SDRam.

# Accuracy

There is great testsuite you can get from here: https://github.com/mgba-emu/suite
It tests out correct Memory, Timer, DMA, CPU, BIOS behavior and also instruction timing. It works 100% on the real GBA.
The suite itself has several thousand single tests. Here is a comparison with mGBA, VBA-M and Higan

Testname | TestCount | FPGBA | mGBA | VBA-M | Higan
---------|-----------|-------|------|-------|-------
Memory   |      1552 |  1538 | 1552 |  1337 | 1552
IOREAD   |       123 |   123 |  116 |   100 |  123
Timing   |      1660 |  1408 | 1520 |   628 | 1424
Timer    |       936 |   443 |  511 |   440 |  464
Carry    |        93 |    93 |   93 |    93 |   93
BIOSMath |       625 |   625 |  625 |   425 |  625
DMATests |      1256 |  1136 | 1160 |  1008 | 1064


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

# Open Bugs/Features

All tracked in the issues list. If you find new bugs or features missing, feel free to enter a new issue.
