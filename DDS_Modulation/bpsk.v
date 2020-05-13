module bpsk(clk, lfsr0, in, out);
input clk;
input lfsr0;
input [11:0] in;
output reg [11:0] out;

// binary phase shift keying
always@(posedge clk)begin
    if(lfsr0)
        out <= in;// if lsr0 then keep out as in
    else begin // if lsr0 is 0
        if(in==12'b0)// check if in is 0
            out <= 12'b0;// then out is 0 as well
        else 
            // same as amplitude shifting 
            // refernce to the lecture slides amplitude shifting
            out <= (~in /*+ 1'b1*/);// otherwise phase shift 2's complement
    end

end

endmodule
