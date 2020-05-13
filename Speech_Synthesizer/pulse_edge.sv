

module pulse_edge(
	input logic outclk, 
	input logic async_sig, 
	output logic out_sync_sig);
logic Q_A, Q_B, Q_C, Q_D;

	
	edge_detect_FF_async FF_A (.clk(async_sig), .clr(!async_sig & Q_C), .d(1'b1), .q(Q_A)); 
	edge_detect_FF_async FF_B (.clk(outclk), .clr(1'b0), .d(Q_A), .q(Q_B));
	edge_detect_FF_async FF_C (.clk(outclk), .clr(1'b0), .d(Q_B), .q(Q_C));
	edge_detect_FF_async FF_D (.clk(outclk), .clr(1'b0), .d(Q_C), .q(Q_D)); 
	
	assign out_sync_sig = !Q_D & Q_C;
	
endmodule

module edge_detect_FF_async (
input logic clk, 
input logic d, 
input logic clr, 
output logic q); 
	always_ff @(posedge clk, posedge clr)
		if (clr)	q <= 1'b0;
		else 		q <= d;
endmodule

