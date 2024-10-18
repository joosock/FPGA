module memory(
	input reset,
	input clk,
	input READ,
	input WRITE,
	input [4:0] MEM_ADDR,
	input [7:0] MEM_DATA1,
	output reg [7:0] MEM_DATA2
	);

                 
//
reg [7:0] tmp   ;
reg [7:0] one   ;
reg [7:0] last_n;
reg [7:0] n     ;
reg [7:0] xn1   ;
reg [7:0] xn    ;
reg temp        ;

always@(posedge reset or posedge clk) begin
	 if(reset) begin
	  MEM_DATA2 <= 8'b0;
	  temp      <= 0;
	 end
	 else begin
	 	if(temp == 0)begin
		 tmp    <= 8'b0       ;
		 one    <= 8'b00000001;
		 last_n <= 8'b00001010;
		 n      <= 8'b00000000;
		 xn1    <= 8'b00000001;
		 xn     <= 8'b00000001;
		 temp   <= 1;
		end
		if(READ)
			case(MEM_ADDR)
			  5'b00000 : MEM_DATA2 <= 8'b10111111;
			  5'b00001 : MEM_DATA2 <= 8'b01011110;
			  5'b00010 : MEM_DATA2 <= 8'b11011010;
			  5'b00011 : MEM_DATA2 <= 8'b10111111;
			  5'b00100 : MEM_DATA2 <= 8'b11011110;
			  5'b00101 : MEM_DATA2 <= 8'b10111010;
			  5'b00110 : MEM_DATA2 <= 8'b11011111;
			  5'b00111 : MEM_DATA2 <= 8'b10111101;
			  5'b01000 : MEM_DATA2 <= 8'b01011011;
			  5'b01001 : MEM_DATA2 <= 8'b11011101;
			  5'b01010 : MEM_DATA2 <= 8'b10011100;
			  5'b01011 : MEM_DATA2 <= 8'b00100000;
			  5'b01100 : MEM_DATA2 <= 8'b11100000;
			  5'b01101 : MEM_DATA2 <= 8'b00000000;
			  5'b11010 : MEM_DATA2 <= tmp        ;
           5'b11011 : MEM_DATA2 <= one        ;
           5'b11100 : MEM_DATA2 <= last_n     ;
           5'b11101 : MEM_DATA2 <= n          ;
           5'b11110 : MEM_DATA2 <= xn1        ;
           5'b11111 : MEM_DATA2 <= xn         ;
           default  : MEM_DATA2 <= 8'b00000000;
        endcase
		else if(WRITE)
			case(MEM_ADDR)
			 5'b11010 : tmp    <= MEM_DATA1; 
			 5'b11011 : one    <= MEM_DATA1;
			 5'b11100 : last_n <= MEM_DATA1;
			 5'b11101 : n      <= MEM_DATA1;
			 5'b11110 : xn1    <= MEM_DATA1;
			 5'b11111 : xn     <= MEM_DATA1;
			endcase
		end
 end
     
endmodule