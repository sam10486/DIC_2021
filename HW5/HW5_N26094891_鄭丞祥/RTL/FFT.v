
module FFT (
    input [31:0] x0_real, x1_real, x2_real, x3_real, x4_real, x5_real, x6_real, x7_real,
                 x8_real, x9_real, x10_real, x11_real, x12_real, x13_real, x14_real, x15_real,

    input [31:0] x0_imag, x1_imag, x2_imag, x3_imag, x4_imag, x5_imag, x6_imag, x7_imag,
                 x8_imag, x9_imag, x10_imag, x11_imag, x12_imag, x13_imag, x14_imag, x15_imag,
    
    input clk,
    output reg [31:0] y0, y1, y2, y3, y4, y5, y6, y7,
                  y8, y9, y10, y11, y12, y13, y14, y15

);
wire signed [31:0] coe_real_in [0:7];
wire signed [31:0] coe_imag_in [0:7];

wire [31:0] stage1_x0_real, stage2_x0_real, stage3_x0_real, stage4_x0_real,
            stage1_x1_real, stage2_x1_real, stage3_x1_real, stage4_x1_real,
            stage1_x2_real, stage2_x2_real, stage3_x2_real, stage4_x2_real,
            stage1_x3_real, stage2_x3_real, stage3_x3_real, stage4_x3_real,
            stage1_x4_real, stage2_x4_real, stage3_x4_real, stage4_x4_real,
            stage1_x5_real, stage2_x5_real, stage3_x5_real, stage4_x5_real,
            stage1_x6_real, stage2_x6_real, stage3_x6_real, stage4_x6_real,
            stage1_x7_real, stage2_x7_real, stage3_x7_real, stage4_x7_real,
            stage1_x8_real, stage2_x8_real, stage3_x8_real, stage4_x8_real,
            stage1_x9_real, stage2_x9_real, stage3_x9_real, stage4_x9_real,
            stage1_x10_real, stage2_x10_real, stage3_x10_real, stage4_x10_real,
            stage1_x11_real, stage2_x11_real, stage3_x11_real, stage4_x11_real,
            stage1_x12_real, stage2_x12_real, stage3_x12_real, stage4_x12_real,
            stage1_x13_real, stage2_x13_real, stage3_x13_real, stage4_x13_real,
            stage1_x14_real, stage2_x14_real, stage3_x14_real, stage4_x14_real,
            stage1_x15_real, stage2_x15_real, stage3_x15_real, stage4_x15_real;

wire [31:0] stage1_x0_imag, stage2_x0_imag, stage3_x0_imag, stage4_x0_imag,
            stage1_x1_imag, stage2_x1_imag, stage3_x1_imag, stage4_x1_imag,
            stage1_x2_imag, stage2_x2_imag, stage3_x2_imag, stage4_x2_imag,
            stage1_x3_imag, stage2_x3_imag, stage3_x3_imag, stage4_x3_imag,
            stage1_x4_imag, stage2_x4_imag, stage3_x4_imag, stage4_x4_imag,
            stage1_x5_imag, stage2_x5_imag, stage3_x5_imag, stage4_x5_imag,
            stage1_x6_imag, stage2_x6_imag, stage3_x6_imag, stage4_x6_imag,
            stage1_x7_imag, stage2_x7_imag, stage3_x7_imag, stage4_x7_imag,
            stage1_x8_imag, stage2_x8_imag, stage3_x8_imag, stage4_x8_imag,
            stage1_x9_imag, stage2_x9_imag, stage3_x9_imag, stage4_x9_imag,
            stage1_x10_imag, stage2_x10_imag, stage3_x10_imag, stage4_x10_imag,
            stage1_x11_imag, stage2_x11_imag, stage3_x11_imag, stage4_x11_imag,
            stage1_x12_imag, stage2_x12_imag, stage3_x12_imag, stage4_x12_imag,
            stage1_x13_imag, stage2_x13_imag, stage3_x13_imag, stage4_x13_imag,
            stage1_x14_imag, stage2_x14_imag, stage3_x14_imag, stage4_x14_imag,
            stage1_x15_imag, stage2_x15_imag, stage3_x15_imag, stage4_x15_imag;



