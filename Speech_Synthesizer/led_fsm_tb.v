//module lfsr(clk, reset, lfsr);
module led_fsm_tb();
/*
module led_fsm(clk, audio_in, led);
input clk;
input [7:0] audio_in;
output reg [7:0] led;*/
reg sim_clk;
reg [7:0] audio_in;
wire [7:0] led;

led_fsm dut (
.clk(sim_clk),
.audio_in(audio_in),
.led(led)
);

// simulation for the clk 
 initial begin
    sim_clk = 0; 
    #2
    forever begin
      sim_clk = 1; 
      #2
      sim_clk = 0; 
      #2  
      sim_clk= 0; 
    end
  end

  initial begin
    //reset=0;
    audio_in=8'b0000_0001;
    #10
    audio_in=8'b0001_0000;
    #10
    audio_in=8'b0001_0010;
    #10
    audio_in=8'b1111_0010;
    #10
    audio_in=8'b1110_0000;
    #10
    audio_in=8'b0111_1111;
    #3000


  $stop;
end

endmodule 
