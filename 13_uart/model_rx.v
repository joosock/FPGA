`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:18:14
// Design Name: 
// Module Name: model_rx
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


module model_rx(
      input         i_rstn      ,
      input         i_clk       ,
      input         i_rx_data   
  );
  reg         r_rx_d1;
  reg         r_rx_d2;
  reg         r_rx_d3;
  reg [10:0]  r_clk_cnt;
  reg         r_rx_clk ;
  reg [ 4:0]  r_rx_cn;
  reg         r_rx_clk_d;

  wire        w_rx_pls;
  wire        w_rx_start;
  wire        w_edge_f;

  reg [ 7:0] r_data;
  reg        r_err;
  reg        r_wr_valid;
  reg [ 3:0] r_rx_cnt;
  reg        r_led_rx;

  //rx pls gen
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
          r_rx_cn <= 5'd0;
      end
      else begin
          if(r_rx_cn==20) begin
              if(w_edge_f) begin
                  r_clk_cnt <= 11'd1;
                  r_rx_cn <= 5'd0;
              end
          end
          else begin
              if(r_clk_cnt==1042) begin
                  r_clk_cnt <= 11'd1;
                  r_rx_clk <= ~r_rx_clk;
                  r_rx_cn <= r_rx_cn+1;
              end
              else if(w_edge_f==1 && r_clk_cnt==0) begin
                  r_clk_cnt <= 11'd1;
                  r_rx_cn <= 5'd0;
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
  assign w_rx_start = r_rx_cn==1 && w_rx_pls==1;

  //tx clock cnt
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_rx_cnt <= 4'd0;
          r_data   <= 8'h0;
          r_err    <= 1'b0;
          r_wr_valid <= 1'b0;
          r_led_rx <= 1'b0;
      end
      else if(w_rx_start) begin
          if(!r_rx_d2)
              r_rx_cnt <= 1;
          else
              r_err <= 1'b1;

          r_led_rx <= 1'b1;
      end
      else if(w_rx_pls) begin
          if(r_rx_cnt==1) begin
              r_data[0] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==2) begin
              r_data[1] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==3) begin
              r_data[2] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==4) begin
              r_data[3] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==5) begin
              r_data[4] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==6) begin
              r_data[5] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==7) begin
              r_data[6] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==8) begin
              r_data[7] <= r_rx_d2;
              r_rx_cnt <= r_rx_cnt+1;
          end
          else if(r_rx_cnt==9) begin
              if(r_rx_d2)
                  r_wr_valid <= 1'b1;
              else
                  r_err <= 1;
              r_rx_cnt <= 0;
              r_led_rx <= 1'b0;
	      $display("[M]rx data=0x%d",r_data);
          end
      end
      else
          r_wr_valid <= 1'b0;
  end
  
  endmodule