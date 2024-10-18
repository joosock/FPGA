`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:27:59
// Design Name: 
// Module Name: uart_tx
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


module uart_tx (
      input         i_rstn      ,
      input         i_clk       ,
      input         i_tx_start  ,
      input         i_key_valid ,
      input  [ 4:0] i_bcd_data  ,
      output [15:0] o_bcd8d     , //left seg
      output        o_led_tx    ,
      output        o_tx_data
  );

  reg r_tx_st_d1;
  reg r_tx_st_d2;
  reg r_tx_st_d3;
  wire        w_tx_start_d;
  wire        w_wr_valid;
  wire [ 7:0] w_wr_data ;
  wire        w_rd_valid;
  wire [ 7:0] w_rd_data ;

  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_tx_st_d1 <= 1'b1;
          r_tx_st_d2 <= 1'b1;
          r_tx_st_d3 <= 1'b1;
      end
      else begin
          r_tx_st_d1 <= i_tx_start;
          r_tx_st_d2 <= r_tx_st_d1;
          r_tx_st_d3 <= r_tx_st_d2;
      end
  end
  assign w_tx_start_d = r_tx_st_d2 & (!r_tx_st_d3); //uart tx ÀÇ start ½ÅÈ£ 
  
  uart_tx_byte U_UART_BYTE (
  /*input        */ .i_rstn       (i_rstn      )
  /*input        */,.i_clk        (i_clk       )
  /*input        */,.i_tx_start_d (w_tx_start_d)
  /*input        */,.i_key_valid  (i_key_valid )
  /*input  [ 4:0]*/,.i_bcd_data   (i_bcd_data  )
  /*output       */,.o_wr_valid   (w_wr_valid  )
  /*output [ 7:0]*/,.o_wr_data    (w_wr_data   )
  /*output       */,.o_rd_valid   (w_rd_valid  )
  /*input  [ 7:0]*/,.i_rd_data    (w_rd_data   )
  /*output       */,.o_led_tx     (o_led_tx    )
  /*output       */,.o_tx_data    (o_tx_data   )
  );

  tx_fifo4 U_TX_FIFO4 (
  /*input        */ .i_rstn       (i_rstn      )
  /*input        */,.i_clk        (i_clk       )
  /*input        */,.i_wr_valid   (w_wr_valid  )
  /*input  [ 7:0]*/,.i_wr_data    (w_wr_data   )
  /*input        */,.i_rd_valid   (w_rd_valid  )
  /*input  [ 7:0]*/,.o_rd_data    (w_rd_data   )
  /*output [15:0]*/,.o_bcd8d      (o_bcd8d     )
  );

  endmodule