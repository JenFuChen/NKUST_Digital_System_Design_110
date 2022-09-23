module RCA(s, Carry_out, x, y, Carry_in);
input  [7:0] x, y;
output [7:0] s;
input  Carry_in;
output Carry_out;

//===================== Your Design Begin=====================//
wire c1,c2,c3,c4,c5,c6,c7;

FA FA_0(s[0],c1,x[0],y[0],Carry_in);
FA FA_1(s[1],c2,x[1],y[1],c1);
FA FA_2(s[2],c3,x[2],y[2],c2);
FA FA_3(s[3],c4,x[3],y[3],c3);
FA FA_4(s[4],c5,x[4],y[4],c4);
FA FA_5(s[5],c6,x[5],y[5],c5);
FA FA_6(s[6],c7,x[6],y[6],c6);
FA FA_7(s[7],Carry_out,x[7],y[7],c7);




//===================== Your Design End  =====================//

endmodule
