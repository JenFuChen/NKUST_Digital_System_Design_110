module hw9_LSFR(clk,rst,num_temp,out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8);
input clk,rst;
output reg[7:0]num_temp;
output reg[7:0]out_1,out_2,out_3,out_4,out_5,out_6,out_7,out_8;
reg [7:0]temp[7:0];
integer i,j,k;
reg [7:0]temp_sort;

reg [1:0]State,NextState;
parameter S0=2'b00,S1=2'b01,S2=2'b10;
// Finished
always@(posedge clk , posedge rst)begin

    if(rst)begin
        State <= S0;
        num_temp <= 8'hF1;
        i = 0;
    end
    
    else begin
        State <= NextState;
        
        if(i < 8)begin
            num_temp <= {num_temp[6], num_temp[7]^num_temp[5], num_temp[7]^num_temp[4], num_temp[3], num_temp[7]^num_temp[2], num_temp[1], num_temp[0], num_temp[7]};
            temp[i] <= num_temp;
        end
        else begin
            j = 0;
            k = 0;
            for(j=0;j<7;j=j+1)begin
                for(k=0;k<7-j;k=k+1)begin
                    if(temp[k] > temp[k+1])begin
                        temp_sort = temp[k];
                        temp[k] = temp[k+1];
                        temp[k+1] = temp_sort;
                    end
                end
            end
        end
        i = i + 1;
    end
    
end

always@(*)begin
    
    case(State)
    
        S0:begin
            if(i < 8)
                NextState = S1;
            else
                NextState = S0;
        end
        
        S1:begin
        
            if(i >= 16)
                NextState = S2;
            else
                NextState = S1;
        end
        
        S2:begin
            
        end
    endcase
    
end

always@(State)begin

    case(State)
        S0: begin
            out_1 = 0;
            out_2 = 0;
            out_3 = 0;
            out_4 = 0;
            out_5 = 0;
            out_6 = 0;
            out_7 = 0;
            out_8 = 0;
        end
        S1: begin
            
        end
        S2: begin
            out_1 = temp[0];
            out_2 = temp[1];
            out_3 = temp[2];
            out_4 = temp[3];
            out_5 = temp[4];
            out_6 = temp[5];
            out_7 = temp[6];
            out_8 = temp[7];
        end
    endcase
end

endmodule