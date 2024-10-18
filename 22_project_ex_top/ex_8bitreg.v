module ex_8bitreg(clk,clear,d,q);

input clk    ;
input clear  ;
input [7:0] d;

output reg [7:0] q;

always@(posedge clear or posedge clk) begin
	if(clear)
	 q <= 8'b0;
	else
	 q <= d;
end

endmodule
