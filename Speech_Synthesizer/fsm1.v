// to read
module fsm1(clk, r_d_valid, wait_req, read, in, out, done, en, out_read);

input clk, r_d_valid, wait_req, read;// start
input [31:0] in;
output reg [31:0] out;
output done;
output wire [3:0] en;//byteenable
output out_read;

// reg wire dec
reg [4:0] state;
wire done;
wire out_read;

// states
parameter [4:0] idle = 5'b0_00_00;
parameter [4:0] read_state = 5'b0_00_01; 
parameter [4:0] delay = 5'b0_00_10; 
parameter [4:0] get_val = 5'b1_00_00; 

assign done= state[4];// 4th bit only at get val
assign out_read = state[0];

assign en=4'b1111;


// edge detection for read
always@(posedge r_d_valid)begin
	out <= in;// when posedge of r_d_valid get the input in	
end

// states
always@(posedge clk)begin
	case(state)
	idle: begin
		if(read)
			state <=read_state;// go to read
		else 
			state <= idle;// stay here
	end

	read_state: state<= delay;// delay
	delay: begin
		if(wait_req)
			state<= delay;// stay at delay
		else
			state<= get_val;// else go get value
	end
	get_val: state <= idle;// loop
	default: state <= idle;
	endcase
end
endmodule 









