`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 16:16:19
// Design Name: 
// Module Name: mux41
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


module mux41(
    input [7:0] i_d_0,
    input [7:0] i_d_1,
    input [7:0] i_d_2,
    input [7:0] i_d_3,
    input [1:0] i_sel,
    output [7:0] o_y
    );
    
assign o_y = i_sel == 2'b00 ? i_d_0 :
             i_sel == 2'b01 ? i_d_1 :
             i_sel == 2'b10 ? i_d_2 :
                              i_d_3 ;
endmodule