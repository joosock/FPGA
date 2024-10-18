`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:21:40
// Design Name: 
// Module Name: rx_fifo4
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


module rx_fifo4(
      input         i_rstn     ,
      input         i_clk      ,
      input         i_wr_valid ,
      input  [ 7:0] i_wr_data  ,
      output [15:0] o_bcd8d     
  );

  reg [7:0] r_buf [0:3];
  reg [1:0] r_cur_w;
  reg [1:0] r_cur_r;
  wire [3:0] w_buf_d1;
  wire [3:0] w_buf_d2;
  wire [3:0] w_buf_d3;
  wire [3:0] w_buf_d4;

  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_buf[0]  <= 8'h0;
          r_buf[1]  <= 8'h0;
          r_buf[2]  <= 8'h0;
          r_buf[3]  <= 8'h0;
          r_cur_w   <= 2'd0;
          r_cur_r   <= 2'd0;
      end
      else begin
          if(i_wr_valid) begin
              r_buf[r_cur_w] <= i_wr_data;  
              r_cur_w <= r_cur_w + 1;
          end
      end
  end

  assign w_buf_d1 = r_buf[0]>=48 && r_buf[0]<=57  ? r_buf[0]-48 :
	            r_buf[0]>=97 && r_buf[0]<=106 ? r_buf[0]-87 : 0;
  assign w_buf_d2 = r_buf[1]>=48 && r_buf[1]<=57  ? r_buf[1]-48 :
	            r_buf[1]>=97 && r_buf[1]<=106 ? r_buf[1]-87 : 0;
  assign w_buf_d3 = r_buf[2]>=48 && r_buf[2]<=57  ? r_buf[2]-48 :
	            r_buf[2]>=97 && r_buf[2]<=106 ? r_buf[2]-87 : 0;
  assign w_buf_d4 = r_buf[3]>=48 && r_buf[3]<=57  ? r_buf[3]-48 :
	            r_buf[3]>=97 && r_buf[3]<=106 ? r_buf[3]-87 : 0;
  assign o_bcd8d = {w_buf_d4, w_buf_d3, w_buf_d2, w_buf_d1};

  endmodule