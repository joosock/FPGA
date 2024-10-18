module bi_buf(
	input en,
	input [7:0] buf_in,
	input [7:0] d_in,
	output reg [7:0] d_out,
	output reg [7:0] buf_out
	);

always@(en,d_in,buf_in) begin
	buf_out  = 8'b0;
	d_out    = 8'b0;
	case(en)
		1'b0 : buf_out = d_in  ;
		1'b1 : d_out   = buf_in;
	endcase
end

endmodule
