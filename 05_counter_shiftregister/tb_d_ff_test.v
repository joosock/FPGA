module tb_d_ff_test(
    );
    
reg     din, clk, rstn;
wire    out;

d_ff_test U_D_FF_TET(
    .i_rstn(rstn),
    .i_clk(clk),
    .i_din(din),
    .o_qout(out)
);

initial begin
    #0;     din = 0;    rstn = 0 ;
    #100;   rstn = 1;
    #500;   din = 1; 
    #700;   din = 0;
    #1000;  $finish;
end

initial begin
    #0;     clk = 0;
    forever begin
        #50 clk = ~clk;
    end
end
 
endmodule
