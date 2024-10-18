module ir(
	input reset,
	input clk,
	input ld,
	input [7:0] ir_in,
	output reg [7:0] ir_out
	);


always@(posedge reset or posedge clk)
 if(reset)
	ir_out <= 8'b0;
 else
	if(ld)
		ir_out <= ir_in;
	else
		ir_out <= ir_out;

endmodule