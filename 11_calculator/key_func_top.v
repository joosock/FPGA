`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 11:46:53
// Design Name: 
// Module Name: key_func_top
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


module key_func_top(
    input        i_rstn      ,
    input        i_clk       ,
    input        i_pls_1k    ,
    input  [4:0] i_key_in    ,
    output [3:0] o_key_out   ,
    output [4:0] o_bcd_data  ,
    output       o_key_valid 
);
wire [3:0] w_key_out  ;
wire       w_key_valid;
wire       w_key_valid_d;
wire [4:0] w_key_value;
    
key_scan U_key_scan (
    .i_rstn      (i_rstn     ),
    .i_clk       (i_clk      ),
    .i_pls_1k    (i_pls_1k   ),
    .i_key_in    (i_key_in   ),
    .o_key_out   (o_key_out  ),
    .o_key_valid (w_key_valid),
    .o_key_value (w_key_value)
);

key_assign U_key_assign (
    .i_rstn      (i_rstn     ),
    .i_clk       (i_clk      ),
    .i_key_valid (w_key_valid),
    .i_key_value (w_key_value),
    .o_bcd_data  (o_bcd_data ),
    .o_key_valid (w_key_valid_d)
);

assign  o_key_valid = w_key_valid_d;

endmodule