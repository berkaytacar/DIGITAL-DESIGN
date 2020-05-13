//module ctrl_fsm(clk, done_read, sync, play, start_addr,
//				finish_addr, data_in_read, start_flag, flash_data_audio,
//				addr, start_from_pico, finish_to_pico);
module ctrl_fsm_tb();
reg done_read;
reg sync;// pulse 
reg play; 
reg sim_clk;
reg [23:0] start_addr;
reg start_from_pico;
reg [23:0] finish_addr;
reg [31:0] data_in_read;

wire start_flag;
wire [7:0] flash_data_audio;
wire [23:0] addr;
wire finish_to_pico;





ctrl_fsm dut(.clk(sim_clk), .done_read(finish_read), .sync(pulse), .play(play), .start_addr(start_address_n_ctl),
        .finish_addr(end_address_n_ctl), .data_in_read(read32b_data_out), .start_flag(start_read), 
        .flash_data_audio(audio_data), .addr(flash_mem_address), .start_from_pico(start_from_pico), 
        .finish_to_pico(finish_to_pico));


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
    r_d_valid = 0; 
    #3
    forever begin
      r_d_valid = 1; 
      #3
      r_d_valid = 0; 
      #3  
      r_d_valid= 0; 
    end
  end

  initial begin
    //reset=0;
 wait_req=0;
 read=0;
 in=32'h10;
 #10
 #5
 read=1;
 in=32'h1;
 #15
 read=0;
 #50
in=32'h25;

#10;
read=1;
#10

    //#3000


  $stop;
end

endmodule 