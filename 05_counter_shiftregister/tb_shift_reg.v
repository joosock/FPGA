module tb_shift_reg;

reg en, rstn, din, clk;
wire [7:0] out_dq;

shift_reg U_SHIFT_REG ( 
    .i_rstn(rstn),
    .i_en(en),
    .i_din(din),
    .i_clk(clk),
    .o_dq(out_dq)
);

initial begin
    #0;     en = 0;
    #500;   en = 1;
    #1500;  en = 0;
end

initial begin
    #0;     rstn = 0;   din = 0;
    #400;   rstn = 1;
    repeat(5) begin
        #100; din = 1;
        #100; din = 0;
        #100; din = 1;
        #100; din = 1;
        #100; din = 0;
        #100; din = 0;
    end
    #100; $finish;
end

initial begin
    #0;     clk = 0;
    forever begin
        #50 clk = ~ clk;
    end
end        

endmodule
