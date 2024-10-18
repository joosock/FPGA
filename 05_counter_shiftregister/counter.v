module counter(
    input i_clk,
    input i_rstn,
    output [2:0] o_cnt
);

reg [2:0] r_cnt;

always @ (posedge  i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_cnt <= 3'd0;
    end
    else begin
        r_cnt <= r_cnt + 1;
    end
end

assign o_cnt = r_cnt;

endmodule