assign coe_real_in[0] = 32'h00010000;     
assign coe_real_in[1] = 32'h0000EC83; 
assign coe_real_in[2] = 32'h0000B504;      
assign coe_real_in[3] = 32'h000061F7;      
assign coe_real_in[4] = 32'h00000000;     
assign coe_real_in[5] = 32'hFFFF9E09;    
assign coe_real_in[6] = 32'hFFFF4AFC;
assign coe_real_in[7] = 32'hFFFF137D;

assign coe_imag_in[0] = 32'h00000000;
assign coe_imag_in[1] = 32'hFFFF9E09;
assign coe_imag_in[2] = 32'hFFFF4AFC;
assign coe_imag_in[3] = 32'hFFFF137D;
assign coe_imag_in[4] = 32'hFFFF0000;
assign coe_imag_in[5] = 32'hFFFF137D;
assign coe_imag_in[6] = 32'hFFFF4AFC;
assign coe_imag_in[7] = 32'hFFFF9E09; 

BF2_FFT B0(
    .real_a(x0_real),
    .imag_b(x0_imag),
    .real_c(x8_real),
    .imag_d(x8_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage1_x0_real),
    .fft_a_imag(stage1_x0_imag),
    .fft_b_real(stage1_x8_real),
    .fft_b_imag(stage1_x8_imag),
    .clk(clk)
);
BF2_FFT B1(
    .real_a(x1_real),
    .imag_b(x1_imag),
    .real_c(x9_real),
    .imag_d(x9_imag),
    .coe_real(coe_real_in[1]),
    .coe_imag(coe_imag_in[1]),
    .fft_a_real(stage1_x1_real),
    .fft_a_imag(stage1_x1_imag),
    .fft_b_real(stage1_x9_real),
    .fft_b_imag(stage1_x9_imag),
    .clk(clk)
);
BF2_FFT B2(
    .real_a(x2_real),
    .imag_b(x2_imag),
    .real_c(x10_real),
    .imag_d(x10_imag),
    .coe_real(coe_real_in[2]),
    .coe_imag(coe_imag_in[2]),
    .fft_a_real(stage1_x2_real),
    .fft_a_imag(stage1_x2_imag),
    .fft_b_real(stage1_x10_real),
    .fft_b_imag(stage1_x10_imag),
    .clk(clk)
);
BF2_FFT B3(
    .real_a(x3_real),
    .imag_b(x3_imag),
    .real_c(x11_real),
    .imag_d(x11_imag),
    .coe_real(coe_real_in[3]),
    .coe_imag(coe_imag_in[3]),
    .fft_a_real(stage1_x3_real),
    .fft_a_imag(stage1_x3_imag),
    .fft_b_real(stage1_x11_real),
    .fft_b_imag(stage1_x11_imag),
    .clk(clk)
);
BF2_FFT B4(
    .real_a(x4_real),
    .imag_b(x4_imag),
    .real_c(x12_real),
    .imag_d(x12_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage1_x4_real),
    .fft_a_imag(stage1_x4_imag),
    .fft_b_real(stage1_x12_real),
    .fft_b_imag(stage1_x12_imag),
    .clk(clk)
);
BF2_FFT B5(
    .real_a(x5_real),
    .imag_b(x5_imag),
    .real_c(x13_real),
    .imag_d(x13_imag),
    .coe_real(coe_real_in[5]),
    .coe_imag(coe_imag_in[5]),
    .fft_a_real(stage1_x5_real),
    .fft_a_imag(stage1_x5_imag),
    .fft_b_real(stage1_x13_real),
    .fft_b_imag(stage1_x13_imag),
    .clk(clk)
);
BF2_FFT B6(
    .real_a(x6_real),
    .imag_b(x6_imag),
    .real_c(x14_real),
    .imag_d(x14_imag),
    .coe_real(coe_real_in[6]),
    .coe_imag(coe_imag_in[6]),
    .fft_a_real(stage1_x6_real),
    .fft_a_imag(stage1_x6_imag),
    .fft_b_real(stage1_x14_real),
    .fft_b_imag(stage1_x14_imag),
    .clk(clk)
);
BF2_FFT B7(
    .real_a(x7_real),
    .imag_b(x7_imag),
    .real_c(x15_real),
    .imag_d(x15_imag),
    .coe_real(coe_real_in[7]),
    .coe_imag(coe_imag_in[7]),
    .fft_a_real(stage1_x7_real),
    .fft_a_imag(stage1_x7_imag),
    .fft_b_real(stage1_x15_real),
    .fft_b_imag(stage1_x15_imag),
    .clk(clk)
);
//------------stage 2-----------------//
BF2_FFT B8(
    .real_a(stage1_x0_real),
    .imag_b(stage1_x0_imag),
    .real_c(stage1_x4_real),
    .imag_d(stage1_x4_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage2_x0_real),
    .fft_a_imag(stage2_x0_imag),
    .fft_b_real(stage2_x4_real),
    .fft_b_imag(stage2_x4_imag),
    .clk(clk)
);

