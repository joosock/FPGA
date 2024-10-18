module tb_ex_top;

	// Inputs
	reg clk;
	reg clear;
	reg [3:0] A;
	reg [3:0] B;
	reg [7:0] C;

	// Outputs
	wire [7:0] S;

	// Instantiate the Unit Under Test (UUT)
	ex_top uut (
		.clk(clk), 
		.clear(clear), 
		.A(A), 
		.B(B), 
		.C(C), 
		.S(S)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		clear = 1;
		A = 0;
		B = 0;
		C = 0;       
		
		#10 clear = 0;                                    
		#4 A = 4'b0011; B = 4'b0001; C = 8'b0000_0001; 
		#4 A = 4'b0110; B = 4'b0010; C = 8'b0000_0011; 
		#4 A = 4'b1001; B = 4'b0011; C = 8'b0000_0101;    
		#4 A = 4'b1100; B = 4'b0100; C = 8'b0000_0111;    
		#4 A = 4'b1111; B = 4'b0101; C = 8'b0000_1001;    
		#4 A = 4'b0010; B = 4'b0110; C = 8'b0000_1011;    
		#4 A = 4'b0101; B = 4'b0111; C = 8'b0000_1101;    
		#4 A = 4'b1000; B = 4'b1000; C = 8'b0000_1111;    

  	end
    
	always
	 #2 clk = ~clk;
	  
      
endmodule