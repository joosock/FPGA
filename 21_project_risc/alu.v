module alu(
	input [7:0] a,
	input [7:0] b,
	input [2:0] op,
	output reg [7:0] alu_out
	);

always@(a,b,op) begin
  case(op)
   3'b000 : alu_out = a   ;	
   3'b010 : alu_out = a+b ;
   3'b011 : alu_out = a&b ;
   3'b100 : alu_out = a^b ;
   3'b101 : alu_out = b   ;
   3'b110 : alu_out = a   ;
   default: alu_out = 8'b0;
  endcase
 end

endmodule