module addr_mux(
	input [4:0] a,
	input [4:0] b,
	input sel,
	output [4:0] mux_out
	);

assign mux_out = sel ? a  : b;

endmodule