BF2_FFT B9(
    .real_a(stage1_x1_real),
    .imag_b(stage1_x1_imag),
    .real_c(stage1_x5_real),
    .imag_d(stage1_x5_imag),
    .coe_real(coe_real_in[2]),
    .coe_imag(coe_imag_in[2]),
    .fft_a_real(stage2_x1_real),
    .fft_a_imag(stage2_x1_imag),
    .fft_b_real(stage2_x5_real),
    .fft_b_imag(stage2_x5_imag),
    .clk(clk)
);

BF2_FFT B10(
    .real_a(stage1_x2_real),
    .imag_b(stage1_x2_imag),
    .real_c(stage1_x6_real),
    .imag_d(stage1_x6_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage2_x2_real),
    .fft_a_imag(stage2_x2_imag),
    .fft_b_real(stage2_x6_real),
    .fft_b_imag(stage2_x6_imag),
    .clk(clk)
);

BF2_FFT B11(
    .real_a(stage1_x3_real),
    .imag_b(stage1_x3_imag),
    .real_c(stage1_x7_real),
    .imag_d(stage1_x7_imag),
    .coe_real(coe_real_in[6]),
    .coe_imag(coe_imag_in[6]),
    .fft_a_real(stage2_x3_real),
    .fft_a_imag(stage2_x3_imag),
    .fft_b_real(stage2_x7_real),
    .fft_b_imag(stage2_x7_imag),
    .clk(clk)
);

BF2_FFT B12(
    .real_a(stage1_x8_real),
    .imag_b(stage1_x8_imag),
    .real_c(stage1_x12_real),
    .imag_d(stage1_x12_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage2_x8_real),
    .fft_a_imag(stage2_x8_imag),
    .fft_b_real(stage2_x12_real),
    .fft_b_imag(stage2_x12_imag),
    .clk(clk)
);

BF2_FFT B13(
    .real_a(stage1_x9_real),
    .imag_b(stage1_x9_imag),
    .real_c(stage1_x13_real),
    .imag_d(stage1_x13_imag),
    .coe_real(coe_real_in[2]),
    .coe_imag(coe_imag_in[2]),
    .fft_a_real(stage2_x9_real),
    .fft_a_imag(stage2_x9_imag),
    .fft_b_real(stage2_x13_real),
    .fft_b_imag(stage2_x13_imag),
    .clk(clk)
);

BF2_FFT B14(
    .real_a(stage1_x10_real),
    .imag_b(stage1_x10_imag),
    .real_c(stage1_x14_real),
    .imag_d(stage1_x14_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage2_x10_real),
    .fft_a_imag(stage2_x10_imag),
    .fft_b_real(stage2_x14_real),
    .fft_b_imag(stage2_x14_imag),
    .clk(clk)
);

BF2_FFT B15(
    .real_a(stage1_x11_real),
    .imag_b(stage1_x11_imag),
    .real_c(stage1_x15_real),
    .imag_d(stage1_x15_imag),
    .coe_real(coe_real_in[6]),
    .coe_imag(coe_imag_in[6]),
    .fft_a_real(stage2_x11_real),
    .fft_a_imag(stage2_x11_imag),
    .fft_b_real(stage2_x15_real),
    .fft_b_imag(stage2_x15_imag),
    .clk(clk)
);

