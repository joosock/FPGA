module tb_edge_counter();

reg r_rstn, r_clk, r_pls;
wire w_redge;

edge_counter U_EDGE_COUNTER(
    .i_rstn(r_rstn),
    .i_clk(r_clk),
    .i_pls(r_pls),
    .o_pls_10(w_o_pls_10)   
);

initial begin
    #0; r_rstn = 0; r_pls = 0; r_clk = 0;
    #100; r_rstn = 1;
    #10000 $finish ;
end

always #300 r_pls = ~ r_pls;
always #10 r_clk = ~r_clk;

endmodule
