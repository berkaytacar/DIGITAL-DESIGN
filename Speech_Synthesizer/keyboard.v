module keyboard(clk, ready, code, play);
input clk;
input ready;
input [7:0] code; // received from keyboard

output reg play;// sig to play

parameter E= 8'h45;// start
parameter D= 8'h44;// pause
parameter e1= 8'h65;
parameter d1= 8'h64;

always@(*)begin
    case(code)
    8'h45: play =1'b1;//E
    8'h44: play =1'b0;//D
    8'h65: play =1'b1;
    8'h64: play =1'b0;
    default: play= play;
    endcase
end

endmodule

