module flag(
	input reset,
	input ld,
	input clk,
	input [7:0] alu_out,
	output reg flag
	);

always@(posedge reset or posedge clk) begin
	if(reset)
		flag = 0;
	else
		case(alu_out)
		8'b0000_0000 : if(ld == 1)
								flag = 1;
		default       : if(ld == 1)
								flag = 0;     
		endcase   
end

endmodule