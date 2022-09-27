module HA (s, c, x, y);

    input x, y;
    output s, c;

    xor u1(s, x, y);
    and u2(c, x, y);
    
endmodule