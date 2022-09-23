module HW2_CLA(a1,b1,p,g,sum,c2);
input [7:0]a1;
input [7:0]b1;
output [7:0]p;
output [7:0]g;
output [8:0]sum;
output [8:0]c2;
fa fa1(p[0],g[0],a1[0],b1[0]);
fa fa2(p[1],g[1],a1[1],b1[1]);
fa fa3(p[2],g[2],a1[2],b1[2]);
fa fa4(p[3],g[3],a1[3],b1[3]);
fa fa5(p[4],g[4],a1[4],b1[4]);
fa fa6(p[5],g[5],a1[5],b1[5]);
fa fa7(p[6],g[6],a1[6],b1[6]);
fa fa8(p[7],g[7],a1[7],b1[7]);
cla cla1(sum[0],c2[1],p[0],g[0],"0");
cla cla2(sum[1],c2[2],p[1],g[1],c2[1]);
cla cla3(sum[2],c2[3],p[2],g[2],c2[2]);
cla cla4(sum[3],c2[4],p[3],g[3],c2[3]);
cla cla5(sum[4],c2[5],p[4],g[4],c2[4]);
cla cla6(sum[5],c2[6],p[5],g[5],c2[5]);
cla cla7(sum[6],c2[7],p[6],g[6],c2[6]);
cla cla8(sum[7],c2[8],p[7],g[7],c2[7]);
cla cla9(sum[8],,"0",,c2[8]);
endmodule
module fa(s,c,a,b);
input a,b;
output s,c;
and(c,a,b);
xor(s,a,b);
endmodule
module cla(s1,c1,p1,g1,c0);
input p1,g1,c0;
output s1,c1;
xor(s1,p1,c0);
assign c1=g1^(p1&c0);
endmodule
