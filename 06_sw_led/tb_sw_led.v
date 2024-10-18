module tb_sw_led; 

reg key_0;
reg key_1;
wire led0, led1, led2, led3;

sw_led U_SW_LED(
    .i_key0     (key_0),
    .i_key1     (key_1),
    .o_led_0    (led0),
    .o_led_1    (led1),
    .o_led_and  (led2),
    .o_led_or   (led3)
);

initial begin
    #0;     key_0 = 0; key_1 = 0;
    #100;   key_0 = 0; key_1 = 1;
    #100;   key_0 = 1; key_1 = 0;
    #100;   key_0 = 1; key_1 = 1;
    #1000;  $finish;
end

endmodule
