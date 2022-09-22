module HW1_CSA(A,B,Cin,Cout,SUM);
input [15:0] A, B, Cin;
output [16:0] SUM;
output Cout;
wire [1:0] C[15:0]; // First Level of Cout
wire [1:0] S[15:0]; // First Level of Sum
wire [1:0] C2[15:0]; // Second Level of Cout

/*=====Function=====*/ 
FA D1(.a(A[0]), .b(B[0]), .c(Cin[0]), .s(SUM[0]), .cout(C[0]));
FA D2(.a(A[1]), .b(B[1]), .c(Cin[1]), .s(S[1]), .cout(C[1]));
FA D3(.a(A[2]), .b(B[2]), .c(Cin[2]), .s(S[2]), .cout(C[2]));
FA D4(.a(A[3]), .b(B[3]), .c(Cin[3]), .s(S[3]), .cout(C[3]));

FA D5(.a(A[4]), .b(B[4]), .c(Cin[4]), .s(S[4]), .cout(C[4]));
FA D6(.a(A[5]), .b(B[5]), .c(Cin[5]), .s(S[5]), .cout(C[5]));
FA D7(.a(A[6]), .b(B[6]), .c(Cin[6]), .s(S[6]), .cout(C[6]));
FA D8(.a(A[7]), .b(B[7]), .c(Cin[7]), .s(S[7]), .cout(C[7]));

FA D9(.a(A[8]), .b(B[8]), .c(Cin[8]), .s(S[8]), .cout(C[8]));
FA D10(.a(A[9]), .b(B[9]), .c(Cin[9]), .s(S[9]), .cout(C[9]));
FA D11(.a(A[10]), .b(B[10]), .c(Cin[10]), .s(S[10]), .cout(C[10]));
FA D12(.a(A[11]), .b(B[11]), .c(Cin[11]), .s(S[11]), .cout(C[11]));

FA D13(.a(A[12]), .b(B[12]), .c(Cin[12]), .s(S[12]), .cout(C[12]));
FA D14(.a(A[13]), .b(B[13]), .c(Cin[13]), .s(S[13]), .cout(C[13]));
FA D15(.a(A[14]), .b(B[14]), .c(Cin[14]), .s(S[14]), .cout(C[14]));
FA D16(.a(A[15]), .b(B[15]), .c(Cin[15]), .s(S[15]), .cout(C[15]));


HA E1(.a(C[0]), .b(S[1]), .s(SUM[1]), .c(C2[0]));
FA E2(.a(C[1]), .b(S[2]), .c(C2[0]), .s(SUM[2]), .cout(C2[1]));
FA E3(.a(C[2]), .b(S[3]), .c(C2[1]), .s(SUM[3]), .cout(C2[2]));
FA E4(.a(C[3]), .b(S[4]), .c(C2[2]), .s(SUM[4]), .cout(C2[3]));
FA E5(.a(C[4]), .b(S[5]), .c(C2[3]), .s(SUM[5]), .cout(C2[4]));
FA E6(.a(C[5]), .b(S[6]), .c(C2[4]), .s(SUM[6]), .cout(C2[5]));
FA E7(.a(C[6]), .b(S[7]), .c(C2[5]), .s(SUM[7]), .cout(C2[6]));
FA E8(.a(C[7]), .b(S[8]), .c(C2[6]), .s(SUM[8]), .cout(C2[7]));
FA E9(.a(C[8]), .b(S[9]), .c(C2[7]), .s(SUM[9]), .cout(C2[8]));
FA E10(.a(C[9]), .b(S[10]), .c(C2[8]), .s(SUM[10]), .cout(C2[9]));
FA E11(.a(C[10]), .b(S[11]), .c(C2[9]), .s(SUM[11]), .cout(C2[10]));
FA E12(.a(C[11]), .b(S[12]), .c(C2[10]), .s(SUM[12]), .cout(C2[11]));
FA E13(.a(C[12]), .b(S[13]), .c(C2[11]), .s(SUM[13]), .cout(C2[12]));
FA E14(.a(C[13]), .b(S[14]), .c(C2[12]), .s(SUM[14]), .cout(C2[13]));
FA E15(.a(C[14]), .b(S[15]), .c(C2[13]), .s(SUM[15]), .cout(C2[14]));
HA E16(.a(C[15]), .b(C2[14]), .s(SUM[16]), .c(Cout));

/*=====End=====*/
endmodule






/*=====SubModule=====*/

module FA(a,b,c,s,cout);
input a, b, c;
output s, cout;
wire c1, c2, c3;
/*=====Function===== */

xor(s, a, b, c);
and(c1, a, b);
and(c2, b, c);
and(c3, a, c);
or(cout, c1, c2, c3);

/*=====End=====*/
endmodule


module HA(a,b,s,c);
input a, b;
output s, c;
/*=====Function===== */

xor(s, a, b);
and(c, a, b);

/*=====End=====*/
endmodule