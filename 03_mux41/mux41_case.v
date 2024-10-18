module mux41_case(i_d_0, i_d_1, i_d_2, i_d_3, i_sel, o_y);
    input [7:0] i_d_0, i_d_1, i_d_2, i_d_3; 
    input [1:0] i_sel;
    output [7:0] o_y;
    reg [7:0] o_y;    
 
    
always @ (i_d_0 or i_d_1 or i_d_2 or i_d_3 or i_sel) begin
    case(i_sel) 
        2'b00: o_y = i_d_0;
        2'b01: o_y = i_d_0;
        2'b10: o_y = i_d_0;
        default: o_y = i_d_0;
    endcase
end
            
endmodule