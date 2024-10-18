module dff(clk, din, rstn, qout);
    input clk, din, rstn;
    output qout;
    reg qout;
    
always @ (posedge clk, negedge rstn) begin
    if(!rstn) 
        qout <= 1'b0;
    else
        qout <= din; 
end
    
endmodule
