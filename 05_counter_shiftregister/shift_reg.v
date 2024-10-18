module shift_reg(
    input i_clk,
    input i_rstn,
    input i_en,
    input i_din,
    output [7:0] o_dq
);

reg [7:0] r_dq;

always @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_dq <= 8'b0;
    end
    else if ( i_en == 1'b1 ) begin
        r_dq <= {r_dq[6:0], i_din};
    end
end

assign o_dq = r_dq;

endmodule
