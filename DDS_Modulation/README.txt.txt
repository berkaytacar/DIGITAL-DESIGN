1. Solution file is under the lab5 directory:
dds_and_nios_lab_time_limited.sof

2. all verilog files are under the lab5 directory:
ask.v
bpsk.v
clock_divider.v
dds_mod.v // Basically the state machine setting the outputs
dds_and_nios.v
lfsr.v
slow_fast_clk.v
fast_slow_clk.v

software the c code is inside software\lab5\student_code

everything built through nios and qsys 
* QSYS files under lab5\DE1_SoC_QSYS
* NIOS files under lab5\software\lab5
* NIOS bsp is under lab5\software\lab5_bsp
NOTE: New_configuration (12) and New_configuration (11) WORKS 

3.Everything works

4.simulations inside the simulations folder

5.photos proving that the modulations work: ask, bpsk, fsk, lfsr inside
the simulations folder

NOTE: SOMETIMES CAN'T GET THE "RUN" IN NIOS II TO BECOME AVAILABLE, 
CLOSING QUARTUS, NIOS SW AND POWERING OFF THE DE1-SOC, AND TRYING AGAIN
USUALLY WORKS

 