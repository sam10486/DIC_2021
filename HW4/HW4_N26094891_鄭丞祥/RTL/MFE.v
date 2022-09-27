
`timescale 1ns/10ps

module MFE(clk,reset,busy,ready,iaddr,idata,data_rd,data_wr,addr,wen);
	input				clk;
	input				reset;
	output reg 			busy;	
	input				ready;	
	output	[13:0]		iaddr;
	input	[7:0]		idata;	
	input	[7:0]		data_rd;
	output reg  [7:0]	data_wr;
	output reg	[13:0]	addr;
	output	reg			wen;
	
	parameter [3:0] S0 = 4'd0,
					S1 = 4'd1,
					S2 = 4'd2,
					S3 = 4'd3,
					S4 = 4'd4;

	reg [2:0] curr_state, next_state;
	reg [3:0] read_counter;
	reg [8:0] tmp_data [7:0];
	reg [6:0] row_counter, column_counter;
	reg signed [8:0] x, y;
	reg [7:0] S [0:8];
	reg [7:0] X [0:8];
	reg [7:0] Y [0:2];
	reg [7:0] Z;
	reg [2:0] sort_count;
	reg sort_complete;
	reg read_9_pattern;

	//state register
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			curr_state <= S0;
		end
		else begin
			curr_state <= next_state;
		end
	end

	//next state logic
	always @(*) begin
		case (curr_state)
			S0: begin
				if (ready) 
					next_state = S1; 
				else 
					next_state = curr_state;
			end 
			S1: begin // filter value
				if (read_9_pattern == 1) 
					next_state = S2;
				else 
					next_state = curr_state;
			end
			S2: begin // sorting
				if (sort_complete == 1) 
					next_state = S3;
				else
					next_state = curr_state;
			end
			S3: begin // write median back and col+1
				if (column_counter == 7'd127 && row_counter == 7'd127) begin
					next_state = S4;
				end
				else begin
					next_state = S1;
				end
			end
			S4: begin
				next_state = S0;
			end
			default: begin
				next_state = S0;
			end
		endcase
	end

	//control signal
	always @(posedge clk) begin
		case (curr_state)
			S0: begin
				busy <= 0; 
				sort_count <= 3'd0;
				wen <= 0;
				read_counter <= 4'd0;
			end 
			S1: begin // filter value
				busy <= 1;
				sort_count <= 3'd0;
				wen <= 0;
				read_counter <= read_counter + 4'd1;
			end
			S2: begin // sorting 
				busy <= 1;
				sort_count <= sort_count + 3'd1;
				wen <= 0;
				read_counter <= 4'd0;
			end
			S3: begin // write median back and col+1
				busy <= 1;
				sort_count <= 3'd0;
				wen <= 1;
				read_counter <= 4'd0;
			end
			S4: begin
				busy <= 0;
				sort_count <= 3'd0;
				wen <= 1;
				read_counter <= 4'd0;
			end
			default: begin
				busy <= 0; 
				sort_count <= 3'd0;
				wen <= 0;
				read_counter <= 4'd0;
			end
		endcase
	end

	//calculate coordinate
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			column_counter <= 7'd0;
			row_counter <= 7'd0;
			read_9_pattern <= 0;
		end
		else begin
			if (curr_state == S1) begin
				case (read_counter)
					4'd0: begin
						x <= column_counter-7'd1;
						y <= row_counter-7'd1;
					end
					4'd1: begin
						x <= column_counter;
						y <= row_counter-7'd1;
					end
					4'd2: begin
						x <= column_counter+7'd1;
						y <= row_counter-7'd1;
					end
					4'd3: begin
						x <= column_counter-7'd1;
						y <= row_counter;
					end
					4'd4: begin
						x <= column_counter;
						y <= row_counter;
					end
					4'd5: begin
						x <= column_counter+7'd1;
						y <= row_counter; 
					end
					4'd6: begin
						x <= column_counter-7'd1;
						y <= row_counter+7'd1;
					end
					4'd7: begin
						x <= column_counter;
						y <= row_counter+7'd1;
					end
					4'd8: begin
						x <= column_counter+7'd1;
						y <= row_counter+7'd1;
						read_9_pattern <= 1'd1;
					end
					default: begin
						x <= x;
						y <= y;
						read_9_pattern <= 1'd0;
					end
				endcase
			end
			else if (curr_state == S3) begin
				data_wr <= Z;
				addr <= column_counter + {row_counter, 7'd0};
				if (column_counter != 7'd127) begin
					column_counter <= column_counter + 7'd1;
					row_counter <= row_counter;
				end
				else begin
					column_counter <= 7'd0;
					row_counter <= row_counter + 7'd1;
				end
			end
			else begin
				x <= x;
				y <= y;
				column_counter <= column_counter;
				row_counter <= row_counter;
				data_wr <= data_wr;
				addr <= addr;
			end
		end
	end

	//9 filter value
	assign iaddr = x + {y, 7'd0};
	always @(posedge clk) begin
		if (curr_state == S1) begin
				case (read_counter)
				4'd1: begin
					if (x<0 || y<0)
						S[0] = 8'd0;
					else 
						S[0] = idata;
				end 
				4'd2: begin
					if (y<0)
						S[1]= 8'd0;
					else
						S[1] = idata;
				end
				4'd3: begin
					if (x>127 || y<0)
						S[2] = 8'd0;
					else 
						S[2] = idata;
				end
				4'd4: begin
					if (x<0)
						S[3] = 8'd0;
					else 
						S[3] = idata;
				end
				4'd5: S[4] <= idata;
				4'd6: begin
					if (x>127)
						S[5] = 8'd0;
					else
						S[5] = idata;
				end
				4'd7: begin
					if (x<0 || y>127)
						S[6] = 8'd0;
					else 
						S[6] = idata;
				end
				4'd8: begin
					if (y>127)
						S[7] = 8'd0;
					else 
						S[7] = idata;
				end
				4'd9: begin
					if (x>127 || y>127)
						S[8] = 8'd0;
					else 
						S[8] = idata;
				end	
				default: begin
					S[0] <= S[0]; S[1] <= S[1]; S[2] <= S[2];
					S[3] <= S[3]; S[4] <= S[4]; S[5] <= S[5];
					S[6] <= S[6]; S[7] <= S[7]; S[8] <= S[8];
				end
			endcase
		end	
	end


	always @(posedge clk or posedge reset) begin
		if (reset) begin
			X[0] <= 8'd0; X[1] <= 8'd0; X[2] <= 8'd0;
			X[3] <= 8'd0; X[4] <= 8'd0; X[5] <= 8'd0;
			X[6] <= 8'd0; X[7] <= 8'd0; X[8] <= 8'd0;
			sort_complete = 0;
		end
		else begin
			case (sort_count)
				3'd0:  begin
					X[0] <= max(S[0], S[3], S[6]); 
					X[1] <= max(S[1], S[4], S[7]); 
					X[2] <= max(S[2], S[5], S[8]);
					X[3] <= med(S[0], S[3], S[6]); 
					X[4] <= med(S[1], S[4], S[7]);
					X[5] <= med(S[2], S[5], S[8]);
					X[6] <= min(S[0], S[3], S[6]); 
					X[7] <= min(S[1], S[4], S[7]); 
					X[8] <= min(S[2], S[5], S[8]);
					sort_complete <= 0;
				end
				3'd1: begin
					Y[0] <= max(X[6], X[7], X[8]);
					Y[1] <= med(X[3], X[4], X[5]);
					Y[2] <= min(X[0], X[1], X[2]); 
					sort_complete <= 0;
				end
				3'd2: begin
					Z <= med(Y[2], Y[1], Y[0]);
					sort_complete <= 1;
				end
				default: begin
					X[0] <= 8'd0; X[1] <= 8'd0; X[2] <= 8'd0;
					X[3] <= 8'd0; X[4] <= 8'd0; X[5] <= 8'd0;
					X[6] <= 8'd0; X[7] <= 8'd0; X[8] <= 8'd0;
					Y[0] <= 8'd0; Y[1] <= 8'd0; Y[2] <= 8'd0;
					sort_complete <= 0;
					Z <= Z;
				end 
			endcase
			
		end
	end


	//*******************
	function [7:0] max;
		input [7:0] a, b, c;
		begin
			max = (((a >= b) ? a : b) >= c ) ?  ((a >= b) ? a : b) : c;
		end
	endfunction
 
	function [7:0] med;
		input [7:0] a, b, c;
		begin
			med = a < b ? (b < c ? b : a < c ? c : a) : (b > c ? b : a > c ? c : a);
		end
	endfunction
 
	function [7:0] min;
		input [7:0] a, b, c;
		begin
			min= (((a <= b) ? a : b) <= c ) ?  ((a <= b) ? a : b) : c;
		end
	endfunction
	//*************************************
endmodule




