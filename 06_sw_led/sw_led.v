module sw_led(
    input i_key0,
    input i_key1,
    output o_led_0,
    output o_led_1,
    output o_led_and,
    output o_led_or
);

assign o_led_0 = ~i_key0;
assign o_led_1 = ~i_key1;
assign o_led_and =  (~i_key0) & (~i_key1);
assign o_led_or =  (~i_key0) | (~i_key1);

endmodule
