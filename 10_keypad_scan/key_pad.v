module keypad_scan (clk, rst, key_col, key_row, key_data);

  parameter no_scan = 3'b000;
  parameter column1 = 3'b001;
  parameter column2 = 3'b010;
  parameter column3 = 3'b100;

  input	        clk, rst;
  input  [3:0]  key_row;
  output [2:0]  key_col;
  output [11:0] key_data;
  reg	   [0:11] key_data;
  reg    [2:0]  state;
  wire		      key_stop;
 
  assign key_stop = key_row[0] | key_row[1] | key_row[2] | key_row[3];  
  assign key_col = state;

// 열 스캔신호 key_col을 생성하기 위한 FSM
always @(posedge clk or posedge rst) begin
   if (rst) state <= no_scan;
   else begin
	   if (!key_stop) begin
		   case (state)
			 no_scan : state <= column1;
			 column1 : state <= column2;
			 column2 : state <= column3;
			 column3 : state <= column1;
			 default : state <= no_scan;
		   endcase
	   end
   end
end

// FSM의 각 상태에 대해 key_row 값을 검색하여 어떤 키가 눌려졌는지 판단
always @(posedge clk)
begin
   case (state)
	column1 : case (key_row)
	             4'b0001 : key_data <= 12'b0000_0000_0001; //key_1
	             4'b0010 : key_data <= 12'b0000_0000_1000; //key_4
	             4'b0100 : key_data <= 12'b0000_0100_0000; //key_7
	             4'b1000 : key_data <= 12'b0010_0000_0000; //key_*
	              default : key_data <= 12'b0000_0000_0000; 
                 endcase
	column2 : case (key_row)
		     4'b0001 : key_data <= 12'b0000_0000_0010; //key_2
		     4'b0010 : key_data <= 12'b0000_0001_0000; //key_5
		     4'b0100 : key_data <= 12'b0000_1000_0000; //key_8
		     4'b1000 : key_data <= 12'b0100_0000_0000; //key_0
		     default  : key_data <= 12'b0000_0000_0000; 
		   endcase
	column3 : case (key_row)
	             4'b0001 : key_data <= 12'b0000_0000_0100; //key_3
		     4'b0010 : key_data <= 12'b0000_0010_0000; //key_6
		     4'b0100 : key_data <= 12'b0001_0000_0000; //key_9
		     4'b1000 : key_data <= 12'b1000_0000_0000; //key_#
		      default : key_data <= 12'b0000_0000_0000; 
		   endcase
	default :  key_data <= 12'b0000_0000_0000; 
   endcase
end
endmodule