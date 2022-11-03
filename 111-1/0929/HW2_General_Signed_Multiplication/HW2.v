module HW2(a1,b1,p1,a2,b2,p2,a3,b3,p3);
input signed[7:0]a1;
input signed[7:0]b1;
input signed[15:0]a2;
input signed[15:0]b2;
input signed[15:0]a3;
input signed[7:0]b3;
output signed[15:0]p1;
output signed[31:0]p2;
output signed[23:0]p3;
// Finished
//output signed[31:0]a_a;
a8_8 a_1(a1,b1,p1);
a16_16 a_2(a2,b2,p2);
a16_8 a_3(a3,b3,p3);
//assign a_a=17'b10000000000000000-a2;
endmodule

module a16_8(aa,bb,s16_8);
integer i;
input signed[15:0]aa;
input signed[7:0]bb;
reg  [15:0]a;
reg  [7:0]b;
output signed[23:0]s16_8;

reg[23:0]t1,t2,t3,t4,t5,t6,t7,t8;
reg[23:0]s16_8;
reg[25:0]s12;
reg[23:0]s12_0;

always@(*)
begin
 if(aa<0)
  a=17'b10000000000000000-aa;
 else 
  a=aa;
 if(bb<0)
  b=9'b100000000-bb;
 else 
  b=bb;
 for(i=0;i<16;i=i+1)
  t1[i]=a[i]&b[0];
 for(i=1;i<17;i=i+1)
  t2[i]=a[i-1]&b[1];
 for(i=2;i<18;i=i+1)
  t3[i]=a[i-2]&b[2];
 for(i=3;i<19;i=i+1)
  t4[i]=a[i-3]&b[3];
 for(i=4;i<20;i=i+1)
  t5[i]=a[i-4]&b[4];
 for(i=5;i<21;i=i+1)
  t6[i]=a[i-5]&b[5];
 for(i=6;i<22;i=i+1)
  t7[i]=a[i-6]&b[6];
 for(i=7;i<23;i=i+1)
  t8[i]=a[i-7]&b[7];
 
 for(i=0;i<1;i=i+1)
 begin
  t2[i]=0;
  if(t8[22]==0)
   t8[23-i]=0;
  else 
   t8[23-i]=1;
 end
 for(i=0;i<2;i=i+1)
 begin
  t3[i]=0;
  if(t7[21]==0)
   t7[23-i]=0;
  else 
   t7[23-i]=1;
  
 end
 for(i=0;i<3;i=i+1)
 begin
  t4[i]=0;
  if(t6[20]==0)
   t6[23-i]=0;
  else 
   t6[23-i]=1;
 end
 for(i=0;i<4;i=i+1)
 begin
  t5[i]=0;
  if(t5[19]==0)
   t5[23-i]=0;
  else 
   t5[23-i]=1;;
 end
 for(i=0;i<5;i=i+1)
 begin
  t6[i]=0;
  if(t4[18]==0)
   t4[23-i]=0;
  else 
   t4[23-i]=1;;
 end
 for(i=0;i<6;i=i+1)
 begin
  t7[i]=0;
  if(t3[17]==0)
   t3[23-i]=0;
  else 
   t3[23-i]=1;;
 end
 for(i=0;i<7;i=i+1)
 begin
  t8[i]=0;
  if(t2[16]==0)
   t2[23-i]=0;
  else 
   t2[23-i]=1;;
 end
 
 for(i=0;i<8;i=i+1)
 begin
  if(t1[15]==0)
   t1[23-i]=0;
  else 
   t1[23-i]=1;;
 end
 
 
 s12<=t1+t2+t3+t4+t5+t6+t7+t8;
 if((aa<0&bb>0)|(aa>0&bb<0))
 begin
  for(i=0;i<24;i=i+1)
  begin
   s12_0[i]=s12[i];
  end
  s16_8=25'b10000000000000000000000000-s12_0;
 end
 else 
 begin
  for(i=0;i<24;i=i+1)
  begin
   s16_8[i]=s12[i];
  end
 end
 
end
endmodule

module a16_16(aa,bb,s16_16);
integer i;
input signed[15:0]aa,bb;
reg  [15:0]a,b;
output signed[31:0]s16_16;

reg[31:0]t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16;
reg[31:0]s16_16;
reg[34:0]s16;
reg[31:0]s16_0;

