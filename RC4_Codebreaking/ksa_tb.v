module ksa_tb();
	reg CLOCK_50;
	reg [3:0] KEY;
	reg [9:0] SW;
	wire [9:0] LEDR;
	wire [6:0] HEX0;
	wire [6:0] HEX1;
	wire [6:0] HEX2;
	wire [6:0] HEX3;
	wire [6:0] HEX4;
	wire [6:0] HEX5;

// device under test
ksa dut (
.CLOCK_50(CLOCK_50),
.KEY(KEY),
.SW(SW),
.LEDR(LEDR),
.HEX0(HEX0),
.HEX1(HEX1),    
.HEX2(HEX2),
.HEX3(HEX3),
.HEX4(HEX4),
.HEX5(HEX5)
);

// simulation for the clk 
 initial begin
    CLOCK_50 = 0; 
    #5
    forever begin
      CLOCK_50 = 1; 
      #5
      CLOCK_50 = 0; 
      #5  
      CLOCK_50= 0; 
    end
  end

initial begin
#500

$stop;
end

endmodule 