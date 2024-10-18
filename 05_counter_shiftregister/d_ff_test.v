module d_ff_test(
    input i_rstn, i_clk,
    input i_din,
    output o_qout
    );
    
reg r_qout;

always @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_qout <= 1'b0;
     end
     else begin
        r_qout <= i_din;
     end
end
  
endmodule
