module alu (
    input [3:0] a,b,
    input [2:0]  op,
    output reg[7:0] c
);

//===================== Your Design Begin=====================

always @(*) 
begin
    case(op)
        3'b000:c <= a+b;            //相加
        3'b001:c <= a-b;            //相減
        3'b010:c <= a^b;            //XOR
        3'b011:c <= ~(a&b);           //NAND
        3'b100:c<=9'b100000000-a;   //a -> 2's
        3'b101:c<=9'b100000000-b;   //b -> 2's
        3'b110:c<= (( a >= b ) ? a : b );     //a>b -> a ; a<b -> b
        3'b111:c <= b;              // ->b
    endcase
end
//===================== Your Design End  =====================
    
endmodule

