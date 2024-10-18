`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/20 15:22:27
// Design Name: 
// Module Name: timer_top
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


module timer_top(
    input        i_rstn      ,
    input        i_clk       ,
    input        i_start_sw  ,
    input  [4:0] i_key_in    ,
    output [3:0] o_key_out   ,
    output       o_buzzer    ,
    output [7:0] o_led    ,

    output [7:0] o_seg_d     ,
    output [7:0] o_seg_com   
);

wire        w_pls_1k;
wire [ 4:0] w_bcd_data;
wire [31:0] w_bcd8d;
wire        w_fin;

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

disp_cal U_DISP_CAL (
    .i_rstn      (i_rstn     ),
    .i_clk       (i_clk      ),
    .i_pls_1k    (w_pls_1k   ),
    .i_key_valid (w_key_valid),
    .i_start     (i_start_sw ),
    .i_bcd_data  (w_bcd_data ),
    .o_bcd8d     (w_bcd8d    ),
    .o_fin       (w_fin      )
);

//output device
//7segment 8digit
seg8digit U_SEG8D (
     .i_rstn    (i_rstn   ),
     .i_clk     (i_clk    ),
     .i_pls_1k  (w_pls_1k ),
     .i_bcd8d   (w_bcd8d  ),
     .o_seg_d   (o_seg_d  ),
     .o_seg_com (o_seg_com)   
);
//buzzer
buzzer_cnt U_BUZZ (
     .i_rstn   (i_rstn   ),
     .i_clk    (i_clk    ),
     .i_pls_1k (w_pls_1k ),
     .i_go     (w_fin    ),
     .o_buzzer (o_buzzer )
);
//4 led
led_blink U_LED_B (
     .i_rstn   (i_rstn   ),
     .i_clk    (i_clk    ),
     .i_pls_1k (w_pls_1k ),
     .i_go     (w_fin    ),
     .o_led_on (o_led )
);

endmodule