module fsm_task2(clk, reset, secret_key, output_from_mem, 
	address_to_mem, data_to_mem, wren, q_m, address_m, address_d,
	data_d, wren_d, data_from_decryption, /*continue_increment*/, found_key, not_found_key);

	input clk;
	input reset;
	//input [23:0] secret_key;
	input [7:0] output_from_mem;
	input [7:0] data_from_decryption;// try not connected
	
	input [7:0] q_m;//output from encrypted memory
	output reg [4:0] address_m;//input address to encrypted memory
	output reg [4:0] address_d;//input address to decrypted memory
	output reg [7:0] data_d;//input data to decrypted memory
	output reg [23:0] secret_key;//maybe need inside always
	output reg wren_d;
	
	output reg [7:0] address_to_mem;
	output reg [7:0] data_to_mem;
	output reg wren;
	//output reg continue_increment;//flag to tell other fsm to increment secret_key
	output reg found_key;
	output reg not_found_key;
	
	//states for part1
	parameter [5:0] start_part1 = 6'b101100;
	parameter [5:0] check_i_part1 = 6'b000001;		
	parameter [5:0] increment_i_part1 = 6'b000010;
	parameter [5:0] save_address_i_part1 = 6'b000011;
	parameter [5:0] delay_part1 = 6'b000100;// 5 and starter

	parameter [5:0] delay_j_memory = 6'b000101;//
	
	//states for part2a
	parameter [5:0] start = 6'b000110;//
	parameter [5:0] save_address_i = 6'b000111;//
	parameter [5:0] check_i = 6'b001000;//
	parameter [5:0] increment_i = 6'b001001;//
	parameter [5:0] delay = 6'b001010;//
	parameter [5:0] finish = 6'b001011;//
	parameter [5:0] delay2 = 6'b001100;//
	parameter [5:0] get_val_i = 6'b001101;//
	parameter [5:0] find_j = 6'b001110;//
	parameter [5:0] delay_j = 6'b001111;//
	parameter [5:0] get_val_j = 6'b010000;//
	parameter [5:0] output_i = 6'b010001;//
	parameter [5:0] delay_output_i = 6'b010010;//
	parameter [5:0] output_j = 6'b010011;//
	parameter [5:0] delay_output_j = 6'b010100;//
	
	//states for part2b
	parameter [5:0] start_part2b = 6'b010101;//
	parameter [5:0] increment_i_part2b = 6'b010110;//
	parameter [5:0] save_address_i_part2b = 6'b010111;//
	parameter [5:0] delay_i = 6'b011000;//
	parameter [5:0] get_j = 6'b011001;//
	parameter [5:0] save_address_j = 6'b011010;//
	parameter [5:0] delay_j_part2b = 6'b011011;//
	parameter [5:0] swap_1 = 6'b011100;//
	parameter [5:0] swap_2 = 6'b011101;//
	parameter [5:0] swap_3 = 6'b011110;//
	parameter [5:0] swap_4 = 6'b011111;//
	parameter [5:0] si_sj = 6'b100000;//
	parameter [5:0] delay_si_sj = 6'b100001;//
	parameter [5:0] get_f = 6'b100010;//
	parameter [5:0] dk = 6'b100011;//
	parameter [5:0] delay_k = 6'b100100;//
	parameter [5:0] x_or = 6'b100101;//
	parameter [5:0] write_to_d = 6'b100110;//
	parameter [5:0] increment_k = 6'b100111;
	parameter [5:0] check_k = 6'b101000;//
	parameter [5:0] check_bounds = 6'b101001;//
	parameter [5:0] increment_secretkey = 6'b101010;//
	parameter [5:0] delay_part3 = 6'b101011;//

	parameter [5:0] starter = 6'b000000;//45
	
	reg [5:0] state;
	reg [7:0] i = 0;
	reg [7:0] j = 0;
	reg [4:0] k = 0;
	reg [7:0] val_i;
    reg [7:0] val_j;
	reg [7:0] val_i_part2b;
	reg [7:0] val_j_part2b;
	//reg [7:0] sum;
	reg [7:0] f;
	reg [7:0] secret_segment;
	reg [7:0] i_mod_3;
	//reg [21:0] secret_key_counter = 22'b0;//not sure if we can assign to reg
	

	//states
	always_ff @(posedge clk)
	begin
	if(reset)
		state <= start;
	else
	begin
		case(state)
			//part1
			starter: state <= start_part1;

			start_part1: state <= check_i_part1;
			check_i_part1: begin
						if(i < 255)
							state <= increment_i_part1;
						else
							state <= delay_part1;
						end
			increment_i_part1: state <= save_address_i_part1;
			save_address_i_part1: state <= check_i_part1; 
			delay_part1: state <= start;
			
			//part2a
			start: state <= save_address_i;
			save_address_i: state <= delay2;
         delay2: state <= get_val_i; 
			get_val_i: state <= find_j;
         find_j: state <= delay_j;
         delay_j: state <= delay_j_memory;
			delay_j_memory: state <= get_val_j;//delay for s_memory
         get_val_j: state <= output_i;
			output_i: state <= delay_output_i;
			delay_output_i: state <= output_j;
			output_j: state <= delay_output_j;
			delay_output_j: state <= check_i;
			check_i: begin
						if(i < 255)
							state <= increment_i;
						else
							state <= start_part2b;//state <= delay;
						end
         increment_i: state <= save_address_i; 
	
			//part2b
			/*// compute one byte per character in the encrypted message. You will build this in Task 2
					i = 0, j=0
					for k = 0 to message_length-1 { // message_length is 32 in our implementation
					i = i+1
					j = j+s[i]
					swap values of s[i] and s[j]
					
					f = s[ (s[i]+s[j]) ]
					decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function*/ 
			start_part2b: state <= increment_i_part2b;
			increment_i_part2b: state <= save_address_i_part2b;
			save_address_i_part2b: state <= delay_i;
			delay_i: state <= get_j;
			get_j: state <= save_address_j;
			save_address_j: state <= delay_j_part2b;
			delay_j_part2b: state <= swap_1;
			swap_1: state <= swap_2;
			swap_2: state <= swap_3;
			swap_3: state <= swap_4;//30
			swap_4: state <= si_sj;
			si_sj: state <= delay_si_sj;
			//si_sj_address: state <= delay_si_sj;
			delay_si_sj: state <= get_f;
			get_f: state <= dk;
			dk: state <= delay_k;
			delay_k: state <= x_or;
			x_or: state <= write_to_d;
			//write_to_d: state <= check_bounds;

			///////////////////////////// NOT SURE ///////////////////
			write_to_d: state <= delay_part3;// try extra delay
			//part3

			delay_part3: state <= check_bounds;

			check_bounds:	begin if(data_d == 8'd32 || (data_d >= 8'd97 && data_d <= 8'd122)) begin
									state <= check_k; end
							  else
								state <= increment_secretkey;
							end
								
			increment_secretkey: begin
									if(secret_key >= 24'b001111111111111111111111)
										state <= delay;//output smth is 0
									else 
										state <= start_part1;//secret_key <= secret_key +1;
								 end 
			check_k: begin
							if(k < 5'd31)
								//state <= increment_k; trying this one
								state  <= increment_i_part2b;// to i = i +1; part 2b
							else
								state <= finish;
						end
			//increment_k: state <= increment_i_part2b;
			
					
         	delay: state <= delay;
			finish: state <= finish;
			default: state <= starter;
		endcase
		end
	end
	
	//outputs
	always_ff @(posedge clk) 
	begin
	if(reset)
		i <= 0;
	else
	begin
		case(state)
			//part1
			starter: secret_key <= 24'b0;
			start_part1: begin
								i <= 0;
								wren <= 0;
								//continue_increment <= 0;
								found_key <= 0;
								//secret_key <= 24'b0;
								not_found_key <= 0;
							 end
			save_address_i_part1: begin
									address_to_mem <= i;
									data_to_mem <= i;
								 end
			check_i_part1: wren <= 1;
			increment_i_part1: i <= i + 1;
			delay_part1: wren <= 0;
			
			//part2a 
			start: begin
						i <= 0;
						j <= 0;
						wren <= 0;
					 end
			save_address_i: begin
									address_to_mem <= i;// set it to address
									i_mod_3 <= i % 8'd3;
								 end
         //delay2: to read q output
         get_val_i: begin
                       val_i <= output_from_mem;// val gets s[i]
							  if(i_mod_3 == 0)
										secret_segment <= secret_key[23:16];
							  else if(i_mod_3 == 8'd1)
										secret_segment <= secret_key[15:8];
							  else
										secret_segment <= secret_key[7:0];
                    end
         find_j: j <= j+ val_i + secret_segment;
			delay_j: address_to_mem <= j;//output save_j to give address to mem
			//delay_j_memory
			get_val_j: val_j <= output_from_mem;
			output_i:begin
							address_to_mem <= i;
							data_to_mem <= val_j;
						end
			delay_output_i: wren <= 1;
			output_j: begin
							address_to_mem <= j;
							data_to_mem <= val_i;
							wren <= 0;
						 end
			delay_output_j: wren <= 1;
			//check_i:
			increment_i: begin 
								i <= i + 1;
								wren <= 0;//added this
							 end
					
		

			/*
			// compute one byte per character in the encrypted message. You will build this in Task 2
			i = 0, j=0
			for k = 0 to message_length-1 { // message_length is 32 in our implementation
			i = i+1
			j = j+s[i]
			swap values of s[i] and s[j]
			f = s[ (s[i]+s[j]) ]
			decrypted_output[k] = f xor encrypted_input[k] // 8 bit wide XOR function 
			*/
			//part2b				 
			start_part2b: begin
								i <= 0;
								j <= 0;
								k <= 0;
								wren <= 0;
								wren_d <= 0;
							  end
			increment_i_part2b: i <= i + 1;
			save_address_i_part2b: address_to_mem <= i;
			//delay_i:
			get_j: begin
						j <= j + output_from_mem;
						val_i_part2b <= output_from_mem;
					 end
			save_address_j: address_to_mem <= j;
			//delay_j_part2b:
			swap_1: begin
						data_to_mem <= output_from_mem;
						val_j_part2b <= output_from_mem;
						address_to_mem <= i;
					  end
			swap_2: wren <= 1;
			swap_3: begin
						data_to_mem <= val_i_part2b;
						address_to_mem <= j;
						wren <= 0;
					  end
			swap_4: wren <= 1;
			si_sj: begin
						address_to_mem <= val_i_part2b + val_j_part2b;
						wren <= 0;
					 end
			//si_sj_address: address_to_mem <= sum; //dont need?
			//delay_si_sj: //delay state
			get_f: f <= output_from_mem;
			dk: begin
					address_d <= k;
					address_m <= k;
				 end
			//delay_k: //delay state
			x_or: data_d <= f ^ q_m;
			write_to_d: wren_d <= 1;

			//part3 08 7B 2D secret key
			delay_part3: wren_d <= 0;
			//check_bounds: 
			
			increment_secretkey: begin
									if(secret_key >= 24'b001111111111111111111111) begin
										found_key <= 0;//output smth is 0
										not_found_key <= 1;
									end
									else 
										secret_key <= secret_key +1;//secret_key <= secret_key +1;
								 end 
			check_k: begin
							if(k < 5'd31)
								//state <= increment_k; trying this one
								k <= k+1;
							else begin
								found_key <=1;
								not_found_key <=0;
								end
						end
			
			//increment_secretkey: continue_increment <= 1;
	
			//check_k: //no outputs
			//increment_k: begin
			//					wren_d <= 0;
			//					k <= k + 1;
			//				 end
			
			
			
					
			delay: not_found_key <=1;
			finish: found_key <= 1;
			default: begin
							wren <= 1'bx;
							wren_d <= 1'bx;
							address_d <= 5'bx;
							address_m <= 5'bx;
							data_d <= 8'bx;
							address_to_mem <= 8'hFF;
							data_to_mem <= 8'hFF;
							//secret_key <= 24'bx;
						end
		endcase
		//secret_key = {2'b0, secret_key_counter};
		end
	end
endmodule
