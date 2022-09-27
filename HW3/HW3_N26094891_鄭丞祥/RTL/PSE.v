module PSE ( clk,reset,Xin,Yin,point_num,valid,Xout,Yout);
input clk;
input reset;
input [9:0] Xin;
input [9:0] Yin;
input [2:0] point_num;
output valid;
output [9:0] Xout;
output [9:0] Yout;


reg [2:0] curr_state, next_state;

reg [9:0] x_data [0:5];
reg [9:0] y_data [0:5];
reg [2:0] count, output_count;
wire [22:0] my_cross;
reg valid;
reg [2:0] i, j;
reg [9:0] Xout, Yout;


parameter S0 = 2'd0;
parameter S1 = 2'd1;
parameter S2 = 2'd2;
parameter S3 = 2'd3;

// state register
always @(posedge clk or posedge reset) begin
    if (reset) begin
        curr_state <= S0;
    end
    else begin
        curr_state <= next_state;
    end
end

assign my_cross = ((x_data[j] - x_data[0]) * (y_data[j+1] - y_data[0])) - ((x_data[j+1] - x_data[0]) * (y_data[j] - y_data[0]));


// next state logic
always @(*) begin
    case (curr_state)
        S0: begin
            next_state = (count == point_num-1) ? S1 : S0;
        end
        S1: begin
            if(i == 3'd1) begin
                next_state = S2;       
            end
            else begin
                next_state = curr_state;
            end
        end
        S2: begin
            if (output_count == point_num) begin          
                next_state = S0;
            end
            else begin
                next_state = curr_state;    
            end         
        end
        default: begin
            next_state = S0;
        end
    endcase
end

// data register
always @(posedge clk) begin
    case (curr_state)
        S0: begin
            x_data[count] <= Xin; 
            y_data[count] <= Yin;
        end
        S1: begin  
            if (my_cross[22] == 0) begin
                x_data[j] <= x_data[j+1]; y_data[j] <= y_data[j+1];
                x_data[j+1] <= x_data[j]; y_data[j+1] <= y_data[j];
            end
            else begin
                x_data[j+1] <= x_data[j+1]; y_data[j+1] <= y_data[j+1];
                x_data[j] <= x_data[j]; y_data[j] <= y_data[j];
            end
        end
        S2: begin
            Xout <= x_data[output_count];
            Yout <= y_data[output_count];  
        end
        default: begin
            x_data[count] <= 10'd0;
            y_data[count] <= 10'd0;
            Xout <= 10'd0;
            Yout <= 10'd0;
        end
    endcase
end

// control signal
always @(posedge clk or posedge reset) begin
    if (reset) begin
        i <= 3'd0;
        j <= 3'd0;
        valid <= 0;
        count <= 3'd0;
        output_count <= 3'd0;
    end
    else begin
        case (curr_state)
            S0: begin
                i <= (count == point_num-1) ? point_num - 3'd2 : 3'd0;
                j <= 1;
                valid <= 0;
                count <= reset ? 3'd0 : count + 3'd1;
                output_count <= 3'd0;
            end
            S1: begin  
                if (j != i) begin
                    i <= i;
                    j <= j + 3'd1;
                end
                else begin
                    i <= i - 3'd1;
                    j <= 3'd1;
                end
                valid <= 0;
                count <= count;
                output_count <= 3'd0;
            end
            S2: begin
                i <= i;
                j <= j;
                output_count <= output_count + 3'd1;   
                if (output_count < point_num) begin
                    valid <= 1'd1;
                    count <= count;
                end
                else begin
                    valid <= 1'd0;
                    count <= 3'd0;
                end
            end
            default: begin
                i <= 3'd0;
                j <= 3'd0;
                valid <= 0;
                count <= 3'd0;
                output_count <= 3'd0;
            end
        endcase
    end
end
endmodule

