module hw4ALU(A,B,sel,alu,Parity);
input [3:0]B,A;
input [2:0]sel;
output [7:0]alu;
output Parity;
integer i;
integer j;
reg [7:0]alu,alu1,alu2;
reg Parity;
always@(*)
begin
// Finished
case(sel)
3'b000: begin alu[3:0]=~(A&B); alu[7:4]=2'b0000; end
3'b001: begin alu=9'b1000000000-B;end
3'b010: begin alu[7:4]=A|B; alu[3:0]=A|B;end
3'b011: begin alu[7:4]=A^B; alu[3:0]=~(A|B);end
3'b100: begin 
   if (A>=B)
   alu=A<<(B[1:0]);
   else 
   alu=B<<(A[1:0]);end

3'b101: begin alu[7:4]=A;alu[3:0]=B;end
3'b110: begin alu[7:4]=A;alu[3:0]=A;alu=alu%B;end
default: begin alu=A*B;
   if(B%8==1)begin
  alu1=alu<<1;
  alu2=alu>>7;
  alu=alu1+alu2;
 end
 else if(B%8==2)begin
  alu1=alu<<2;
  alu2=alu>>6;
  alu=alu1+alu2;
 end
 else if(B%8==3)begin
  alu1=alu<<3;
  alu2=alu>>5;
  alu=alu1+alu2;
 end
 else if(B%8==4)begin
  alu1=alu<<4;
  alu2=alu>>4;
  alu=alu1+alu2;
 end
 else if(B%8==5)begin
  alu1=alu<<5;
  alu2=alu>>3;
  alu=alu1+alu2;
 end
 else if(B%8==6)begin
  alu1=alu<<6;
  alu2=alu>>2;
  alu=alu1+alu2;
 end
 else if(B%8==7)begin
  alu1=alu<<7;
  alu2=alu>>1;
  alu=alu1+alu2;
 end
 else 
  alu=alu;
end 
endcase
j=alu[7]+alu[6]+alu[5]+alu[4]+alu[3]+alu[2]+alu[1]+alu[0];
if(j%2==0)begin
 Parity=0;
 end
else begin
 Parity=1;
 end
 
end
endmodule