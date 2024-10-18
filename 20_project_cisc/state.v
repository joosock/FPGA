module state(
	input reset,
	input clk,
	input [2:0] state_in,
	output reg [2:0] state_out
	);

always@(posedge reset or posedge clk) begin
	if(reset)
		state_out <= 3'b111;
	else
		state_out <= state_in;	 
end

endmodule
