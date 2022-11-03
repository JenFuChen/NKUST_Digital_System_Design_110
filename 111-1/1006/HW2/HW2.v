module HW8(clk,rst,a,b,c,d);
input clk,rst;
input [7:0]a;
input [7:0]b;
output [7:0]c;
output [7:0]d;
wire [7:0]a,b;
reg [7:0]c;
reg [7:0]d;
reg [15:0]f;
integer i;
// Finished
always@(posedge clk or posedge rst)begin
if(rst)begin
 f[15:0]=0;
end
else begin
 f[7:0] =a[7:0];
 f[15:8]=8'h0;
  for(i=0;i<9;i=i+1)begin
   if(f[15:8]<b[7:0])begin
    f[15:0]=f[15:0]<<1;
   end
   else begin
    f[15:8]=f[15:8]-b[7:0];
    f[15:0]=f[15:0]<<1;
    f[7:0]=f[7:0]+1;
   end
  end
 d=f[15:8]>>1;
 c=f[7:0];
end
end
endmodule