//-------------stage 3-------------//

BF2_FFT B16(
    .real_a(stage2_x0_real),
    .imag_b(stage2_x0_imag),
    .real_c(stage2_x2_real),
    .imag_d(stage2_x2_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage3_x0_real),
    .fft_a_imag(stage3_x0_imag),
    .fft_b_real(stage3_x2_real),
    .fft_b_imag(stage3_x2_imag),
    .clk(clk)
);

BF2_FFT B17(
    .real_a(stage2_x1_real),
    .imag_b(stage2_x1_imag),
    .real_c(stage2_x3_real),
    .imag_d(stage2_x3_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage3_x1_real),
    .fft_a_imag(stage3_x1_imag),
    .fft_b_real(stage3_x3_real),
    .fft_b_imag(stage3_x3_imag),
    .clk(clk)
);

BF2_FFT B18(
    .real_a(stage2_x4_real),
    .imag_b(stage2_x4_imag),
    .real_c(stage2_x6_real),
    .imag_d(stage2_x6_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage3_x4_real),
    .fft_a_imag(stage3_x4_imag),
    .fft_b_real(stage3_x6_real),
    .fft_b_imag(stage3_x6_imag),
    .clk(clk)
);

BF2_FFT B19(
    .real_a(stage2_x5_real),
    .imag_b(stage2_x5_imag),
    .real_c(stage2_x7_real),
    .imag_d(stage2_x7_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage3_x5_real),
    .fft_a_imag(stage3_x5_imag),
    .fft_b_real(stage3_x7_real),
    .fft_b_imag(stage3_x7_imag),
    .clk(clk)
);

BF2_FFT B20(
    .real_a(stage2_x8_real),
    .imag_b(stage2_x8_imag),
    .real_c(stage2_x10_real),
    .imag_d(stage2_x10_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage3_x8_real),
    .fft_a_imag(stage3_x8_imag),
    .fft_b_real(stage3_x10_real),
    .fft_b_imag(stage3_x10_imag),
    .clk(clk)
);

BF2_FFT B21(
    .real_a(stage2_x9_real),
    .imag_b(stage2_x9_imag),
    .real_c(stage2_x11_real),
    .imag_d(stage2_x11_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage3_x9_real),
    .fft_a_imag(stage3_x9_imag),
    .fft_b_real(stage3_x11_real),
    .fft_b_imag(stage3_x11_imag),
    .clk(clk)
);

BF2_FFT B22(
    .real_a(stage2_x12_real),
    .imag_b(stage2_x12_imag),
    .real_c(stage2_x14_real),
    .imag_d(stage2_x14_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage3_x12_real),
    .fft_a_imag(stage3_x12_imag),
    .fft_b_real(stage3_x14_real),
    .fft_b_imag(stage3_x14_imag),
    .clk(clk)
);

BF2_FFT B23(
    .real_a(stage2_x13_real),
    .imag_b(stage2_x13_imag),
    .real_c(stage2_x15_real),
    .imag_d(stage2_x15_imag),
    .coe_real(coe_real_in[4]),
    .coe_imag(coe_imag_in[4]),
    .fft_a_real(stage3_x13_real),
    .fft_a_imag(stage3_x13_imag),
    .fft_b_real(stage3_x15_real),
    .fft_b_imag(stage3_x15_imag),
    .clk(clk)
);
//---------------stage 4------------------
BF2_FFT B24(
    .real_a(stage3_x0_real),
    .imag_b(stage3_x0_imag),
    .real_c(stage3_x1_real),
    .imag_d(stage3_x1_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x0_real),
    .fft_a_imag(stage4_x0_imag),
    .fft_b_real(stage4_x1_real),
    .fft_b_imag(stage4_x1_imag),
    .clk(clk)
);

