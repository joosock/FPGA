module ex_4bitreg(clk,clear,d,q);

input clk    ;
input clear  ;
input [3:0] d;

output reg [3:0] q;

always@(posedge clear or posedge clk) begin
	if(clear)
	 q <= 4'b0;
	else
	 q <= d;
end

endmodule
