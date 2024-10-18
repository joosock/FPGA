`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 13:33:50
// Design Name: 
// Module Name: key_seq_top
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


module key_seg_top(
    input        i_rstn      ,
    input        i_clk       ,
    input  [4:0] i_key_in    ,
    output [3:0] o_key_out   ,
    output [7:0] o_seg_com   ,
    output [7:0] o_seg_d      
);

wire        w_pls_1k;
wire [3:0] w_key_out  ;
wire       w_key_valid;
wire [4:0] w_key_value;
wire [31:0] w_bcd_data;
    
clk_pls U_CLK_PLS(
    .i_clk    (i_clk),
    .i_rstn   (i_rstn),
    .o_pls_1k (w_pls_1k)
);

key_scan U_key_scan (
    .i_rstn      (i_rstn     ),
    .i_clk       (i_clk      ),
    .i_pls_1k    (w_pls_1k   ),
    .i_key_in    (i_key_in   ),
    .o_key_out   (o_key_out  ),
    .o_key_valid (w_key_valid),
    .o_key_value (w_key_value)
);

key_shift U_key_shift (
    .i_rstn      (i_rstn     ),
    .i_clk       (i_clk      ),
    .i_key_valid (w_key_valid),
    .i_key_value (w_key_value),
    .o_bcd8d     (w_bcd_data )
);

seg8digit U_SEG8D (
    .i_rstn      (i_rstn    ),
    .i_clk       (i_clk     ),
    .i_pls_1k    (w_pls_1k  ),
    .i_bcd8d     (w_bcd_data),
    .o_seg_d     (o_seg_d   ),
    .o_seg_com   (o_seg_com )  
  );

endmodule