`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 11:43:45
// Design Name: 
// Module Name: calc_top
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


module calc_top(
    input        i_rstn      ,
    input        i_clk       ,
    input  [4:0] i_key_in    ,
    output [3:0] o_key_out   ,

    output [7:0] o_seg_d     ,
    output [7:0] o_seg_com   ,
    output [3:0] o_led_op
);

wire        w_pls_1k;
wire [ 4:0] w_bcd_data;
wire [31:0] w_bcd8d;
wire        w_err;

//inst
clk_pls U_CLK_PLS(
    .i_clk    (i_clk),
    .i_rstn   (i_rstn),
    .o_pls_1k (w_pls_1k)
);

key_func_top U_KEY_FUNC_TOP (
    .i_rstn      (i_rstn   ),
    .i_clk       (i_clk    ),
    .i_pls_1k    (w_pls_1k ),
    .i_key_in    (i_key_in ),
    .o_key_out   (o_key_out),
    .o_bcd_data  (w_bcd_data),
    .o_key_valid (w_key_valid)
);

calc_disp U_CALC_CAL (
    .i_rstn      (i_rstn     ),
    .i_clk       (i_clk      ),
    .i_key_valid (w_key_valid),
    .i_bcd_data  (w_bcd_data ),
    .o_bcd8d     (w_bcd8d    ),
    .o_led_op    (o_led_op   ),
    .o_err       (w_err      )
);

//output device
//7segment 8digit
seg8digit U_SEG8D (
     .i_rstn    (i_rstn   ),
     .i_clk     (i_clk    ),
     .i_pls_1k  (w_pls_1k ),
     .i_bcd8d   (w_bcd8d  ),
     .i_err     (w_err    ),
     .o_seg_d   (o_seg_d  ),
     .o_seg_com (o_seg_com)  
);


endmodule