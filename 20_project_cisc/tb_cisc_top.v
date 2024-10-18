module tb_cisc_top();

	// Inputs
	reg reset;
	reg clk;

	// Outputs
	wire [7:0] mc_out;
	wire [7:0] mem_out;
	wire m_clk;
	wire read;
	wire write;
	wire [4:0] mem_addr;

	// Instantiate the Unit Under Test (UUT)
	cisc_top uut (
		.reset(reset), 
		.clk(clk), 
		.mc_out(mc_out), 
		.mem_out(mem_out), 
		.m_clk(m_clk), 
		.read(read), 
		.write(write), 
		.mem_addr(mem_addr)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		clk = 0;
		
	end
	always #10 clk = ~clk;
  
	initial begin
		#0 reset = 1;
		#100 reset = 0;
 end
      
endmodule

