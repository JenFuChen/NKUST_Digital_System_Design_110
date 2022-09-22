
module MUX(
    input [3:0] in,
    input [1:0] s,
    output      z
);


//===================== Your Design Begin=====================
wire n1, n2, n3, n4,notS1,notS0;

not nS1(notS1,s[1]);
not nS0(notS0,s[0]);

and Q1(n1,in[0],notS1,notS0);
and Q2(n2,in[1],notS1,s[0]);
and Q3(n3,in[2],s[1],notS0);
and Q4(n4,in[3],s[1],s[0]);


or out(z,n1,n2,n3,n4);

//===================== Your Design End  =====================

endmodule
