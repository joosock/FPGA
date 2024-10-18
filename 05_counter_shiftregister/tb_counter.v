module tb_counter;

reg r_rstn, r_clk;
wire [2:0] r_cnt;

counter U_COUNTER(
    .i_rstn(r_rstn),
    .i_clk(r_clk),
    .o_cnt(r_cnt)
);

initial begin
    #0;     r_clk = 0; r_rstn = 0;
    #100;   r_rstn = 1;
    #2000;  $finish;
end
 
always #40 r_clk = ~ r_clk; 

endmodule
