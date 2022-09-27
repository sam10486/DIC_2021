module RCA(s, c_out, x, y, c_in);
    input [3:0] x, y;
    input c_in;
    output [3:0] s;
    output c_out;
    wire c1, c2, c3;


    FA FA_0(s[0], c1, x[0], y[0], c_in);
    FA FA_1(s[1], c2, x[1], y[1], c1);
    FA FA_2(s[2], c3, x[2], y[2], c2);
    FA FA_3(s[3], c_out, x[3], y[3], c3);
     
endmodule