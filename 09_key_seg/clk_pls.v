`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/18 13:32:51
// Design Name: 
// Module Name: clk_pls
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


module clk_pls(     
    input i_clk,
    input i_rstn,
    output o_pls_1k
);

reg [13:0] cnt_1k;
reg        pls_1k;

always@(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        cnt_1k <= 14'd0;
        pls_1k <= 1'b0;
    end
    else begin
        if(cnt_1k==14'd9999) begin    // 0~9999 즉 10000개 count 하면 clk 이 100ns 이므로 100n*10000=1ms, 1KHz 임 
            cnt_1k <= 14'd0;
            pls_1k <= 1'b1;
        end
        else if(cnt_1k==14'd0) begin
            pls_1k <= 1'b0;
            cnt_1k <= cnt_1k+1;
        end
        else begin
            cnt_1k <= cnt_1k+1;
        end
    end
end
assign o_pls_1k = pls_1k;
endmodule