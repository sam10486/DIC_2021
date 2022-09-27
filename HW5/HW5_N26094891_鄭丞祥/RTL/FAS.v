
module  FAS (data_valid, data, clk, rst, fir_d, fir_valid, fft_valid, done, freq,
 fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8,
 fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0);
input clk, rst;
input data_valid;
input [15:0] data; 

output reg fir_valid, fft_valid;
output reg [15:0] fir_d;
output signed [31:0] fft_d1, fft_d2, fft_d3, fft_d4, fft_d5, fft_d6, fft_d7, fft_d8;
output signed [31:0] fft_d9, fft_d10, fft_d11, fft_d12, fft_d13, fft_d14, fft_d15, fft_d0;
output reg done;
output reg[3:0] freq;


`include "./dat/FIR_coefficient.dat"


reg signed [15:0] x [0:31];
reg signed [15:0] add_x [0:15];
reg signed [35:0] sum1, sum2, sum3, sum4;
reg signed [35:0] sum_out;
reg signed [35:0] mul_tmp [0:15];
reg [5:0] cnt_shift_in;
reg signed [15:0] fft_in [0:1023];
reg [9:0] cnt_fft_shift;
reg flag_fft_shift;
//---------------------------------FIR input-------------------------------------------//
always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_shift_in <= 0;
    end else begin:local0
        integer i;
        x[0] <= data;
        for (i = 31;i > 0;i = i-1) begin
            x[i] <= x[i-1];
        end
        if (cnt_shift_in != 6'd34) begin
            cnt_shift_in <= cnt_shift_in + 6'd1;
        end else begin
            cnt_shift_in <= cnt_shift_in;
        end
    end
end

//the symmetry of FIR filter coefficient, 16 mul need
always @(*) begin: local1
        integer i;
        for (i = 0;i < 16 ; i=i+1) begin
            add_x[i] <= x[i] + x[5'd31-i]; 
        end
end

always @(*) begin
    mul_tmp[0] = FIR_C00 * add_x[0];   mul_tmp[1] = FIR_C01 * add_x[1];
    mul_tmp[2] = FIR_C02 * add_x[2];   mul_tmp[3] = FIR_C03 * add_x[3];
    mul_tmp[4] = FIR_C04 * add_x[4];   mul_tmp[5] = FIR_C05 * add_x[5];
    mul_tmp[6] = FIR_C06 * add_x[6];   mul_tmp[7] = FIR_C07 * add_x[7];
    mul_tmp[8] = FIR_C08 * add_x[8];   mul_tmp[9] = FIR_C09 * add_x[9];
    mul_tmp[10] = FIR_C10 * add_x[10]; mul_tmp[11] = FIR_C11 * add_x[11];
    mul_tmp[12] = FIR_C12 * add_x[12]; mul_tmp[13] = FIR_C13 * add_x[13];
    mul_tmp[14] = FIR_C14 * add_x[14]; mul_tmp[15] = FIR_C15 * add_x[15];
end
    
always @(posedge clk) begin
    if (cnt_shift_in[5] == 1) begin
        sum1 <= (mul_tmp[0] + mul_tmp[1]) + (mul_tmp[2] + mul_tmp[3]);
        sum2 <= (mul_tmp[4] + mul_tmp[5]) + (mul_tmp[6] + mul_tmp[7]);
        sum3 <= (mul_tmp[8] + mul_tmp[9]) + (mul_tmp[10] + mul_tmp[11]);
        sum4 <= (mul_tmp[12] + mul_tmp[13]) + (mul_tmp[14] + mul_tmp[15]);
        sum_out <= (sum1+sum2) + (sum3+sum4);
    end
end

always @(*) begin
   if (cnt_shift_in == 6'd34) begin
       fir_valid = 1;
       fir_d = sum_out[31:16];
   end else begin
       fir_valid = 0;
       fir_d = 16'd0;
   end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_fft_shift <= 10'd0;
        flag_fft_shift <= 0;
    end else begin
        if (cnt_shift_in == 6'd34) begin
            if (sum_out[31]) begin
                fft_in[cnt_fft_shift] <= sum_out[31:16] + 16'd1;
            end else begin
                fft_in[cnt_fft_shift] <= sum_out[31:16];
            end
            if (cnt_fft_shift != 10'd1023) begin
                cnt_fft_shift <= cnt_fft_shift + 10'd1;
            end else begin
                cnt_fft_shift <= cnt_fft_shift;
                flag_fft_shift <= 1;
            end
        end
    end
end
//-------------------------------------------------------------------------------------//

reg [6:0] cnt_fft;
reg [31:0] x0_real, x1_real, x2_real, x3_real, x4_real, x5_real, x6_real, x7_real,
           x8_real, x9_real, x10_real, x11_real, x12_real, x13_real, x14_real, x15_real;
reg flag_analysis [0:1];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_fft <= 7'd0;
        fft_valid <= 0;
        flag_analysis[0] <= 0;
        flag_analysis[1] = 0;
    end else begin
        if (flag_fft_shift) begin
            x0_real <= {fft_in[cnt_fft + cnt_fft*15], 16'd0}; 
            x1_real <= {fft_in[cnt_fft+7'd1 + cnt_fft*15], 16'd0};
            x2_real <= {fft_in[cnt_fft+7'd2 + cnt_fft*15], 16'd0}; 
            x3_real <= {fft_in[cnt_fft+7'd3 + cnt_fft*15], 16'd0}; 
            x4_real <= {fft_in[cnt_fft+7'd4 + cnt_fft*15], 16'd0}; 
            x5_real <= {fft_in[cnt_fft+7'd5 + cnt_fft*15], 16'd0}; 
            x6_real <= {fft_in[cnt_fft+7'd6 + cnt_fft*15], 16'd0}; 
            x7_real <= {fft_in[cnt_fft+7'd7 + cnt_fft*15], 16'd0}; 
            x8_real <= {fft_in[cnt_fft+7'd8 + cnt_fft*15], 16'd0}; 
            x9_real <= {fft_in[cnt_fft+7'd9 + cnt_fft*15], 16'd0}; 
            x10_real <= {fft_in[cnt_fft+7'd10 + cnt_fft*15], 16'd0}; 
            x11_real <= {fft_in[cnt_fft+7'd11 + cnt_fft*15], 16'd0}; 
            x12_real <= {fft_in[cnt_fft+7'd12 + cnt_fft*15], 16'd0}; 
            x13_real <= {fft_in[cnt_fft+7'd13 + cnt_fft*15], 16'd0}; 
            x14_real <= {fft_in[cnt_fft+7'd14 + cnt_fft*15], 16'd0}; 
            x15_real <= {fft_in[cnt_fft+7'd15 + cnt_fft*15], 16'd0}; 
            if (cnt_fft == 7'd68) begin
                fft_valid <= 0;
            end else begin
                cnt_fft <= cnt_fft + 7'd1;
            end
            if (cnt_fft == 7'd4) begin
                fft_valid <= 1;
            end
            if (cnt_fft == 7'd5) begin
                flag_analysis[0] <= 1;
            end
            if (cnt_fft == 7'd6) begin
                flag_analysis[1] <= 1;
            end
        end
    end
end

FFT F2(
    .clk(clk),
    .x0_real(x0_real), .x1_real(x1_real), .x2_real(x2_real), .x3_real(x3_real), .x4_real(x4_real), .x5_real(x5_real), .x6_real(x6_real), .x7_real(x7_real),
    .x8_real(x8_real), .x9_real(x9_real), .x10_real(x10_real), .x11_real(x11_real), .x12_real(x12_real), .x13_real(x13_real), .x14_real(x14_real), .x15_real(x15_real),

    .x0_imag(32'd0), .x1_imag(32'd0), .x2_imag(32'd0), .x3_imag(32'd0), .x4_imag(32'd0), .x5_imag(32'd0), .x6_imag(32'd0), .x7_imag(32'd0),
    .x8_imag(32'd0), .x9_imag(32'd0), .x10_imag(32'd0), .x11_imag(32'd0), .x12_imag(32'd0), .x13_imag(32'd0), .x14_imag(32'd0), .x15_imag(32'd0),

    .y0(fft_d0), .y8(fft_d8), .y4(fft_d4), .y12(fft_d12), .y2(fft_d2), .y10(fft_d10), .y6(fft_d6), .y14(fft_d14), .y1(fft_d1), .y9(fft_d9),
    .y5(fft_d5), .y13(fft_d13), .y3(fft_d3), .y11(fft_d11), .y7(fft_d7), .y15(fft_d15)
);
//----------------------------------------------------------------------------------------------------------------------//

reg signed [31:0] fft_d0_tmp1, fft_d0_tmp2,
            fft_d1_tmp1, fft_d1_tmp2,
            fft_d2_tmp1, fft_d2_tmp2,
            fft_d3_tmp1, fft_d3_tmp2,
            fft_d4_tmp1, fft_d4_tmp2,
            fft_d5_tmp1, fft_d5_tmp2,
            fft_d6_tmp1, fft_d6_tmp2,
            fft_d7_tmp1, fft_d7_tmp2,
            fft_d8_tmp1, fft_d8_tmp2,
            fft_d9_tmp1, fft_d9_tmp2,
            fft_d10_tmp1, fft_d10_tmp2,
            fft_d11_tmp1, fft_d11_tmp2,
            fft_d12_tmp1, fft_d12_tmp2,
            fft_d13_tmp1, fft_d13_tmp2,
            fft_d14_tmp1, fft_d14_tmp2,
            fft_d15_tmp1, fft_d15_tmp2;

reg [31:0] analysis_0, analysis_1, analysis_2, analysis_3, analysis_4, analysis_5, analysis_6, analysis_7,
           analysis_8, analysis_9, analysis_10, analysis_11, analysis_12, analysis_13, analysis_14, analysis_15; 

reg [31:0] max_tmp0, max_tmp1, max_tmp2, max_tmp3, max_tmp4;
reg [5:0] cnt_analysis;  

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_analysis <= 6'd0;
        analysis_0 <= 32'd0; analysis_1 <= 32'd0; analysis_2 <= 32'd0;
        analysis_3 <= 32'd0; analysis_4 <= 32'd0; analysis_5 <= 32'd0;
        analysis_6 <= 32'd0; analysis_7 <= 32'd0; analysis_8 <= 32'd0;
        analysis_9 <= 32'd0; analysis_10 <= 32'd0; analysis_11 <= 32'd0;
        analysis_12 <= 32'd0; analysis_13 <= 32'd0; analysis_14 <= 32'd0; analysis_15 <= 32'd0;
    end else begin
        fft_d0_tmp1 <= $signed(fft_d0[31:16]) * $signed(fft_d0[31:16]);     fft_d0_tmp2 <= $signed(fft_d0[15:0]) * $signed(fft_d0[15:0]);
        fft_d1_tmp1 <= $signed(fft_d1[31:16]) * $signed(fft_d1[31:16]);     fft_d1_tmp2 <= $signed(fft_d1[15:0]) * $signed(fft_d1[15:0]);
        fft_d2_tmp1 <= $signed(fft_d2[31:16]) * $signed(fft_d2[31:16]);     fft_d2_tmp2 <= $signed(fft_d2[15:0]) * $signed(fft_d2[15:0]);
        fft_d3_tmp1 <= $signed(fft_d3[31:16]) * $signed(fft_d3[31:16]);     fft_d3_tmp2 <= $signed(fft_d3[15:0]) * $signed(fft_d3[15:0]);
        fft_d4_tmp1 <= $signed(fft_d4[31:16]) * $signed(fft_d4[31:16]);     fft_d4_tmp2 <= $signed(fft_d4[15:0]) * $signed(fft_d4[15:0]);
        fft_d5_tmp1 <= $signed(fft_d5[31:16]) * $signed(fft_d5[31:16]);     fft_d5_tmp2 <= $signed(fft_d5[15:0]) * $signed(fft_d5[15:0]);
        fft_d6_tmp1 <= $signed(fft_d6[31:16]) * $signed(fft_d6[31:16]);     fft_d6_tmp2 <= $signed(fft_d6[15:0]) * $signed(fft_d6[15:0]);
        fft_d7_tmp1 <= $signed(fft_d7[31:16]) * $signed(fft_d7[31:16]);     fft_d7_tmp2 <= $signed(fft_d7[15:0]) * $signed(fft_d7[15:0]);
        fft_d8_tmp1 <= $signed(fft_d8[31:16]) * $signed(fft_d8[31:16]);     fft_d8_tmp2 <= $signed(fft_d8[15:0]) * $signed(fft_d8[15:0]);
        fft_d9_tmp1 <= $signed(fft_d9[31:16]) * $signed(fft_d9[31:16]);     fft_d9_tmp2 <= $signed(fft_d9[15:0]) * $signed(fft_d9[15:0]);
        fft_d10_tmp1 <= $signed(fft_d10[31:16]) * $signed(fft_d10[31:16]);  fft_d10_tmp2 <= $signed(fft_d10[15:0]) * $signed(fft_d10[15:0]);
        fft_d11_tmp1 <= $signed(fft_d11[31:16]) * $signed(fft_d11[31:16]);  fft_d11_tmp2 <= $signed(fft_d11[15:0]) * $signed(fft_d11[15:0]);
        fft_d12_tmp1 <= $signed(fft_d12[31:16]) * $signed(fft_d12[31:16]);  fft_d12_tmp2 <= $signed(fft_d12[15:0]) * $signed(fft_d12[15:0]);
        fft_d13_tmp1 <= $signed(fft_d13[31:16]) * $signed(fft_d13[31:16]);  fft_d13_tmp2 <= $signed(fft_d13[15:0]) * $signed(fft_d13[15:0]);
        fft_d14_tmp1 <= $signed(fft_d14[31:16]) * $signed(fft_d14[31:16]);  fft_d14_tmp2 <= $signed(fft_d14[15:0]) * $signed(fft_d14[15:0]);
        fft_d15_tmp1 <= $signed(fft_d15[31:16]) * $signed(fft_d15[31:16]);  fft_d15_tmp2 <= $signed(fft_d15[15:0]) * $signed(fft_d15[15:0]);

        if (flag_analysis[0]) begin
            analysis_0 <= (fft_d0_tmp1 + fft_d0_tmp2) + analysis_0;
            analysis_1 <= (fft_d1_tmp1 + fft_d1_tmp2) + analysis_1;
            analysis_2 <= (fft_d2_tmp1 + fft_d2_tmp2) + analysis_2;
            analysis_3 <= (fft_d3_tmp1 + fft_d3_tmp2) + analysis_3;
            analysis_4 <= (fft_d4_tmp1 + fft_d4_tmp2) + analysis_4;
            analysis_5 <= (fft_d5_tmp1 + fft_d5_tmp2) + analysis_5;
            analysis_6 <= (fft_d6_tmp1 + fft_d6_tmp2) + analysis_6;
            analysis_7 <= (fft_d7_tmp1 + fft_d7_tmp2) + analysis_7;
            analysis_8 <= (fft_d8_tmp1 + fft_d8_tmp2) + analysis_8;
            analysis_9 <= (fft_d9_tmp1 + fft_d9_tmp2) + analysis_9;
            analysis_10 <= (fft_d10_tmp1 + fft_d10_tmp2) + analysis_10;
            analysis_11 <= (fft_d11_tmp1 + fft_d11_tmp2) + analysis_11;
            analysis_12 <= (fft_d12_tmp1 + fft_d12_tmp2) + analysis_12;
            analysis_13 <= (fft_d13_tmp1 + fft_d13_tmp2) + analysis_13;
            analysis_14 <= (fft_d14_tmp1 + fft_d14_tmp2) + analysis_14;
            analysis_15 <= (fft_d15_tmp1 + fft_d15_tmp2) + analysis_15;
        end

        if (flag_analysis[1]) begin
            if (cnt_analysis == 6'd63) begin
                cnt_analysis <= cnt_analysis;
            end else begin
                cnt_analysis <= cnt_analysis + 6'd1;
            end
        end
    end
end


always @(*) begin
    if (cnt_analysis == 6'd63) begin
        done <= 1;
        max_tmp0 = max(analysis_0, analysis_1, analysis_2, analysis_3);
        max_tmp1 = max(analysis_4, analysis_5, analysis_6, analysis_7);
        max_tmp2 = max(analysis_8, analysis_9, analysis_10, analysis_11);
        max_tmp3 = max(analysis_12, analysis_13, analysis_14, analysis_15);

        max_tmp4 <= max(max_tmp0, max_tmp1, max_tmp2, max_tmp3);


        if (max_tmp4 == analysis_0) begin
            freq = 4'b0000;
        end
        else if (max_tmp4 == analysis_1) begin
            freq = 4'b0001;
        end
        else if (max_tmp4 == analysis_2) begin
            freq = 4'b0010;
        end
        else if (max_tmp4 == analysis_3) begin
            freq = 4'b0011;
        end
        else if (max_tmp4 == analysis_4) begin
            freq = 4'b0100;
        end
        else if (max_tmp4 == analysis_5) begin
            freq = 4'b0101;
        end
        else if (max_tmp4 == analysis_6) begin
            freq = 4'b0110;
        end
        else if (max_tmp4 == analysis_7) begin
            freq = 4'b0111;
        end
        else if (max_tmp4 == analysis_8) begin
            freq = 4'b1000;
        end
        else if (max_tmp4 == analysis_9) begin
            freq = 4'b1001;
        end
        else if (max_tmp4 == analysis_10) begin
            freq = 4'b1010;
        end
        else if (max_tmp4 == analysis_11) begin
            freq = 4'b1011;
        end  
        else if (max_tmp4 == analysis_12) begin
            freq = 4'b1100;
        end  
        else if (max_tmp4 == analysis_13) begin
            freq = 4'b1101;
        end    
        else if (max_tmp4 == analysis_14) begin
            freq = 4'b1110;
        end
        else if (max_tmp4 == analysis_15) begin
            freq = 4'b1111;
        end else begin
            freq = 4'b0000;
        end
    end else begin
        done = 0;
        max_tmp0 = 32'd0;
        max_tmp1 = 32'd0;
        max_tmp2 = 32'd0;
        max_tmp3 = 32'd0;
        max_tmp4 = 32'd0;

        freq = 4'd0;
    end
end


function [31:0] max;
		input [31:0] a, b, c, d;
		begin
			max = (((((a >= b) ? a : b) >= c) ? ((a >= b) ? a : b) : c) >= d) ? ((((a >= b) ? a : b) >= c) ? ((a >= b) ? a : b) : c) : d;
		end
endfunction

endmodule
