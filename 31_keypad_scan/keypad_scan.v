module keypad_scan(
    input clk,
    input rstn,
    input  [3:0] key_row,
    output [2:0] key_col,
    output [11:0] key_data
    );

reg [11:0] key_data;
reg [2:0]  state;
wire       key_stop;

// FSM 상태를 parameter 로 정의
parameter no_scan = 3'b111;
parameter column1 = 3'b011;
parameter column2 = 3'b101;
parameter column3 = 3'b110;

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
                column3 : state <= column1;
                default : state <= no_scan;
            endcase
         end
     end
 end 
 
 //key_data 출력 
 always @(posedge clk or negedge rstn) begin
    if(!rstn) 
        key_data <= 12'b111_111_111_111;
    else begin
        case(state) 
            column1 : case(key_row)
                4'b0111   : key_data <= 12'b0111_1111_1111  ; //1
                4'b1011   : key_data <= 12'b1011_1111_1111  ; //4
                4'b1101   : key_data <= 12'b1101_1111_1111  ; //7
                4'b1110   : key_data <= 12'b1110_1111_1111  ; //*
                default   : key_data <= 12'b1111_1111_1111  ; 
             endcase 
             column2 : case(key_row)
                4'b0111   : key_data <= 12'b1111_0111_1111  ; //2
                4'b1011   : key_data <= 12'b1111_1011_1111  ; //5
                4'b1101   : key_data <= 12'b1111_1101_1111  ; //8
                4'b1110   : key_data <= 12'b1111_1110_1111  ; //0
                default   : key_data <= 12'b1111_1111_1111  ; 
             endcase 
             column3 : case(key_row)
                4'b0111   : key_data <= 12'b1111_1111_0111  ; //3
                4'b1011   : key_data <= 12'b1111_1111_1011  ; //6
                4'b1101   : key_data <= 12'b1111_1111_1101  ; //9
                4'b1110   : key_data <= 12'b1111_1111_1110  ; //#
                default   : key_data <= 12'b1111_1111_1111  ; 
             endcase              
         endcase
    end
end

endmodule