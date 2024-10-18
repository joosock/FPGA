module mdr(
	input reset,
	input ld,
	input clk,
	input [7:0] mdr_in,
	output reg [7:0] mdr_out
	);

always@(posedge reset or posedge clk) begin
 if(reset)
	mdr_out <= 8'b0;
 else
	if(ld)
		mdr_out <= mdr_in;
end

endmodule