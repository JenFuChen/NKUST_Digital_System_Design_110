module HW3_Shoot_Darts(a_x,a_y,b_x,b_y,c_x,c_y,d_x,d_y,A_s,B_s,C_s,D_s,Maxs);
input [3:0]a_x,a_y,b_x,b_y,c_x,c_y,d_x,d_y;
output [2:0]A_s,B_s,C_s,D_s,Maxs;
reg [2:0]ma;
 s s1(a_x,a_y,A_s);
 s s2(b_x,b_y,B_s);
 s s3(c_x,c_y,C_s);
 s s4(d_x,d_y,D_s);
always@(*)
begin
 if(A_s==7||B_s==7||C_s==7||D_s==7)
  ma<=7;
 else if(A_s==6||B_s==6||C_s==6||D_s==6)
  ma<=6;
 else if(A_s==5||B_s==5||C_s==5||D_s==5)
  ma<=5;
 else if(A_s==4||B_s==4||C_s==4||D_s==4)
  ma<=4;
 else if(A_s==3||B_s==3||C_s==3||D_s==3)
  ma<=3;
 else if(A_s==2||B_s==2||C_s==2||D_s==2)
  ma<=2;
 else if(A_s==1||B_s==1||C_s==1||D_s==1)
  ma<=1;
 else 
  ma<=0;
end
assign Maxs=ma;
endmodule

module s(x,y,s);
input [3:0]x,y;
output [2:0]s;
reg[2:0]s;
always@(*)
begin
 if(y<10&&y>=0&&x>=0&&(y+2*x)<(16)&&(y+9)>(2*x))
  s=1;
 else if(y>10&&y<16&&x>=0&&(y+2*x)<(16))
  s=2;
 else if(y>10&&y<16&&((y+2*x)>(16))&&(y+9)>(2*x))
  s=3;
 else if(y>10&&y<16&&x<16&&(y+9)<(2*x))
  s=4;
 else if(y<10&&y>=0&&x<16&&(y+2*x)>(16)&&(y+9)<(2*x))
  s=5;
 else if((y>=0)&&((y+2*x)<(16))&&(y+9)<(2*x))
  s=6;
 else if((y<10)&&((y+2*x)>(16))&&(y+9)>(2*x))
  s=7;
 else 
  s=0;
end
endmodule