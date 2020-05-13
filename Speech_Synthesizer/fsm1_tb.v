//module fsm1(clk, r_d_valid, wait_req, read, in, out, done, en, out_read);
module fsm1_tb();
/*
input clk, r_d_valid, wait_req, read;// start
input [31:0] in;// read data in
output reg [31:0] out;// read data out
output done;// finish
output reg [3:0] en;//byteenable
output out_read;// read*/
reg sim_clk;
reg r_d_valid, wait_req, read;
reg [31:0] in;
wire [31:0] out;
wire done, out_read;
wire [3:0] en;

fsm1 dut (
.clk(sim_clk),
.r_d_valid(r_d_valid), .wait_req(wait_req), .read(read), 
.in(in), .out(out), .done(done), // finish read is output here
.en(en), .out_read(out_read));


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