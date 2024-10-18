module edge_counter(
    input i_clk, 
    input i_rstn,
    input i_pls,
    output o_pls_10      
    );    
reg         r_q0, r_q1;
reg [3:0]   r_cnt;
reg         r_pls_10;
wire        w_redge;
wire        w_q0, w_q1;

always @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_q0 <= 1'b0;
        r_q1 <= 1'b0;
    end
    else begin
        r_q0 <= i_pls;
        r_q1 <= r_q0;  
    end
end

assign w_redge = r_q0 ^ r_q1;
assign w_q0 = r_q0;
assign w_q1 = r_q1;


always @(posedge i_clk, negedge i_rstn) begin
    if(!i_rstn) begin
        r_cnt       <= 4'd0;
        r_pls_10    <= 1'b0;
    end
    else if(w_redge) begin
        if(r_cnt == 4'd9) begin
            r_cnt <= 0;
            r_pls_10 <= 1'b1;
        end
        else begin
            r_cnt <= r_cnt + 1;
        end
    end 
    else begin 
        r_pls_10 <= 1'b0;
    end  
end

assign o_pls_10 = r_pls_10;

endmodule
