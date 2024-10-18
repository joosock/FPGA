`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:20:01
// Design Name: 
// Module Name: model_tx
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


module model_tx(
      input         i_rstn       ,
      input         i_clk        ,
      input         i_tx_start   ,
      input  [ 7:0] i_rd_data    ,
      output        o_tx_data
  );
  //input is decimal : output ASCII
  //0~9 : d48~d57
  //a(10)~f(15) : d97~d102
  reg        r_tx_st_d;
  reg [10:0] r_ck_cnt;
  reg        r_tx_clk;
  reg [ 4:0] r_tx_cnt;
  reg        r_led_tx;

  reg        r_tx_data;
  
  //tx data trans start
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_tx_st_d <= 1'b0;
      end
      else begin
          r_tx_st_d <= i_tx_start;
      end
  end

  //tx clock cnt
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_ck_cnt <= 11'd0;
          r_tx_clk <= 1'b0;
          r_tx_cnt <= 5'd0;
          r_led_tx <= 1'b0;
      end
      else begin
          if(r_tx_cnt==20) begin
              if(r_tx_st_d) begin
                  r_ck_cnt <= 11'd1;
                  r_tx_cnt <= 0;
                  r_led_tx <= 1'b1;
              end
              else
                  r_led_tx <= 1'b0;
          end
          else begin
              if(r_ck_cnt==1042) begin
                  r_ck_cnt <= 11'd1;
                  r_tx_clk <= ~r_tx_clk;
                  r_tx_cnt <= r_tx_cnt +1;
              end
              else if(r_ck_cnt==0 && r_tx_st_d) begin
                  r_ck_cnt <= 11'd1;
                  r_tx_cnt <= 0;
                  r_led_tx <= 1'b1;
              end
              else if(r_ck_cnt!=0) begin
                  r_ck_cnt <= r_ck_cnt+1;
              end
          end
      end
  end

  //tx data
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_tx_data <= 1'b1;
      end
      else begin
          if(r_ck_cnt==1 && r_tx_cnt==0)
              r_tx_data <= 1'b0; //tx start
          else if(r_ck_cnt==1 && r_tx_cnt==2)
              r_tx_data <= i_rd_data[0]; //tx data[0]
          else if(r_ck_cnt==1 && r_tx_cnt==4)
              r_tx_data <= i_rd_data[1]; //tx data[1]
          else if(r_ck_cnt==1 && r_tx_cnt==6)
              r_tx_data <= i_rd_data[2]; //tx data[2]
          else if(r_ck_cnt==1 && r_tx_cnt==8)
              r_tx_data <= i_rd_data[3]; //tx data[3]
          else if(r_ck_cnt==1 && r_tx_cnt==10)
              r_tx_data <= i_rd_data[4]; //tx data[4]
          else if(r_ck_cnt==1 && r_tx_cnt==12)
              r_tx_data <= i_rd_data[5]; //tx data[5]
          else if(r_ck_cnt==1 && r_tx_cnt==14)
              r_tx_data <= i_rd_data[6]; //tx data[6]
          else if(r_ck_cnt==1 && r_tx_cnt==16)
              r_tx_data <= i_rd_data[7]; //tx data[7]
          else if(r_ck_cnt==1 && r_tx_cnt==18)
              r_tx_data <= 1'b1; //tx stop
          else if(r_ck_cnt==1 && r_tx_cnt==20)
              r_tx_data <= 1'b1; //idle
      end
  end
  
  assign o_tx_data = r_tx_data;
  
  endmodule