BF2_FFT B25(
    .real_a(stage3_x2_real),
    .imag_b(stage3_x2_imag),
    .real_c(stage3_x3_real),
    .imag_d(stage3_x3_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x2_real),
    .fft_a_imag(stage4_x2_imag),
    .fft_b_real(stage4_x3_real),
    .fft_b_imag(stage4_x3_imag),
    .clk(clk)
);

BF2_FFT B26(
    .real_a(stage3_x4_real),
    .imag_b(stage3_x4_imag),
    .real_c(stage3_x5_real),
    .imag_d(stage3_x5_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x4_real),
    .fft_a_imag(stage4_x4_imag),
    .fft_b_real(stage4_x5_real),
    .fft_b_imag(stage4_x5_imag),
    .clk(clk)
);

BF2_FFT B27(
    .real_a(stage3_x6_real),
    .imag_b(stage3_x6_imag),
    .real_c(stage3_x7_real),
    .imag_d(stage3_x7_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x6_real),
    .fft_a_imag(stage4_x6_imag),
    .fft_b_real(stage4_x7_real),
    .fft_b_imag(stage4_x7_imag),
    .clk(clk)
);
BF2_FFT B28(
    .real_a(stage3_x8_real),
    .imag_b(stage3_x8_imag),
    .real_c(stage3_x9_real),
    .imag_d(stage3_x9_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x8_real),
    .fft_a_imag(stage4_x8_imag),
    .fft_b_real(stage4_x9_real),
    .fft_b_imag(stage4_x9_imag),
    .clk(clk)
);

BF2_FFT B29(
    .real_a(stage3_x10_real),
    .imag_b(stage3_x10_imag),
    .real_c(stage3_x11_real),
    .imag_d(stage3_x11_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x10_real),
    .fft_a_imag(stage4_x10_imag),
    .fft_b_real(stage4_x11_real),
    .fft_b_imag(stage4_x11_imag),
    .clk(clk)
);
BF2_FFT B30(
    .real_a(stage3_x12_real),
    .imag_b(stage3_x12_imag),
    .real_c(stage3_x13_real),
    .imag_d(stage3_x13_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x12_real),
    .fft_a_imag(stage4_x12_imag),
    .fft_b_real(stage4_x13_real),
    .fft_b_imag(stage4_x13_imag),
    .clk(clk)
);
BF2_FFT B31(
    .real_a(stage3_x14_real),
    .imag_b(stage3_x14_imag),
    .real_c(stage3_x15_real),
    .imag_d(stage3_x15_imag),
    .coe_real(coe_real_in[0]),
    .coe_imag(coe_imag_in[0]),
    .fft_a_real(stage4_x14_real),
    .fft_a_imag(stage4_x14_imag),
    .fft_b_real(stage4_x15_real),
    .fft_b_imag(stage4_x15_imag),
    .clk(clk)
);

always @(*) begin
    y0 = {stage4_x0_real[31:16], stage4_x0_imag[31:16]};
    y8 = {stage4_x1_real[31:16], stage4_x1_imag[31:16]};

    y4 = {stage4_x2_real[31:16], stage4_x2_imag[31:16]};
    y12 = {stage4_x3_real[31:16], stage4_x3_imag[31:16]};

    y2 = {stage4_x4_real[31:16], stage4_x4_imag[31:16]};
    y10 = {stage4_x5_real[31:16], stage4_x5_imag[31:16]};

    y6 = {stage4_x6_real[31:16], stage4_x6_imag[31:16]};
    y14 = {stage4_x7_real[31:16], stage4_x7_imag[31:16]};

    y1 = {stage4_x8_real[31:16], stage4_x8_imag[31:16]};
    y9 = {stage4_x9_real[31:16], stage4_x9_imag[31:16]};

    y5 = {stage4_x10_real[31:16], stage4_x10_imag[31:16]};
    y13 = {stage4_x11_real[31:16], stage4_x11_imag[31:16]};

    y3 = {stage4_x12_real[31:16], stage4_x12_imag[31:16]};
    y11 = {stage4_x13_real[31:16], stage4_x13_imag[31:16]};

    y7 = {stage4_x14_real[31:16], stage4_x14_imag[31:16]};
    y15 = {stage4_x15_real[31:16], stage4_x15_imag[31:16]};

end
endmodule