module tb_edge_det;

reg r_rstn, r_clk, r_din;

edge_det U_EDGE_DET(
    .i_rstn(r_rstn),
    .i_clk(r_clk),
    .i_din(r_din),
    .o_r_edge(r_edge),
    .o_f_edge(f_edge)
);

always #4 r_clk = ~r_clk;

initial begin
    forever begin 
        r_din = 0; r_rstn = 0; r_clk = 0; 
        #15 r_din = 1;
        #30 r_rstn = 1;
        #50 r_din = 0;
        #100 r_din = 1;
        #50  r_din = 0;
        #500 $finish ;
    end
end

endmodule
