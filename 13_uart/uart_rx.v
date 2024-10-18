`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:24:47
// Design Name: 
// Module Name: uart_rx
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


module uart_rx (
      input         i_rstn      ,
      input         i_clk       ,
      input         i_rx_data   ,
      output [15:0] o_bcd8d     ,
      output        o_rx_err    ,    
      output        o_led_rx    
  );
  reg         r_rx_d1, r_rx_d2, r_rx_d3;
  reg [10:0]  r_clk_cnt;
  reg         r_rx_clk ;
  reg [ 4:0]  r_rx_cnt;
  reg         r_rx_clk_d;
  wire        w_rx_pls;
  wire        w_rx_start;
  wire        w_edge_f;
  wire        w_wr_valid;
  wire [ 7:0] w_wr_data ;

  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_rx_d1 <= 1'b1;
          r_rx_d2 <= 1'b1;
          r_rx_d3 <= 1'b1;
      end
      else begin
          r_rx_d1 <= i_rx_data;
          r_rx_d2 <= r_rx_d1;
          r_rx_d3 <= r_rx_d2;
      end
  end

  assign w_edge_f = (!r_rx_d2) & (r_rx_d3);

  //rx clock gen
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_clk_cnt <= 11'd0;
          r_rx_clk <= 1'b0;
          r_rx_cnt <= 5'd0;
      end
      else begin
          if(r_rx_cnt==20) begin
              if(w_edge_f) begin
                  r_clk_cnt <= 11'd1;
                  r_rx_cnt <= 5'd0;
              end
          end
          else begin
              if(r_clk_cnt==1042) begin
                  r_clk_cnt <= 11'd1;
                  r_rx_clk <= ~r_rx_clk;
                  r_rx_cnt <= r_rx_cnt+1;
              end
              else if(w_edge_f==1 && r_clk_cnt==0) begin
                  r_clk_cnt <= 11'd1;
                  r_rx_cnt <= 5'd0;
              end
              else if(r_clk_cnt!=0) begin
                  r_clk_cnt <= r_clk_cnt+1;
              end
          end
      end
  end
  //rx pulse gen
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_rx_clk_d <= 1'b0;
      end
      else begin
          r_rx_clk_d <= r_rx_clk;
      end
  end
  assign w_rx_pls   = r_rx_clk & (!r_rx_clk_d);
  assign w_rx_start = r_rx_cnt==1 && w_rx_pls==1;

  uart_rx_byte U_UART_BYTE (
  /*input        */ .i_rstn       (i_rstn      )
  /*input        */,.i_clk        (i_clk       )
  /*input        */,.i_rx_start   (w_rx_start  )
  /*input        */,.i_rx_pls     (w_rx_pls    )
  /*input        */,.i_rx_data    (r_rx_d2     )
  /*output       */,.o_wr_valid   (w_wr_valid  )
  /*output [ 7:0]*/,.o_wr_data    (w_wr_data   )
  /*output       */,.o_led_rx     (o_led_rx    )
  /*output       */,.o_rx_err     (o_rx_err    )
  );

  rx_fifo4 U_RX_FIFO4 (
  /*input        */ .i_rstn       (i_rstn      )
  /*input        */,.i_clk        (i_clk       )
  /*input        */,.i_wr_valid   (w_wr_valid  )
  /*input  [ 7:0]*/,.i_wr_data    (w_wr_data   )
  /*output [15:0]*/,.o_bcd8d      (o_bcd8d     )
  );

  endmodule
