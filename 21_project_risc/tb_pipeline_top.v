module tb_pipeline_top;

	// Inputs
	reg reset;
	reg clk;

	// Outputs
	wire read;
	wire write;
	wire inst_ld;

	// Instantiate the Unit Under Test (UUT)
	pipeline_top uut (
		.reset(reset), 
		.clk(clk), 
		.read(read), 
		.write(write), 
		.inst_ld(inst_ld)
	);

	initial begin
		// Initialize Inputs
		reset = 0;
		clk = 0;
  end
  always
  #1 clk = ~clk;
  
 initial begin
		#0 reset = 1;
		#20 reset = 0;
 end
      
endmodule