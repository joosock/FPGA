`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:24:09
// Design Name: 
// Module Name: tx_fifo4
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


module tx_fifo4(
      input         i_rstn     ,
      input         i_clk      ,
      input         i_wr_valid ,
      input  [ 7:0] i_wr_data  ,
      input         i_rd_valid ,
      input  [ 7:0] o_rd_data  ,
      output [15:0] o_bcd8d     
  );

  reg [7:0] r_buf [0:3];
  reg [2:0] r_cur_w;
  reg [7:0] r_rd_data;
  wire [3:0] w_buf_d1;
  wire [3:0] w_buf_d2;
  wire [3:0] w_buf_d3;
  wire [3:0] w_buf_d4;

  //cnt=0 is empty
  //cnt=1 buf[0]
  //cnt=2 buf[1]
  //cnt=3 buf[2]
  //cnt=4 buf[3] is full
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_buf[0]  <= 8'h0;
          r_buf[1]  <= 8'h0;
          r_buf[2]  <= 8'h0;
          r_buf[3]  <= 8'h0;
          r_cur_w   <= 3'd0;
          r_rd_data <= 8'h0;
      end
      else begin
          if(i_wr_valid) begin
              r_buf[0] <= i_wr_data;  
              r_buf[1] <= r_buf[0];  
              r_buf[2] <= r_buf[1];  
              r_buf[3] <= r_buf[2];
              if(r_cur_w==4)        
                  r_cur_w <= 4;
              else 
                  r_cur_w <= r_cur_w + 1;
          end

          if(i_rd_valid) begin
              if(r_cur_w==0) 
                  r_rd_data <= 0;
              else begin
                  r_rd_data <= r_buf[r_cur_w-1];
                  r_buf[r_cur_w-1] <=0;
                  r_cur_w <= r_cur_w - 1;
              end
          end
      end
  end

  assign o_rd_data = r_rd_data;

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