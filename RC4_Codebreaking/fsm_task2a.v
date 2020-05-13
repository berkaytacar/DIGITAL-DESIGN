module fsm_task2(clk, reset, /*part1_done*/, secret_key, output_from_mem, 
	address_to_mem, data_to_mem, wren);

	input clk;
	input reset;
	//input part1_done;//flag to check if s_memory initialized
	//input [23:0] secret_key;
	input [7:0] output_from_mem;
   //input [7:0] output_mem_i;//output from s[i]
   //input [7:0] output_mem_j;//output from s[j]

	//output reg [7:0] s_i_data;
	//output reg [7:0] save_i; //removed this
	output reg [7:0] address_to_mem;//added this
	output reg [7:0] data_to_mem;//added this
	output reg wren;
	//wire [23:0] secret_key=24'b00000001_00000010_01001001;
	input logic [7:0] secret_key [2:0]; //input

	//states - add output bits later to states
	parameter [4:0] start = 5'b01111; 
	parameter [4:0] save_address_i = 5'b00001;
	parameter [4:0] check_i = 5'b00010;
	parameter [4:0] increment_i = 5'b00011;
	parameter [4:0] delay = 5'b00100;
	parameter [4:0] finish = 5'b00101;
	//states for part2a
	parameter [4:0] delay2 = 5'b00110;
	parameter [4:0] get_val_i = 5'b00111;
	parameter [4:0] find_j = 5'b01000;
	parameter [4:0] delay_j = 5'b01001;
	parameter [4:0] get_val_j = 5'b01010;
	parameter [4:0] output_i = 5'b01011;
	parameter [4:0] delay_output_i = 5'b01100;
	parameter [4:0] output_j = 5'b01101;
	parameter [4:0] delay_output_j = 5'b01110;
	//states for part1
	parameter [4:0] start_part1 = 5'b00000;
	parameter [4:0] check_i_part1 = 5'b10000;		
	parameter [4:0] increment_i_part1 = 5'b10001;
	parameter [4:0] save_address_i_part1 = 5'b10010;
	parameter [4:0] delay_part1 = 5'b10011;
	parameter [4:0] delay_j_memory = 5'b10100;
	parameter [4:0] delay_i = 5'b10101;
	parameter [4:0] save_address_j = 5'b10110;
	
	reg [4:0] state;
	reg [7:0] i = 0;
	reg [7:0] j = 0;
	//reg [7:0] save_i;//added this
	//reg [7:0] save_j;
	reg [7:0] val_i;
   reg [7:0] val_j;
	reg [7:0] secret_segment;
	reg [7:0] place_holder;//i_mod_3;

	reg part1_flag;
	
	//assign secret_segment[0] = secret_key[23:16];
	//assign secret_segment[1] = secret_key[15:8];
	//assign secret_segment[2] = secret_key[7:0];
	
	//states
	always @(posedge clk)
	begin
	if(reset)
		state <= start;
	else
	begin
		case(state)
			//part1
			start_part1: state <= check_i_part1;
			check_i_part1: begin
						if(i < 255)
							state <= increment_i_part1;
						else
							state <= start; //finish;
							//finish;
						end
			increment_i_part1: state <= save_address_i_part1;
			save_address_i_part1: state <= check_i_part1; 
			delay_part1: state <= start;//should be this
			//delay_part1: state <= delay;//to test
			//part2a
			
			start: state <= save_address_i;//check_i;
			/*
			check_i: begin
						if(i < 256)
							state <= save_address_i;
						else
							state <= delay;
						end*/
			save_address_i: state <= delay2;
			
            //delay2: state <= get_val_i; 
			delay2: state <= find_j;
			//get_val_i: state <= find_j;
		// from here	
        // find_j: state <= delay_j;
		   find_j: state <=output_j;
		   output_j: state <= delay_j;
		   delay_j: state <= delay_j_memory;// used as output
		   delay_j_memory: state <= get_val_j;// write en is 1
		   get_val_j: state <= save_address_j;
		   save_address_j: state <= delay_output_i;
		   delay_output_i: state <= check_i;
		  // check_i: state <= increment_i;
		   check_i: begin
						if(i < 255)
							state <= increment_i;
						else
							state <= finish;
						end

        // delay_j: state <= delay_j_memory;
		//	delay_j_memory: state <= get_val_j;//delay for s_memory
        /* get_val_j: state <= output_i;
			output_i: state <= delay_output_i;
			delay_output_i: state <= output_j;
			
			output_j: state <= delay_output_j;
			delay_output_j: state <= increment_i;*/
		//	
         increment_i: state <= save_address_i;
		// delay_i: state <= check_i;   
	
		 //*/
         //delay: state <= finish;
		 finish: state <= finish;
			default: state <= start_part1;//start_part1;
		endcase
		end
	end
	
	//outputs
	always @(posedge clk) 
	begin
	if(reset)
		i <= 0;
	else
    // j = j+ s[i]+  secret_key[i% 3]
	begin
		case(state)
			//part1
			start_part1: begin
								i <= 0;
								address_to_mem <= 0;
								wren <= 0;
								part1_flag <=0;
							 end
			save_address_i_part1: begin
									address_to_mem <= i;
									//data_to_mem <= i;
									//wren <= 1;
								 end
			check_i_part1: wren <= 1;
			increment_i_part1: begin 
									i <= i + 1;
									//wren <=0;
								end
			delay_part1: wren <= 0;
			
			//part2a
			
			start: begin
						i <= 0;
						j <= 0;
						//save_i <= 0;
						//save_j <= 0;
						wren <= 0;
						part1_flag <=1;
					 end
			save_address_i: begin
									address_to_mem <= i;// set it to address
									//wren <= 0;
									//i_mod_3 <= i % 3;
							 end
			
            //delay2: to read q output
			/*
            get_val_i: begin
                          val_i <= output_from_mem;// val gets s[i]
								  if(i_mod_3 == 0)
										secret_segment <= secret_key[23:16];
								  else if(i_mod_3 == 1)
										secret_segment <= secret_key[15:8];
								  else
										secret_segment <= secret_key[7:0];
                        end*/
						// from here 
            find_j: begin
                        //address_to_mem <= j+ val_i + secret_segment;
                        //j <= j+ output_from_mem + secret_segment;
						j <= j+ output_from_mem + secret_key[(i%3)];
						val_i <= output_from_mem;// mod 3 keylength
                    end
			output_j: begin
							address_to_mem <= j;
							//data_to_mem <= val_i;
							//wren <= 1;
					  end
					
			//delay_j: //address_to_mem <= j;//output save_j to give address to mem
			delay_j_memory: begin
								data_to_mem <= output_from_mem;// to put j to i
								address_to_mem <= i;// to write to i
								wren <= 1;// test
								//wren <= 0;
							end 
            get_val_j: begin
								//val_j <= output_from_mem;
								//wren <= 1;//remove this after
								end
			save_address_j: begin
								data_to_mem <= val_i;
								address_to_mem <=j;
								//wren <= 0;
								wren <=1;
							end
			delay_output_i: //wren <=1;
				/*output_i:begin
								address_to_mem <= i;
								data_to_mem <= val_j;
								wren <= 1;
							end*/
				//delay_output_i: wren <= 0;//wren <= 1
				
				/*output_j: begin
								address_to_mem <= j;
								data_to_mem <= val_i;
								wren <= 1;
							 end*/
				//delay_output_j: wren <= 0;
					//*/
			check_i: wren <= 0;// comment this later
			increment_i: i <= i + 1;
			// delay_i
			//delay: wren <= 0;
			//finish:
			default: begin
							wren <= 1'bx;
							address_to_mem <= 8'bx;
							data_to_mem <= 8'bx;
							//s_i_data <= 8'bx;
						end
		endcase
		if(part1_flag==0) begin
			data_to_mem <= address_to_mem;
		end
		//else
			//data_to_mem <= data_to_mem;
		end
		
	end
endmodule