always@(*)
begin
 if(aa<0)
  a=17'b10000000000000000-aa;
 else 
  a=aa;
 if(bb<0)
  b=17'b10000000000000000-bb;
 else 
  b=bb;
 for(i=0;i<16;i=i+1)
  t1[i]=a[i]&b[0];
 for(i=1;i<17;i=i+1)
  t2[i]=a[i-1]&b[1];
 for(i=2;i<18;i=i+1)
  t3[i]=a[i-2]&b[2];
 for(i=3;i<19;i=i+1)
  t4[i]=a[i-3]&b[3];
 for(i=4;i<20;i=i+1)
  t5[i]=a[i-4]&b[4];
 for(i=5;i<21;i=i+1)
  t6[i]=a[i-5]&b[5];
 for(i=6;i<22;i=i+1)
  t7[i]=a[i-6]&b[6];
 for(i=7;i<23;i=i+1)
  t8[i]=a[i-7]&b[7];
 for(i=8;i<24;i=i+1)
  t9[i]=a[i-8]&b[8];
 for(i=9;i<25;i=i+1)
  t10[i]=a[i-9]&b[9];
 for(i=10;i<26;i=i+1)
  t11[i]=a[i-10]&b[10];
 for(i=11;i<27;i=i+1)
  t12[i]=a[i-11]&b[11];
 for(i=12;i<28;i=i+1)
  t13[i]=a[i-12]&b[12];
 for(i=13;i<29;i=i+1)
  t14[i]=a[i-13]&b[13];
 for(i=14;i<30;i=i+1)
  t15[i]=a[i-14]&b[14];
 for(i=15;i<31;i=i+1)
  t16[i]=a[i-15]&b[15];
  
 for(i=0;i<1;i=i+1)
 begin
  t2[i]=0;
  if(t16[30]==0)
   t16[31-i]=0;
  else 
   t16[31-i]=1;
 end
 for(i=0;i<2;i=i+1)
 begin
  t3[i]=0;
  if(t15[29]==0)
   t15[31-i]=0;
  else 
   t15[31-i]=1;
  
 end
 for(i=0;i<3;i=i+1)
 begin
  t4[i]=0;
  if(t14[28]==0)
   t14[31-i]=0;
  else 
   t14[31-i]=1;
 end
 for(i=0;i<4;i=i+1)
 begin
  t5[i]=0;
  if(t13[27]==0)
   t13[31-i]=0;
  else 
   t13[31-i]=1;;
 end
 for(i=0;i<5;i=i+1)
 begin
  t6[i]=0;
  if(t12[26]==0)
   t12[31-i]=0;
  else 
   t12[31-i]=1;;
 end
 for(i=0;i<6;i=i+1)
 begin
  t7[i]=0;
  if(t11[25]==0)
   t11[31-i]=0;
  else 
   t11[31-i]=1;;
 end
 for(i=0;i<7;i=i+1)
 begin
  t8[i]=0;
  if(t10[24]==0)
   t10[31-i]=0;
  else 
   t10[31-i]=1;;
 end
 for(i=0;i<8;i=i+1)
 begin
  t9[i]=0;
  if(t9[23]==0)
   t9[31-i]=0;
  else 
   t9[31-i]=1;
 end
 for(i=0;i<9;i=i+1)
 begin
  t10[i]=0;
  if(t8[22]==0)
   t8[31-i]=0;
  else 
   t8[31-i]=1;
  
 end
 for(i=0;i<10;i=i+1)
 begin
  t11[i]=0;
  if(t7[21]==0)
   t7[31-i]=0;
  else 
   t7[31-i]=1;
 end
 for(i=0;i<11;i=i+1)
 begin
  t12[i]=0;
  if(t6[20]==0)
   t6[31-i]=0;
  else 
   t6[31-i]=1;;
 end
 for(i=0;i<12;i=i+1)
 begin
  t13[i]=0;
  if(t5[19]==0)
   t5[31-i]=0;
  else 
   t5[31-i]=1;;
 end
 for(i=0;i<13;i=i+1)
 begin
  t14[i]=0;
  if(t4[18]==0)
   t4[31-i]=0;
  else 
   t4[31-i]=1;;
 end
 for(i=0;i<14;i=i+1)
 begin
  t15[i]=0;
  if(t3[17]==0)
   t3[31-i]=0;
  else 
   t3[31-i]=1;;
 end
 for(i=0;i<15;i=i+1)
 begin
  t16[i]=0;
  if(t2[16]==0)
   t2[31-i]=0;
  else 
   t2[31-i]=1;;
 end

 for(i=0;i<16;i=i+1)
 begin
  if(t1[15]==0)
   t1[31-i]=0;
  else 
   t1[31-i]=1;;
 end
 
 
 s16<=t1+t2+t3+t4+t5+t6+t7+t8+t9+t10+t11+t12+t13+t14+t15+t16;
 if((aa<0&bb>0)|(aa>0&bb<0))
 begin
  for(i=0;i<32;i=i+1)
  begin
   s16_0[i]=s16[i];
  end
  s16_16=33'b100000000000000000000000000000000-s16_0;
 end
 else 
 begin
  for(i=0;i<32;i=i+1)
  begin
   s16_16[i]=s16[i];
  end
 end
 
