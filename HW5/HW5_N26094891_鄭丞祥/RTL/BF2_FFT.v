module BF2_FFT (
    input signed [31:0] real_a,
    input signed [31:0] imag_b,
    input signed [31:0] real_c,
    input signed [31:0] imag_d,
    input signed [31:0] coe_real,
    input signed [31:0] coe_imag,
    input clk,

    output reg signed [31:0] fft_a_real,
    output reg signed [31:0] fft_a_imag,
    output reg signed [31:0] fft_b_real,
    output reg signed [31:0] fft_b_imag
);

reg signed [31:0] fft_a_real_tmp, fft_a_real_buf;
reg signed [31:0] fft_a_imag_tmp, fft_a_imag_buf;
reg signed [63:0] fft_b_real_tmp, fft_b_real_buf;
reg signed [63:0] fft_b_imag_tmp, fft_b_imag_buf;
reg signed [63:0] fft_b_imag_tmp2;

always @(posedge clk) begin
    fft_a_real_tmp = real_a + real_c;
    fft_a_imag_tmp = imag_b + imag_d;
    fft_b_real_tmp = real_a - real_c;
    fft_b_imag_tmp = imag_d - imag_b;
    fft_b_imag_tmp2 = imag_b - imag_d;

    fft_a_real_buf = fft_a_real_tmp;
    fft_a_imag_buf = fft_a_imag_tmp;
    fft_b_real_buf = (fft_b_real_tmp * coe_real) + (fft_b_imag_tmp * coe_imag);
    fft_b_imag_buf = (fft_b_real_tmp * coe_imag) + (fft_b_imag_tmp2 * coe_real);

    fft_a_real = fft_a_real_buf;
    fft_a_imag = fft_a_imag_buf;
    fft_b_real = fft_b_real_buf[47:16];
    fft_b_imag = fft_b_imag_buf[47:16];
end
    
endmodule