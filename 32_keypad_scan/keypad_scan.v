module keypad_scan(
    input clk,
    input rstn,
    input  [4:0] key_row,
    output [3:0] key_col,
    output [19:0] key_data
    );

reg [19:0] key_data;
reg [4:0]  state;
wire       key_stop;

// FSM 상태를 parameter 로 정의
parameter no_scan = 4'b1111;
parameter column1 = 4'b0111;
parameter column2 = 4'b1011;
parameter column3 = 4'b1101;
parameter column4 = 4'b1110;
assign key_stop = !(&key_row) ;
assign key_col = state ;

//FSM 구현 
always @(posedge clk or negedge rstn) begin
    if(!rstn) state <= no_scan;
    else begin 
        if(!key_stop) begin
            case(state)
                no_scan : state <= column1;
                column1 : state <= column2;
                column2 : state <= column3;
                column3 : state <= column4;
                column4 : state <= column1;
                default : state <= no_scan;
            endcase
         end
     end
 end 
 
 //key_data 출력 
 always @(posedge clk or negedge rstn) begin
    if(!rstn) 
        key_data <= 20'b11111_11111_11111_11111;
    else begin
        case(state) 
            column1 : case(key_row)
                5'b01111  : key_data <= 20'b01111_11111_11111_11111  ; 
                5'b10111  : key_data <= 20'b10111_11111_11111_11111  ; 
                5'b11011  : key_data <= 20'b11011_11111_11111_11111  ; 
                5'b11101  : key_data <= 20'b11101_11111_11111_11111  ; 
                5'b11110  : key_data <= 20'b11110_11111_11111_11111  ; 
                default   : key_data <= 12'b11111_11111_11111_11111  ; 
             endcase 
             column2 : case(key_row)
                5'b01111  : key_data <= 20'b11111_01111_11111_11111  ; 
                5'b10111  : key_data <= 20'b11111_10111_11111_11111  ; 
                5'b11011  : key_data <= 20'b11111_11011_11111_11111  ; 
                5'b11101  : key_data <= 20'b11111_11101_11111_11111  ; 
                5'b11110  : key_data <= 20'b11111_11110_11111_11111  ; 
                default   : key_data <= 12'b11111_11111_11111_11111  ;               
             endcase 
             column3 : case(key_row)
                5'b01111  : key_data <= 20'b11111_11111_01111_11111  ; 
                5'b10111  : key_data <= 20'b11111_11111_10111_11111  ; 
                5'b11011  : key_data <= 20'b11111_11111_11011_11111  ; 
                5'b11101  : key_data <= 20'b11111_11111_11101_11111  ; 
                5'b11110  : key_data <= 20'b11111_11111_11110_11111  ; 
                default   : key_data <= 12'b11111_11111_11111_11111  ;  
             endcase  
             column4 : case(key_row)
                5'b01111  : key_data <= 20'b11111_11111_11111_01111  ; 
                5'b10111  : key_data <= 20'b11111_11111_11111_10111  ; 
                5'b11011  : key_data <= 20'b11111_11111_11111_11011  ; 
                5'b11101  : key_data <= 20'b11111_11111_11111_11101  ; 
                5'b11110  : key_data <= 20'b11111_11111_11111_11110  ; 
                default   : key_data <= 12'b11111_11111_11111_11111  ;  
             endcase               
         endcase
    end
end

endmodule