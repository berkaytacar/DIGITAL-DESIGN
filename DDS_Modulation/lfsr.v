module lfsr(clk, reset, lfsr);
input clk, reset;
output reg [4:0] lfsr= 5'b00_001;// initialize at 1

always@(posedge clk)begin
    if(reset)begin
        lfsr <= 5'b00_001;// reset back to 1
    end
    else begin
        // most sig bit is XORed, and rest is shifted
        // 4 to posuition 3, 3 to position 2 etc...
        lfsr <= {lfsr[2]^lfsr[0], lfsr[4:1]};
    end
end

endmodule

