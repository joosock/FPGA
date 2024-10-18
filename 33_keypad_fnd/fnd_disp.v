function [7:0] fnd_disp;
input [19:0] key_data;
begin
    case(key_data)
        20'b01111_11111_11111_11111 :   fnd_disp = 8'b1111_0001; // /
        20'b10111_11111_11111_11111 :   fnd_disp = 8'b1111_0001; // ESC
        20'b11011_11111_11111_11111 :   fnd_disp = 8'b1011_1111; // 0
        20'b11101_11111_11111_11111 :   fnd_disp = 8'b1111_0001; // ENT
        20'b11110_11111_11111_11111 :   fnd_disp = 8'b1111_0001; // F4
        
        20'b11111_01111_11111_11111 :   fnd_disp = 8'b1111_0001; // x
        20'b11111_10111_11111_11111 :   fnd_disp = 8'b1000_0110; // 1
        20'b11111_11011_11111_11111 :   fnd_disp = 8'b1101_1011; // 2
        20'b11111_11101_11111_11111 :   fnd_disp = 8'b1100_1111; // 3
        20'b11111_11110_11111_11111 :   fnd_disp = 8'b1111_0001; // F3
        
        20'b11111_11111_01111_11111 :   fnd_disp = 8'b1111_0001; // -
        20'b11111_11111_10111_11111 :   fnd_disp = 8'b1110_0110; // 4
        20'b11111_11111_11011_11111 :   fnd_disp = 8'b1110_1101; // 5
        20'b11111_11111_11101_11111 :   fnd_disp = 8'b1111_1100; // 6
        20'b11111_11111_11110_11111 :   fnd_disp = 8'b1111_0001; // F2
        
        20'b11111_11111_11111_01111 :   fnd_disp = 8'b1111_0001; // +
        20'b11111_11111_11111_10111 :   fnd_disp = 8'b1000_0111; // 7
        20'b11111_11111_11111_11011 :   fnd_disp = 8'b1111_1111; // 8 
        20'b11111_11111_11111_11101 :   fnd_disp = 8'b1110_0111; // 9
        20'b11111_11111_11111_11110 :   fnd_disp = 8'b1111_0001; // F1
        default                     :   fnd_disp = 8'b1111_0001;
    endcase
end
endfunction
