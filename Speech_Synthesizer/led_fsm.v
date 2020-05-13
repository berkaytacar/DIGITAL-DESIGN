module led_fsm(clk, audio_in, led, play);
input clk;
input [7:0] audio_in;
input play;
output reg [7:0] led;

reg [4:0] state;
reg [31:0] sum=32'b0;// sum initialize with 0
reg [7:0] count, num, w;
reg [7:0] avg;

parameter [4:0] idle = 5'b0_00_00;//
parameter [4:0] pos_or_neg = 5'b0_00_01;// 
parameter [4:0] increment = 5'b0_00_10; //
parameter [4:0] take_abs_v = 5'b0_00_11;//
//parameter [4:0] increment = 5'b0_01_00;  
parameter [4:0] average = 5'b0_01_00;//
parameter [4:0] show = 5'b0_01_01;


always@(posedge clk)begin
    case(state)
    idle: begin
        state <= pos_or_neg;
        count <=8'd0;
        sum <=32'b0;
    end
    pos_or_neg: begin
        //count <= count+8'd1;
        if(audio_in[7]==1'b0) begin// if MSB is 0, then it's positive
            num <= audio_in;// if positive, num is audio in
            state <= increment;
            //count <= count+8'd1;//count
        end
        else begin// if negative
            //count <= count+8'd1;
            //w <= 
            state <= take_abs_v;// go to abs value
        end

    end
    increment: begin
        sum <= sum+ num;
        count <= count+8'd1;
        // if not 255, 
        if(count != 8'hFF) begin
            state <= pos_or_neg; //check if pos or neg and increment
        end
        else
            state <= average;
    end
    take_abs_v: begin
        //abs_v <= xored-a // and xored= in^a
        state <= increment;// go to increment
        num <= (audio_in^8'b1111_1111) + 8'd1;
    end

    average: begin
        state <= show;
        avg <= sum/ 32'd256;
    end
    show: begin
        if(play==1'b0 || audio_in==8'b0) led <= 8'b0000_0000;
        if(avg[7]) led <= 8'b1111_1111;// if MSB is 1, from ledr2 to ledr9 ON
        //else if(avg[6]) led <= 8'b1111_1110;
        else if(avg[6]) led <= 8'b1111_1110;// if 6th bit pos 1, ledr3 to ledr9 ON
        else if(avg[5]) led <= 8'b1111_1100;// if 5th bit pos 1, ledr4 to ledr9 ON
        else if(avg[4]) led <= 8'b1111_1000;// if 4th bit pos 1, ledr5 to ledr9 ON
        else if(avg[3]) led <= 8'b1111_0000;// if 3rd bit pos 1, ledr6 to ledr9 ON
        else if(avg[2]) led <= 8'b1110_0000;// if 2nd bit pos 1, ledr7 to ledr9 ON
        else if(avg[1]) led <= 8'b1100_0000;// if 1st bit pos 1, ledr8 to ledr9 ON
        else if(avg[0]) led <= 8'b1000_0000;// if none, only ledr9
        //if(audio_in==8'b0 || avg==8'b0) led <=8'b0;// no sound no ledr
        else led <=8'b0000_0000;/// no sound no ledr
        state <= idle;
    end
    default: state <= idle;
    endcase
end

endmodule


