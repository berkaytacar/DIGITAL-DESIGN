module ask(clk, en_signal, in, out);
input clk, en_signal;
input [11:0] in;
output reg [11:0] out;

// Amplitude Shift Keying or On Off Keying
// en_signal which is lfsr[0]

always@(posedge clk)begin
    if(en_signal)// if lfsr0 is 1 then
        out <= in;// out is in
    else 
        out <= 12'b0;// else stay 0
end

endmodule

