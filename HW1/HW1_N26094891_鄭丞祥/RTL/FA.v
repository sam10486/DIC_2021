
module FA(s, c_out, x, y, c_in);
    input x, y, c_in;
    output s, c_out;
    wire s1, c1, c2 ;

    HA HA_0(s1, c1, x, y);
    HA HA_1(s, c2, c_in, s1);
    or u1(c_out, c1, c2);

endmodule
