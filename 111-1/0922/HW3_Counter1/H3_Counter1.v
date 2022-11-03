module count(D,c);
input [31:0]D;
output [5:0]c;
wire CC[3:0];
wire [2:0] F[0:7];
wire [3:0]s[6:0];
wire ss;
wire [5:0]c;
assign c={CC[3],ss,s[6]};
//Finished

comb D0(.A(D[3]),.B(D[2]),.C(D[1]),.D(D[0]),.s(F[0]));
comb D1(.A(D[7]),.B(D[6]),.C(D[5]),.D(D[4]),.s(F[1]));
comb D2(.A(D[11]),.B(D[10]),.C(D[9]),.D(D[8]),.s(F[2]));
comb D3(.A(D[15]),.B(D[14]),.C(D[13]),.D(D[12]),.s(F[3]));
comb D4(.A(D[19]),.B(D[18]),.C(D[17]),.D(D[16]),.s(F[4]));
comb D5(.A(D[23]),.B(D[22]),.C(D[21]),.D(D[20]),.s(F[5]));
comb D6(.A(D[27]),.B(D[26]),.C(D[25]),.D(D[24]),.s(F[6]));
comb D7(.A(D[31]),.B(D[30]),.C(D[29]),.D(D[28]),.s(F[7]));

fa_4bits F0(.A(F[0]),.B(F[1]),.Ci("0"),.S(s[0]));
fa_4bits F1(.A(F[2]),.B(F[3]),.Ci("0"),.S(s[1]));
fa_4bits F2(.A(F[4]),.B(F[5]),.Ci("0"),.S(s[2]));
fa_4bits F3(.A(F[6]),.B(F[7]),.Ci("0"),.S(s[3]));
fa_4bits F4(.A(s[0]),.B(s[1]),.Ci("0"),.S(s[4]),.Co(CC[0]));
fa_4bits F5(.A(s[2]),.B(s[3]),.Ci("0"),.S(s[5]),.Co(CC[1]));
fa_4bits F6(.A(s[4]),.B(s[5]),.Ci(CC[1]),.S(s[6]),.Co(CC[2]));
FA_1bit  FF1(.A(CC[0]),.B(CC[1]),.Ci(CC[2]),.S(ss),.Co(CC[3]));

endmodule

module comb(A,B,C,D,s);
input A,B,C,D;
wire a,b,c,d;
output [2:0] s;

assign s = {b,c,d};
assign b = A&B&C&D;
assign c = (~B&C&D)|(B&~C&D)|(~A&B&C)|(A&~C&D)|(A&C&~D)|(A&B&~D);
assign d = A^B^C^D;
endmodule 

module fa_4bits(A, B, Ci, S, Co);
input [3:0]A,B;
input Ci;
output [3:0]S;
output Co;
wire [2:0]t;
FA_1bit B0(.A(A[0]), .B(B[0]), .Ci(Ci), .S(S[0]), .Co(t[0]));
FA_1bit B1(.A(A[1]), .B(B[1]), .Ci(t[0]), .S(S[1]), .Co(t[1])); 
FA_1bit B2(.A(A[2]), .B(B[2]), .Ci(t[1]), .S(S[2]), .Co(t[2])); 
FA_1bit B3(.A(A[3]), .B(B[3]), .Ci(t[2]), .S(S[3]), .Co(Co));
endmodule

module FA_1bit(A, B, Ci, S, Co);
input A, B, Ci;
output S, Co;
assign S = Ci^A^B;
assign Co = (A & B) | (Ci & B) | (Ci & A); 
endmodule