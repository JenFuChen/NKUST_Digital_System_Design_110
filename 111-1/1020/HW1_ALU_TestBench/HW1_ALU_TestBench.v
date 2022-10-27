module HW1_ALU_TestBench(A, B, C, Sel, Alu);
input [7:0] A, B;
input [4:0] C;
input [1:0] Sel;
output [8:0] Alu;

reg [8:0] Alu;


always @(*)
begin
	case(Sel)
		2'b00 : Alu <= (A + B);
		2'b01 : Alu <= ((C[0] == 0) ? (8'b11111111 - A) : (A));
		2'b11 : Alu <= ((C[1:0]) > (A[1:0]) ? C : A);
		2'b10 : Alu <= {1'b0 , ((C > 5) ? (A ^ B) : ~(A & B))};
	endcase
end


endmodule