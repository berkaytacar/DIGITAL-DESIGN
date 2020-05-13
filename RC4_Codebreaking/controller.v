module controller(clk, reset, key_generated, continue_increment, 
found_key, secret_key, generating_key, checking_key, LEDR0, LEDR1);
	input clk;
	input reset;
	input logic key_generated;
	input logic continue_increment;
	input logic found_key;
	input logic [23:0] secret_key;
	output logic generating_key;
	output logic checking_key;
	output logic LEDR0 = 1'b0;//this led lights up if key found
	output logic LEDR1 = 1'b0;//this led lights up if no key
	logic [5:0] state; 
	
	//states
	parameter [3:0] start = 4'b0001;
	parameter [3:0] check = 4'b0010;
	parameter [3:0] finish = 4'b0100; 
	parameter [3:0] no_key = 4'b1000;
	
	assign generating_key = state[0];
	assign checking_key = state [1];
	assign LEDR0 = state[2];
	assign LEDR1 = state[3];
	
	always_ff @(posedge clk /*or negedge reset*/)
		if(reset)
			state <= start;
		else
			case(state)
				start:
					if(key_generated)
						state <= check;
				check:
					if(found_key)
						state <= finish;
					else if(secret_key >= 24'b001111111111111111111111)
						state <= no_key;
					else if(continue_increment)
						state <= start;
				finish:
					state <= finish;//loop here
				no_key:
					state <= no_key;//loop here
				default:
					state <= start;	
			endcase
endmodule
