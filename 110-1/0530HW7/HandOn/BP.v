module BP (
    input clk,
    input rst,
    input jump,
    output reg[3:0] out
);

//===================== Your Design Begin=====================
reg[1:0]State,NextState;
parameter   S0 = 2'b00,S1 = 2'b01,
            S2 = 2'b10,S3 = 2'b11;

always @(posedge clk or posedge rst)
begin
    if(rst)
        State <= S0;
    else
        State <= NextState;
end

always @(*)
begin
    case(State)
        S0:begin
            if(jump == 1)
                NextState = S1;
            else    
                NextState = S0;
        end
        S1:begin
            if(jump == 1)
                NextState = S2;
            else    
                NextState = S0;
        end
        S2:begin
            if(jump == 1)
                NextState = S3;
            else    
                NextState = S1;
        end
        S3:begin
            if(jump == 1)
                NextState = S3;
            else    
                NextState = S2;
        end
    endcase
end

always @(State) 
begin
    case(State)
        S0: out = 0;
        S1: out = 3;
        S2: out = 9;
        S3: out = 6;
    endcase
end
//===================== Your Design End  =====================


    
endmodule

