`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 15:12:55
// Design Name: 
// Module Name: key_pad
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module key_pad
(
input	rst						,
input	clk						,	// 10MHz System Clock
input	[4:0]	key_v			,	// 5bit Key Assign Input for Simulation
input	[3:0]	key_column_in	,	// 4bit Key Pad Column Input from KEY_SCAN.V, key_out[3:0]
output	reg [4:0]	key_row_out		// 5bit Key Pad Row Output to KEY_SCAN.V, key_in[4:0]
);

always@(negedge rst, posedge clk)
	if (rst == 0)
		key_row_out <= 5'b11111; 
	else if (key_v >= 26)
		key_row_out <= 5'b11111; 
	else	
		if 	  	(key_column_in == 4'b1110)		// Column 0 Check
			if 	  	(key_v == 01)	key_row_out <= 5'b11110;
			else if (key_v == 02)	key_row_out <= 5'b11101;
			else if (key_v == 03)	key_row_out <= 5'b11011;
			else if (key_v == 04)	key_row_out <= 5'b10111;
			else if (key_v == 05)	key_row_out <= 5'b01111;
			else if (key_v == 21)	key_row_out <= 5'b01110;
			else if (key_v == 25)	key_row_out <= 5'b11110;
			else					key_row_out <= 5'b11111;
		else if (key_column_in == 4'b1101)		// Column 1 Check
			if 	  	(key_v == 06)	key_row_out <= 5'b11110;
			else if (key_v == 07)	key_row_out <= 5'b11101;
			else if (key_v == 08)	key_row_out <= 5'b11011;
			else if (key_v == 09)	key_row_out <= 5'b10111;
			else if (key_v == 10)	key_row_out <= 5'b01111;
			else if (key_v == 22)	key_row_out <= 5'b01110;
			else if (key_v == 25)	key_row_out <= 5'b11110;
			else					key_row_out <= 5'b11111;
		else if (key_column_in == 4'b1011)		// Column 2 Check
			if 	  	(key_v == 11)	key_row_out <= 5'b11110;
			else if (key_v == 12)	key_row_out <= 5'b11101;
			else if (key_v == 13)	key_row_out <= 5'b11011;
			else if (key_v == 14)	key_row_out <= 5'b10111;
			else if (key_v == 15)	key_row_out <= 5'b01111;
			else if (key_v == 23)	key_row_out <= 5'b01110;
			else					key_row_out <= 5'b11111;
		else if (key_column_in == 4'b0111)		// Column 3 Check
			if 	  	(key_v == 16)	key_row_out <= 5'b11110;
			else if (key_v == 17)	key_row_out <= 5'b11101;
			else if (key_v == 18)	key_row_out <= 5'b11011;
			else if (key_v == 19)	key_row_out <= 5'b10111;
			else if (key_v == 20)	key_row_out <= 5'b01111;
			else if (key_v == 24)	key_row_out <= 5'b01110;
			else					key_row_out <= 5'b11111;
		else						key_row_out <= 5'b11111;

endmodule