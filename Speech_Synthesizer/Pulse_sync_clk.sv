

module pulse_edge(
	input logic outclk, 
	input logic async_sig, 
	output logic out_sync_sig);
logic w1, w2, w3, w4;
edge_detect_FF_async FF_A (.clk(async_sig), .clr(!async_sig &w3), .d(1'b1), .q(w1)); 
edge_detect_FF_async FF_B (.clk(outclk), .clr(1'b0), .d(w1), .q(w2));
edge_detect_FF_async FF_C (.clk(outclk), .clr(1'b0), .d(w2), .q(w3));
edge_detect_FF_async FF_D (.clk(outclk), .clr(1'b0), .d(w3), .q(w4)); 
assign out_sync_sig = !w3 & w4;
	
endmodule

module edge_detect_FF_async (
input logic clk, 
input logic d, 
input logic clr, 
output logic q); 
	always_ff @(posedge clk, posedge clr)
		if (clr)	
			q <= 1'b0;
		else 
			q <= d;
endmodule

