1. PicoBlaze and some verilog files are inside the current directory:
ctrl_fsm.v	main fsm for addressing
fsm1.v 		to read
led_fsm.v 	for averaging displaying LEDs
narrator_ctrl.v

speech.psm

some verilog files are:
clock_divider.v
picoblaze_template.v
pulse_edge
speech_synth.v   (top_module)
speed_U_D.v
pacoblaze_instruction_memory.v
SPPECH_MEM

2.LED display, Keyboard (E to play, D to pause), Speed up and down are 
all working
FSMs work to go to the correct address
8b10b encode/decode
speech synthesizer

3.simulations inside the simulations folder

4.simulation from signaltap and modelsim show that my led_fsm and reading fsms
work, addressing fsm work as well.



 