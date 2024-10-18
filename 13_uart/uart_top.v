`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:27:20
// Design Name: 
// Module Name: uart_top
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


module uart_top(
      input        i_rstn      ,
      input        i_clk       ,
      input        i_tx_start  ,
      input        i_rx_data   ,
      output       o_tx_data   ,
      input  [4:0] i_key_in    ,
      output [3:0] o_key_out   ,
      output [7:0] o_seg_d     ,
      output [7:0] o_seg_com   ,
      output       o_led_tx    ,
      output       o_led_rx    
  );
  
  wire        w_pls_1k;
  wire [ 4:0] w_bcd_data;
  wire [31:0] w_bcd8d;
  wire        w_led_tx;
  wire        w_led_rx;
  assign o_led_tx = ~w_led_tx;
  assign o_led_rx = ~w_led_rx;
  
  //inst
  clk_pls U_CLK_PLS (
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
  
  uart_tx U_TX (
      .i_rstn      (i_rstn     ),
      .i_clk       (i_clk      ),
      .i_tx_start  (i_tx_start ),
      .i_key_valid (w_key_valid),
      .i_bcd_data  (w_bcd_data ),
      .o_bcd8d     (w_bcd8d[31:16]),
      .o_led_tx    (w_led_tx   ),
      .o_tx_data   (o_tx_data  )
  );

  uart_rx U_RX (
      .i_rstn      (i_rstn     ),
      .i_clk       (i_clk      ),
      .i_rx_data   (i_rx_data  ),
      .o_bcd8d     (w_bcd8d[15:0]),
      .o_led_rx    (w_led_rx   )
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
  
  endmodule