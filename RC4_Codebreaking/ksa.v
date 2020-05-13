//`default_nettype none
module ksa(CLOCK_50,LEDR,KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input CLOCK_50;
	input [3:0] KEY;
	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;

    logic CLK_50M;
    logic  [7:0] LED;
    logic [7:0] s_array;
    logic [7:0] i_data;//data from i_loop
    logic [7:0] i_address;//address from i_loop
    logic [7:0] s_output;
    logic [23:0] secret_key;
    logic wren_flag;
    logic part1_done = 0;
    logic [7:0] e_address;
    logic [7:0] d_address;
    logic [7:0] e_output;
    logic [7:0] d_output;
    logic [7:0] d_data;
    logic d_wren;
	 logic [6:0] hex0;
	 logic [6:0] hex1;
	 logic [6:0] hex2;
	 logic [6:0] hex3;
	 logic [6:0] hex4;
	 logic [6:0] hex5;
	 
	 logic key_generated;
	 logic increment_key_generator;
	 logic found_key;
	 logic not_found_key;
	 logic generating_key;
	 logic checking_key;

    //assign secret_key = {14'b0, SW};//assign secret_key = 24'b00000000_00000010_01001001;

    assign CLK_50M =  CLOCK_50;
    assign LEDR[7:0] = LED[7:0];

    //i_loop part1(.clk(CLK_50M), .address(i_data));

    s_memory s1(.address(i_address), .clock(CLK_50M), 
    .data(i_data),    .wren(wren_flag), .q(s_output));

    encrypted_memory e1 (.address(e_address), .clock(CLK_50M), .q(e_output));

    decrypted_memory d1(.address(d_address), .clock(CLK_50M), .data(d_data),    .wren(d_wren),    .q(d_output));

    /*fsm part1(.clk(CLK_50M), .reset(1'b0), .secret_key(secret_key), 
    .s_i_data(i_data), .save_i(i_address), .wren(wren_flag), 
    .part1_done(part1_done));*/
	//module fsm_task2(clk, reset, secret_key, output_from_mem, 
	//address_to_mem, data_to_mem, wren, q_m, address_m, address_d,
	//data_d, wren_d);


    fsm_task2 part2(.clk(CLK_50M), .reset(1'b0), 
    .secret_key(secret_key), .output_from_mem(s_output), 
    .address_to_mem(i_address), .data_to_mem(i_data), 
    .wren(wren_flag), .q_m(e_output), . address_m(e_address), .address_d(d_address),
	 .data_d(d_data), .wren_d(d_wren), .data_from_decryption(d_output), 
	 /*.continue_increment(increment_key_generator),*/ .found_key(found_key), .not_found_key(not_found_key));
	
	/*controller(.clk(CLK_50M), .reset(1'b0), .key_generated(key_generated), 
	.continue_increment(increment_key_generator), .found_key(found_key), 
	.secret_key(secret_key), .generating_key(generating_key), 
	.checking_key(checking_key), .LEDR0(LED[0]), .LEDR1(LED[1]));*/
	
	assign LED[0] = found_key;
	assign LED[1] = not_found_key;
	
	assign HEX0 = hex0;
	assign HEX1 = hex1;
	assign HEX2 = hex2;
	assign HEX3 = hex3;
	assign HEX4 = hex4;
	assign HEX5 = hex5;
	
	SevenSegmentDisplayDecoder hex_0(.ssOut(hex0), .nIn(secret_key[3:0]));
	SevenSegmentDisplayDecoder hex_1(.ssOut(hex1), .nIn(secret_key[7:4]));
	SevenSegmentDisplayDecoder hex_2(.ssOut(hex2), .nIn(secret_key[11:8]));
	SevenSegmentDisplayDecoder hex_3(.ssOut(hex3), .nIn(secret_key[15:12]));
	SevenSegmentDisplayDecoder hex_4(.ssOut(hex4), .nIn(secret_key[19:16]));
	SevenSegmentDisplayDecoder hex_5(.ssOut(hex5), .nIn(secret_key[23:20]));
endmodule