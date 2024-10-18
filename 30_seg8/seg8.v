`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/08 10:44:15
// Design Name: 
// Module Name: seg8
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


module seg8(
    output  [7:0]   o_seg_com,
    output  [7:0]   o_seg_d
    );
    
assign  o_seg_com = 8'b11110101 ;
assign  o_seg_d   = 8'b11101111 ;

endmodule
