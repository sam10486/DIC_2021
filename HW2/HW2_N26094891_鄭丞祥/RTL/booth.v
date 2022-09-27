module booth(out, in1, in2);

    parameter width = 6;

    input  	[width-1:0] in1;   //multiplicand  m=x bit
    input  	[width-1:0] in2;   //multiplier    r=y bit
    output  [2*width-1:0] out; //product    [11:0]

    
    reg [2*width:0] P;  //[12:0]
    reg signed [2*width:0] tmpP1,tmpP2,tmpP3,tmpP4,tmpP5, tmpP6;
    
    always @(in1 or in2) 
    begin
        //1
        P = {{width{1'b0}}, in2, 1'b0};
        case (P[1:0])
                2'b00:
                begin
                    tmpP1 = P;
                    tmpP1 = tmpP1 >>> 1;
                end 
                2'b01:
                begin
                    tmpP1 = {{P[2*width:width+1] + in1}, P[width:0]};
                    tmpP1 = tmpP1 >>> 1;
                end 
                2'b10:
                begin
                    tmpP1 = {{P[2*width:width+1] - in1}, P[width:0]};
                    tmpP1 = tmpP1 >>> 1;
                end
                default:
                begin
                    tmpP1 = P;
                    tmpP1 = tmpP1 >>> 1;
                end            
        endcase
        //2
        case (tmpP1[1:0])
                2'b00:
                begin
                    tmpP2 = tmpP1;
                    tmpP2 = tmpP2 >>> 1;
                end 
                2'b01:
                begin
                    tmpP2 = {{tmpP1[2*width:width+1] + in1}, tmpP1[width:0]};
                    tmpP2 = tmpP2 >>> 1;
                end 
                2'b10:
                begin
                    tmpP2 = {{tmpP1[2*width:width+1] - in1}, tmpP1[width:0]};
                    tmpP2 = tmpP2 >>> 1;
                end
                default:
                begin
                    tmpP2 = tmpP1;
                    tmpP2 = tmpP2 >>> 1;
                end            
        endcase
        //3
        case (tmpP2[1:0])
                2'b00:
                begin
                    tmpP3 = tmpP2;
                    tmpP3 = tmpP3 >>> 1;
                end 
                2'b01:
                begin
                    tmpP3 = {{tmpP2[2*width:width+1] + in1}, tmpP2[width:0]};
                    tmpP3 = tmpP3 >>> 1;
                end 
                2'b10:
                begin
                    tmpP3 = {{tmpP2[2*width:width+1] - in1}, tmpP2[width:0]};
                    tmpP3 = tmpP3 >>> 1;
                end
                default:
                begin
                    tmpP3 = tmpP2;
                    tmpP3 = tmpP3 >>> 1;
                end            
        endcase
        //4
        case (tmpP3[1:0])
                2'b00:
                begin
                    tmpP4 = tmpP3;
                    tmpP4 = tmpP4 >>> 1;
                end 
                2'b01:
                begin
                    tmpP4 = {{tmpP3[2*width:width+1] + in1}, tmpP3[width:0]};
                    tmpP4 = tmpP4 >>> 1;
                end 
                2'b10:
                begin
                    tmpP4 = {{tmpP3[2*width:width+1] - in1}, tmpP3[width:0]};
                    tmpP4 = tmpP4 >>> 1;
                end
                default:
                begin
                    tmpP4 = tmpP3;
                    tmpP4 = tmpP4 >>> 1;
                end            
        endcase
        //5
        case (tmpP4[1:0])
                2'b00:
                begin
                    tmpP5 = tmpP4;
                    tmpP5 = tmpP5 >>> 1;
                end 
                2'b01:
                begin
                    tmpP5 = {{tmpP4[2*width:width+1] + in1}, tmpP4[width:0]};
                    tmpP5 = tmpP5 >>> 1;
                end 
                2'b10:
                begin
                    tmpP5 = {{tmpP4[2*width:width+1] - in1}, tmpP4[width:0]};
                    tmpP5 = tmpP5 >>> 1;
                end
                default:
                begin
                    tmpP5 = tmpP4;
                    tmpP5 = tmpP5 >>> 1;
                end            
        endcase
        //6
        case (tmpP5[1:0])
                2'b00:
                begin
                    tmpP6 = tmpP5;
                    tmpP6 = tmpP6 >>> 1;
                end 
                2'b01:
                begin
                    tmpP6 = {{tmpP5[2*width:width+1] + in1}, tmpP5[width:0]};
                    tmpP6 = tmpP6 >>> 1;
                end 
                2'b10:
                begin
                    tmpP6 = {{tmpP5[2*width:width+1] - in1}, tmpP5[width:0]};
                    tmpP6 = tmpP6 >>> 1;
                end
                default:
                begin
                    tmpP6 = tmpP5;
                    tmpP6 = tmpP6 >>> 1;
                end            
        endcase
    end
    assign out = tmpP6[2*width:1];

endmodule
