`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/27 13:23:17
// Design Name: 
// Module Name: tb_uart
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


module tb_uart;

reg clk;
reg rstn;
reg [4:0] key_push;
reg tx_start;

wire [3:0] key_out;
wire [4:0] key_in;

//model instance
  reg [7:0] tx_data;
  reg       tx_st;
  wire w_rx_data;
  wire w_tx_data;
  
  wire d_rx_data;

initial begin
    #0;  rstn=0;
    #400; rstn=1;
end
initial begin
    #0; clk=0;
    forever begin
        #50 clk = ~clk;
    end
end

initial begin
    #0; key_push=5'd0; tx_start=1;
        tx_data=8'h00; tx_st=0;
    #33_000_000; key_push = 5'd1;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd2;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd3;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd4;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd5;
    #33_000_000; key_push = 5'd0;
    #33_000_000; key_push = 5'd6;
    #33_000_000; key_push = 5'd0;
    #33_000_000; tx_start = 0;
    #10_000_000; tx_start = 1;
    #10_000_000; tx_start = 0;
    #10_000_000; tx_start = 1;
    #10_000_000; tx_start = 0;
    #10_000_000; tx_start = 1;
    #10_000_000; tx_start = 0;
    #10_000_000; tx_start = 1;
    #10_000_000; tx_start = 0;
    #10_000_000; tx_start = 1;

    #10_000_000; tx_data=8'd88; #10000; tx_st=1; #100; tx_st=0;
    #10_000_000; tx_data=8'd89; #10000; tx_st=1; #100; tx_st=0;
    #10_000_000; tx_data=8'd90; #10000; tx_st=1; #100; tx_st=0;
    
    //#50_000; $finish;
end

`ifdef KEY_TEST
initial begin
    #0; key_push=5'd0;
    repeat(19) begin
        #33_000_000; key_push = key_push +1;
        #33_000_000; key_push = 0;
    end
    
    #50_000; $finish;
end
`endif

assign #39 d_rx_data = w_rx_data;
//model instance
  model_rx M_RX (
  /*input         */ .i_rstn   (rstn)
  /*input         */,.i_clk    (clk) 
  /*input         */,.i_rx_data(w_tx_data)  
  );
  model_tx M_TX(
  /*input         */ .i_rstn    (rstn)  
  /*input         */,.i_clk     (clk)  
  /*input         */,.i_tx_start(tx_st) 
  /*input  [ 7:0] */,.i_rd_data (tx_data ) 
  /*output        */,.o_tx_data (w_rx_data )
  );


//instance block
key_pad U_KEY_MATRIX (
.rst            (rstn),
.clk            (clk),
.key_v          (key_push),
.key_column_in  (key_out),
.key_row_out    (key_in)
);

uart_top U_UART_TOP(
/*input        */ .i_rstn    (rstn)
/*input        */,.i_clk     (clk)
/*input        */,.i_tx_start(tx_start)
/*input        */,.i_rx_data (d_rx_data)
/*output       */,.o_tx_data (w_tx_data)
/*input  [4:0] */,.i_key_in  (key_in )
/*output [3:0] */,.o_key_out (key_out)
/*output [7:0] */,.o_seg_d   ()
/*output [7:0] */,.o_seg_com ()
/*output [1:0] */,.o_led_tx  ()
/*output [1:0] */,.o_led_rx  ()
);
    

endmodule