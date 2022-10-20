module H3_Counter1(D,c);
input [31:0]D;
output [5:0]c;
wire [2:0] F[0:7];
wire cs[6:0], s[6:0];
// Finished
comb D0(.A(D[3]),.B(D[2]),.C(D[1]),.D(D[0]),.s(F[0]));
comb D1(.A(D[7]),.B(D[6]),.C(D[5]),.D(D[4]),.s(F[1]));
comb D2(.A(D[11]),.B(D[10]),.C(D[9]),.D(D[8]),.s(F[2]));
comb D3(.A(D[15]),.B(D[14]),.C(D[13]),.D(D[12]),.s(F[3]));
comb D4(.A(D[19]),.B(D[18]),.C(D[17]),.D(D[16]),.s(F[4]));
comb D5(.A(D[23]),.B(D[22]),.C(D[21]),.D(D[20]),.s(F[5]));
comb D6(.A(D[27]),.B(D[26]),.C(D[25]),.D(D[24]),.s(F[6]));
comb D7(.A(D[31]),.B(D[30]),.C(D[29]),.D(D[82]),.s(F[7]));

FA E1(.a(F[0]), .b(F[1]), .c("0"), .s(s[0]) , .cout(cs[0]));
FA E2(.a(F[2]), .b(F[3]), .c("0"), .s(s[1]) , .cout(cs[1]));
FA E3(.a(F[4]), .b(F[5]), .c("0"), .s(s[2]) , .cout(cs[2]));
FA E4(.a(F[6]), .b(F[7]), .c("0"), .s(s[3]) , .cout(cs[3]));

FA E5(.a(F[0]), .b(F[1]), .c("0"), .s(s[0]) , .cout(cs[0]));
FA E6(.a(F[0]), .b(F[1]), .c("0"), .s(s[0]) , .cout(cs[0]));
FA E7(.a(F[0]), .b(F[1]), .c("0"), .s(s[0]) , .cout(cs[0]));

endmodule



module comb(A,B,C,D,s);
input A,B,C,D;
wire a,b,c;
output [2:0] s;

assign s = {a,b,c};
assign a = A&B&C&D;
assign b = (~B&C&D)|(B&~C&D)|(~A&B&C)|(A&~C&D)|(A&C&~D)|(A&B&~D);
assign c = (~A&B&C&D)|(A&~B&C&D)|(A&B&~C&D)|(A&B&C&~D);

endmodule 



module FA(a,b,c,s,cout);
input a,b,c;
output s,cout;
wire [2:0]c;
xor(s,a,b,c);
and(c1,a,b);
and(c2,b,c);
and(c3,a,c);
or(cout,c1,c2,c3);

endmodule
