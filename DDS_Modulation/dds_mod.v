module dds_mod(clk_f, clk_s, lfsr0, sin, cos, squ, saw, 
                modulation_selector, signal_selector, mod_out, sig_out,
                fsk, slow_flag);

input clk_f, clk_s;
input lfsr0;// used as tuning word or bit for DDS
input [11:0] sin, cos, squ, saw;
input [1:0] modulation_selector, signal_selector;
output reg fsk=1'b0;
output reg slow_flag=1'b0;
output reg [11:0] mod_out, sig_out;
//output reg fsk=1'b0;

wire lfsr_out;// get the value from the fast clk
wire [11:0] out_ask, out_bpsk;

//module slow_fast_clk(clk_s, clk_f, in, out);
slow_fast_clk SF1(.clk_s(clk_s), .clk_f(clk_f), .in(lfsr0), .out(lfsr_out));

//module ask(clk, en_signal, in, out);
ask ASK1(.clk(clk_f), .en_signal(lfsr_out), .in(sin), .out(out_ask));// ASK output signal received

//module bpsk(clk, lfsr0, in, out);
bpsk BPSK1(.clk(clk_f), .lfsr0(lfsr_out), .in(sin), .out(out_bpsk));// BPSK output signal received


// combinational logic for signal output
always@(*)begin
    case(signal_selector)
    2'b00: sig_out = sin;// 0 sin
    2'b01: sig_out = cos;//1 cos
    2'b10: sig_out = saw;//2 saw
    2'b11: sig_out = squ;//3 squ
    default: sig_out =12'bx;
    endcase
end
// state machine part for setting the outputs
// sequential logic for modulation as it's done with clk
always@(posedge clk_f)begin
    case(modulation_selector)
    2'b00: begin 
        mod_out <= out_ask;// choose ASK
        fsk <=0;// fsk 0
        slow_flag<=1'b0;
    end
    2'b01:begin
        if(lfsr_out) begin // if 1; sin and fsk
            mod_out <= sin;// choose sin
            fsk<=1;// 1 here for the dds_increment in top module
            slow_flag<=1'b0;
        end
        else begin
            mod_out <= sin;
            slow_flag<=1'b1;
            fsk<=1;//1 here for the dds_increment in top modul
        end 
    end 
    2'b10: begin 
            mod_out <= out_bpsk;// choose bpsk
            fsk <=0;// fsk 0
            slow_flag<=1'b0;
    end
    2'b11:begin
            mod_out <= {lfsr0,11'b0}; 
            fsk <=0;// fsk 0
            slow_flag<=1'b0;
    end
    default: mod_out =12'bx;
    endcase

end

endmodule
