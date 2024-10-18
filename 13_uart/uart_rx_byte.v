`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:25:34
// Design Name: 
// Module Name: uart_rx_byte
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


module uart_rx_byte (
      input         i_rstn      ,
      input         i_clk       ,
      input         i_rx_start  ,
      input         i_rx_pls    ,
      input         i_rx_data   ,
      output        o_wr_valid  ,
      output [ 7:0] o_wr_data   ,
      output        o_rx_err    ,
      output        o_led_rx    
  );

  reg [ 7:0] r_data;
  reg        r_err;
  reg        r_wr_valid;
  reg [ 3:0] r_rx_cnt;
  reg        r_led_rx;

  //rx clock cnt
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_rx_cnt <= 4'd0;
      end
      else if(i_rx_start) begin
          if(!i_rx_data)
              r_rx_cnt <= 1;
      end
      else if(i_rx_pls) begin
          if(r_rx_cnt==9)
              r_rx_cnt <= 0;
	  else 
              r_rx_cnt <= r_rx_cnt+1;
      end
  end
  //rx data capture
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_data   <= 8'h0;
      end
      else if(i_rx_pls) begin
          if(r_rx_cnt==1)      r_data[0] <= i_rx_data;
          else if(r_rx_cnt==2) r_data[1] <= i_rx_data;
          else if(r_rx_cnt==3) r_data[2] <= i_rx_data;
          else if(r_rx_cnt==4) r_data[3] <= i_rx_data;
          else if(r_rx_cnt==5) r_data[4] <= i_rx_data;
          else if(r_rx_cnt==6) r_data[5] <= i_rx_data;
          else if(r_rx_cnt==7) r_data[6] <= i_rx_data;
          else if(r_rx_cnt==8) r_data[7] <= i_rx_data;
          else if(r_rx_cnt==9) $display("[HW]rx data=0x%d",r_data);
      end
  end
  
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_err    <= 1'b0;
          r_wr_valid <= 1'b0;
          r_led_rx <= 1'b0;
      end
      else if(i_rx_start) begin
          if(i_rx_data)
              r_err <= 1'b1;
          r_led_rx <= 1'b1;
      end
      else if(i_rx_pls) begin
          if(r_rx_cnt==9) begin
              if(i_rx_data)
                  r_wr_valid <= 1'b1;
              else
                  r_err <= 1;
              r_led_rx <= 1'b0;
          end
      end
      else
          r_wr_valid <= 1'b0;
  end
  
  assign o_wr_valid = r_wr_valid;
  assign o_wr_data  = r_data;
  assign o_rx_err = r_err;
  assign o_led_rx = r_led_rx;
  
  endmodule