
vcom -93 -quiet -work  sim/mem ^
src/mem/SyncFifo.vhd ^
src/mem/SyncRam.vhd ^
src/mem/SyncRamDual.vhd ^
src/mem/SyncRamDualByteEnable.vhd ^
src/mem/SyncRamDualNotPow2.vhd 

vcom -quiet -work sim/gba ^
src/gba/proc_bus_gba.vhd ^
src/gba/reggba_timer.vhd ^
src/gba/reggba_keypad.vhd ^
src/gba/reggba_serial.vhd ^
src/gba/reggba_sound.vhd ^
src/gba/reggba_display.vhd ^
src/gba/reggba_dma.vhd ^
src/gba/reggba_system.vhd ^
src/gba/reg_savestates.vhd ^
src/gba/gba_bios.vhd ^
src/gba/gba_reservedregs.vhd ^
src/gba/gba_sound_ch1.vhd ^
src/gba/gba_sound_ch3.vhd ^
src/gba/gba_sound_ch4.vhd ^
src/gba/gba_sound_dma.vhd ^
src/gba/gba_sound.vhd ^
src/gba/gba_joypad.vhd ^
src/gba/gba_serial.vhd ^
src/gba/gba_dma_module.vhd ^
src/gba/gba_dma.vhd ^
src/gba/cache.vhd ^
src/gba/gba_cheats.vhd ^
src/gba/gba_memorymux.vhd ^
src/gba/gba_timer_module.vhd ^
src/gba/gba_timer.vhd ^
src/gba/gba_statemanager.vhd ^
src/gba/gba_savestates.vhd ^
src/gba/gba_gpiodummy.vhd ^
src/gba/gba_gpu_timing.vhd ^
src/gba/gba_gpu_colorshade.vhd ^
src/gba/gba_drawer_mode0.vhd ^
src/gba/gba_drawer_mode2.vhd ^
src/gba/gba_drawer_mode345.vhd ^
src/gba/gba_drawer_obj.vhd ^
src/gba/gba_drawer_merge.vhd ^
src/gba/gba_gpu_drawer.vhd ^
src/gba/gba_gpu.vhd ^
src/gba/gba_gpioRTCSolarGyro.vhd

vcom -2008 -quiet -work sim/gba ^
src/gba/gba_cpu.vhd ^
src/gba/gba_top.vhd

vcom -2008 -quiet -work sim/top ^
src/top/framebuffer.vhd