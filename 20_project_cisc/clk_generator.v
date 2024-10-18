module clk_generator(
	input clk,
	output reg M_clk,
	output reg P_clk
	);

always@(*) begin
 P_clk = clk;
 M_clk = ~clk;
end

endmodule
