module key_generator(clk, reset, generating_key, secret_key, key_generated);
	input clk;
	input reset;
	input generating_key;
	output [23:0] secret_key;
	output key_generated;
	logic [2:0] state;

	parameter [1:0] start = 2'b00;
	//parameter [1:0] send = 2'b01;
	parameter [1:0] increment = 2'b10;
	parameter [1:0] finish = 2'b11;

	always_ff @(posedge clk /*or negedge reset*/)
		if(reset)
			state <= start;
		else
			case(state)
				start:
					if(generating_key)
						state <= increment; 
				/*send: state <= increment;*/
				increment: state <= finish;
				finish: state <= start;
				default: state <= start;
			endcase
	//outputs			
	always_ff @(posedge clk /*or negedge reset*/) 
		 if(reset)
			secret_key <= 24'b0;
		 else
			case(state)
				start: key_generated <= 0;
				increment: secret_key <= secret_key + 1;
				finish: key_generated <= 1;
				default: secret_key <= secret_key;
			endcase
endmodule
	