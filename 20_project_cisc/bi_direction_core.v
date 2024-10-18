module bi_direction_core(
	input mc_en,
	input read,
	input [7:0] mc_in,
	input [7:0] mem_data2,
	output reg [7:0] mem_data1,
	output reg [7:0] mc_out
	);

always@(*) begin
	mc_out    = 8'b0;
 	mem_data1 = 8'b0;
 if(mc_en)
	mem_data1 = mc_in;
 else
	mc_out = mem_data2;
end

endmodule