end
endmodule

module a8_8(aa,bb,s8_8);
input signed[7:0]aa,bb;
reg  [7:0]a,b;
output signed[15:0]s8_8;
integer i;
reg[15:0]t1,t2,t3,t4,t5,t6,t7,t8;
reg[17:0]s8;
reg[15:0]s8_0;
reg[15:0]s8_8;
always@(*)
begin
 if(aa<0)
  a=9'b100000000-aa;
 else 
  a=aa;
 if(bb<0)
  b=9'b100000000-bb;
 else 
  b=bb;
 for(i=0;i<8;i=i+1)
  t1[i]=a[i]&b[0];
 for(i=1;i<9;i=i+1)
  t2[i]=a[i-1]&b[1];
 for(i=2;i<10;i=i+1)
  t3[i]=a[i-2]&b[2];
 for(i=3;i<11;i=i+1)
  t4[i]=a[i-3]&b[3];
 for(i=4;i<12;i=i+1)
  t5[i]=a[i-4]&b[4];
 for(i=5;i<13;i=i+1)
  t6[i]=a[i-5]&b[5];
 for(i=6;i<14;i=i+1)
  t7[i]=a[i-6]&b[6];
 for(i=7;i<15;i=i+1)
  t8[i]=a[i-7]&b[7];
 for(i=0;i<1;i=i+1)
 begin
  t2[i]=0;
  if(t8[14]==0)
   t8[15-i]=0;
  else 
   t8[15-i]=1;
 end
 for(i=0;i<2;i=i+1)
 begin
  t3[i]=0;
  if(t7[13]==0)
   t7[15-i]=0;
  else 
   t7[15-i]=1;
  
 end
 for(i=0;i<3;i=i+1)
 begin
  t4[i]=0;
  if(t6[12]==0)
   t6[15-i]=0;
  else 
   t6[15-i]=1;
 end
 for(i=0;i<4;i=i+1)
 begin
  t5[i]=0;
  if(t5[11]==0)
   t5[15-i]=0;
  else 
   t5[15-i]=1;;
 end
 for(i=0;i<5;i=i+1)
 begin
  t6[i]=0;
  if(t4[10]==0)
   t4[15-i]=0;
  else 
   t4[15-i]=1;;
 end
 for(i=0;i<6;i=i+1)
 begin
  t7[i]=0;
  if(t3[9]==0)
   t3[15-i]=0;
  else 
   t3[15-i]=1;;
 end
 for(i=0;i<7;i=i+1)
 begin
  t8[i]=0;
  if(t2[8]==0)
   t2[15-i]=0;
  else 
   t2[15-i]=1;;
 end
 for(i=0;i<8;i=i+1)
 begin
  if(t1[7]==0)
   t1[15-i]=0;
  else 
   t1[15-i]=1;;
 end
 s8<=t1+t2+t3+t4+t5+t6+t7+t8;
 if((aa<0&bb>0)|(aa>0&bb<0))
 begin
  for(i=0;i<16;i=i+1)
  begin
   s8_0[i]=s8[i];
  end
  s8_8=17'b10000000000000000-s8_0;
 end
 else 
 begin
  for(i=0;i<16;i=i+1)
  begin
   s8_8[i]=s8[i];
  end
 end
 
end
endmodule