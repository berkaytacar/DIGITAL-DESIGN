// fast to slow clk
// reference to the lecture slides
// clock_skew_clock_domains slide 78
module fast_slow_clk(clk_s, clk_f, in, out);
input clk_s, clk_f;// clk1 is fast clk2 is slow
input [11:0] in;
output [11:0] out;

wire [11:0] w_reg1_3, w_reg3_2;
wire w1, w_en;
// figures from the lec slides

// data is 12 bits, instantiated in the top module 
VDFF_12b reg1(.clk(clk_f), .in(in), .out(w_reg1_3));

VDFFE_12b reg3(.clk(clk_f), .en(w_en), .in(w_reg1_3), .out(w_reg3_2));// the reg in the middle with enable
VDFF_12b reg2(.clk(clk_s), .in(w_reg3_2), .out(out));

// the registers at the bottom for  creating enable
VDFF1 reg4(.clk(~clk_f), .in(clk_s), .out(w1));
VDFF1 reg5(.clk(~clk_f), .in(w1), .out(w_en));

endmodule

// flip flop
module VDFF1(clk, in, out);
input clk;
input in;
output reg out;

always@(posedge clk)begin
    out <= in;
end
endmodule

// 12 bits
module VDFF_12b(clk, in, out);
input clk;
input [11:0] in;
output reg [11:0] out;

always@(posedge clk)begin
    out <= in;
end

endmodule

// flip flop with enable
module VDFFE1(clk, en, in, out);
input clk, en;
input in;
output reg out;

always@(posedge clk)begin
    if(en)
        out <=in;
end

endmodule
// 12 bits
module VDFFE_12b(clk, en, in, out);
input clk, en;
input [11:0]in;
output reg [11:0] out;

always@(posedge clk)begin
    if(en)
        out <=in;
end

endmodule
