module edge_det(
    
    input i_clk, i_rstn,
    input i_din,
    output o_r_edge,
    output o_f_edge
); 

reg r_q0;
reg r_q1;

always @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_q0 <= 1'b0;
        r_q1 <= 1'b0;
    end
    else begin
        r_q0 <= i_din;
        r_q1 <= r_q0;
    end
end

assign o_r_edge = r_q0 & !r_q1;
assign o_f_edge = !r_q0 & r_q1;

endmodule 
