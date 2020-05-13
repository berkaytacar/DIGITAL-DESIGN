module ctrl_fsm(clk, done_read, sync, play, start_addr,
				finish_addr, data_in_read, start_flag, flash_data_audio,
				addr, start_from_pico, finish_to_pico);
input clk, done_read;
input sync;// pulse 
input play; 
input  [23:0] start_addr;
input [23:0] finish_addr;
input [31:0] data_in_read;
output start_flag;//start
output reg [7:0] flash_data_audio;// audio_data to send to audio
output /*reg*/ [23:0] addr;// addr is to mem word addr// current address
//wire [23:0] addr;
reg [23:0] addr;
//assign addr = addr1/4;
input start_from_pico;
output reg finish_to_pico; 
// additions
//input [22:0] start_addr;
//input [22:0] finish_addr;

reg [4:0] state;
wire [1:0] mod4;
reg [23:0] addr1;//= start_addr;// initialize it with start address of phoneme
reg [23:0] addr2; // addr1 is byte addr
wire start_flag;
//initial begin
//	addr1= start_addr;
//end
assign start_flag= state[4];// 1 at read

parameter [4:0] idle = 5'b0_00_00;
parameter [4:0] read_state = 5'b1_00_01; 
parameter [4:0] delay = 5'b0_00_10; 
parameter [4:0] delay_p = 5'b0_00_11;
parameter [4:0] sample0 = 5'b0_01_00; 
parameter [4:0] sample1 = 5'b0_01_01;
parameter [4:0] sample2 = 5'b0_01_10;
parameter [4:0] sample3 = 5'b0_01_11;
parameter [4:0] state_address = 5'b0_10_00;
//parameter [4:0] choose_sample = 5'b0_10_01;
parameter [4:0] delay_audio0 = 5'b0_10_01;
parameter [4:0] delay_audio1 = 5'b0_10_10;
parameter [4:0] delay_audio2 = 5'b0_10_11;
parameter [4:0] delay_audio3 = 5'b0_11_00;
parameter [4:0] new_start_address = 5'b0_11_01;

reg r1=0;
assign mod4 = addr2% 24'd4;// mod 4 but 23 bits for now
//assign mod4 = addr2% 24'd4;
//wire [23:0] addr;
//assign addr = addr1/24'd4;

always @(posedge clk) begin
if(start_from_pico) begin
	if(r1==0) begin
		//addr1 <= start_addr; // r1 flag for giving it start address
		//addr<= start_addr;
		addr2 <= start_addr;
		addr <= start_addr/4;
		r1<=1'b1;// r1 is 1 so doesn't come back again
		finish_to_pico <=0;
	end
	else begin
	case(state)// flag=1
	idle: begin
		if (play) // if play "E" from keyboard
			state <= read_state;// go to read
     	else 
		 	state <= idle;
	end
	read_state: state <= delay;// delay for reading to be completed

	delay: begin
		if (done_read) // if done with reading, go to delay
			state <= delay_p;
        else 
			state <= delay;
	end
	delay_p: begin// delay
		if (sync) 
			//state <= choose_sample;// choose the data to send to audio
			state <= sample0;
        else 
			state <= delay_p;
	end
	/*
	choose_sample: begin
		if(sync)begin
			if(mod4==2'd0) state <= sample0;
			else if(mod4==2'd1) state <= sample1;
			else if(mod4==2'd2) state <= sample2;
			else state<= sample3;
		end
		else
			state<=choose_sample;
	end
	*/
	sample0: begin 
		//state <= state_address;// try without sync for now
		// now try with sync
		if(sync) begin
		//state <= sample1;
		state <= delay_audio0;
		//if()
		flash_data_audio <= data_in_read[7:0];// get sample0 from 0 to 7
		end
		else 
			state <= sample0;
	end
	delay_audio0: state <= sample1;
	sample1: begin
		if(sync) begin
		//state <= state_address;
		//state <= sample2;
		state <= delay_audio1;
		flash_data_audio <= data_in_read[15:8];//from 8 to 15
		end
		else state <=sample1;
	end
	delay_audio1: state<= sample2;
	sample2: begin 
		//state <= state_address;
		//state <= sample3;
		if(sync)begin
		state <= delay_audio2;
		flash_data_audio = data_in_read[23:16];//from 16 to 23
		end
		else state <= sample2;
	end
	delay_audio2: state<= sample3;
	sample3: begin 
		//state <= state_address;
		if(sync)begin
		state <= delay_audio3;
		flash_data_audio <= data_in_read[31:24];// from 24 to 31
		// arttir sonra sample0 a don
		end
		else state <= sample3;
	end
	delay_audio3: state <= state_address;
	state_address: begin
	/*
		addr1 <= addr1+1;
		if(addr==finish_addr/24'd4)
			addr <= start_addr/24'd4;
		else
			addr <= (addr/24'd4)+24'd1;*/
	
		if(addr< finish_addr/4/*addr1< finish_addr*/) begin
			//addr1 <=addr1+24'd1;// 24'b1
			//addr1 <=addr1+24'd1;
			addr <= addr+1;
			finish_to_pico <=0;
			state <= idle;
		end
		else //if(addr1== 24'h7FFFF)// not sure if necessary
			//addr1 <= start_addr;// if you finish, repeat it again
			begin
			finish_to_pico<=1;
			state <= new_start_address;
		//state <= idle;
		//r1=1'b1;
			end
	end// for state_address
	new_start_address: begin
		//addr1 <= start_addr;
		state <= idle;
		addr <= start_addr/4;
	end

	default:state <= idle;
	endcase
	//addr <= addr1/24'd4;// addr is the output from FSM to the flash, so divide by 4
	end
end// for start_from_pico
end// for always
endmodule