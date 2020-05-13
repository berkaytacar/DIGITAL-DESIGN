module clock_divider(clk,outclk,constant, reset);
input clk;
input reset;
input [31:0] constant;

output reg outclk;
//wire outclk;
reg [31:0] count=32'd0;


// ask if system ver always_ff or always
// ask negedge or posedge reset

always @(posedge clk) begin // ask synch or asynch reset 
    if (reset) count <=32'b0;// count is 0 if reset
    else begin
    // if it's equal to that constant, reset count and NOT outclk
    // outclk is initialized as 0, so it's now 1 etc
        if(count==constant-1) begin // or maybe -1
            count <= 32'b0;
            outclk <= ~outclk;
        end
        else begin// if not that const, then increment count 
            count <= count+1;
            outclk <= outclk;// outclk stays the same
        end
      
    end 
end

endmodule

