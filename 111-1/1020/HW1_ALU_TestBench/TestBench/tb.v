`timescale 1ns/10ps
`define A "./A.txt"
`define B "./B.txt"
`define C "./C.txt"
`define Sel "./Sel.txt"
`define ANS "./Alu_Ans.txt"
module tb;

integer i;
integer pass;
integer error;
reg [7:0] a[9999:0], b[9999:0];
reg [4:0] c[9999:0];
reg [1:0] sel[9999:0] 
reg [9:0] ans[9999:0];
reg [9:0] out[9999:0];

initial  begin
    $readmemb(A, a)
    $readmemb(B, b)
    $readmemb(C, c)
    $readmemb(Sel, sel)
    $readmemb(ANS, ans)
    $display("\n");
    $display("                                     _____          ");
    $display("    **************************      /     \\         ");
    $display("    *                        *      vvvvvvv  /|__/|  ");
    $display("    *       START      !!    *         I   / O.O  | ");
    $display("    *                        *         I /_____   | ");
    $display("    *  Simulation Start!!    *        J|/^ ^ ^ \\  |");
    $display("    *                        *         |^ ^ ^ ^ |w| ");
    $display("    **************************          \\m___m__|_|");
    $display("\n");

    for(i = 0 ;i < 9999;i = i + 1){
        HW1_ALU_TestBench ALU(.A(a[i]), .B(b[i]), .C(c[i]), Sel(sel[i]), .Alu(out[i]));
        if(out[i] == ans[i])
            $display("\n %d PASS \n", i);
    }
    
end



endmodule