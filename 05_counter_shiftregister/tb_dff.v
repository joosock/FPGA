module tb_dff;

reg r_clk, r_din, r_rstn;

dff U_dff(
    .din(r_din),
    .clk(r_clk),
    .rstn(r_rstn),
    .qout(out)
);

always #10 r_clk = ~r_clk;

initial begin
    forever begin 
        r_din = 0; r_rstn = 1; r_clk = 0; 
        #15 r_din = 1;
        #30 r_rstn = 0;
        #10 r_rstn = 1;
        #25 r_din = 0;
        #30 r_din = 1;
        #500 $finish ;
    end
end

endmodule
