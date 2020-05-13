module fast_slow_clk_tb();

//module slow_fast_clk(clk_s, clk_f, in, out);
reg clk_s, clk_f;// clk1 slow, clk2 fast
reg [11:0] in;
wire [11:0] out;

fast_slow_clk dut (
.clk_s(clk_s),
.clk_f(clk_f),
.in(in),
.out(out)
);

// simulation for the clk 
 initial begin
    clk_s = 0; 
    #5
    forever begin
      clk_s = 1; 
      #5
      clk_s = 0; 
      #5  
      clk_s= 0; 
    end
  end

  // simulation for the clk 
 initial begin
    clk_f = 0; 
    #5
    forever begin
      clk_f = 1; 
      #1
      clk_f = 0; 
      #1  
      clk_f= 0; 
    end
  end

  initial begin
   in=10;
   #3
   in=1;
   #2
   in=0;
   #2
   in=1;
   #1
   in=5;
   #3
   in=54;
   #2
   in=4;

   #2
    in=3;

    #3

    in=20;

    #3
    in=4;
    #3
    in=7;
    #3 
    in=11;
    #2

    in=2;
    #12

    in=30;
    #4

    in=1;
    #7




  $stop;
end

endmodule 
