module speed_U_D(clk, down, up, reset, speed_out_val);
input clk;
input down;
input up;
input reset; // to reset it back to narmal speed
output reg [31:0] speed_out_val;
wire [2:0] sel;

//reg flag=1'b0;
assign sel={down, up, reset};

always@(posedge clk)begin
    case(sel)
    3'b100:speed_out_val <= 32'd25_000_000/32'd7200 - 32'd5000;// down
    3'b010: speed_out_val<= 32'd25_000_000/32'd7200 + 32'd5000;//up
    3'b001: speed_out_val<= 32'd25_000_000/32'd7200;// normal
    default: speed_out_val <= 32'd25_000_000/32'd7200;
    endcase
end


endmodule

/*
    if(flag==1'b0)begin
        speed_out_val <= 32'd25_000_000/32'd7200; // for 7200 hz
        flag <= 1'b1;
    end
    else begin
        if(down)
            speed_out_val<= speed_out_val- 32'd16;
        else if(up)
            speed_out_val<= speed_out_val+ 32'd16;
        else if(reset)// back to normal
            speed_out_val<= 32'd25_000_000/32'd7200;

    end
    */