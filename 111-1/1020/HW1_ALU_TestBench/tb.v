`timescale 1ns/10ps
`define cycle 10
`define terminateCycle 1000000
`define F "./A.txt"
`define G "./B.txt"
`define H "./C.txt"
`define I "./Sel.txt"
`define J "./Alu_Ans.txt"
module tb;

integer i;
integer pass;
integer error;
integer Flag  = 0 ;
reg [7:0] a[9999:0], b[9999:0];
reg [4:0] c[9999:0];
reg [1:0] sel[9999:0];
reg [9:0] ans[9999:0];

reg [7:0] a1,b1;
reg [4:0] c1;
reg [1:0] sel1;
wire [8:0] alu1;

reg [9:0] out1[9999:0];

HW1_ALU_TestBench U1(.A(a1), .B(b1), .C(c1), .Sel(sel1), .Alu(alu1));
        
initial  begin
    error = 0;
    $readmemb(`F, a);
    $readmemb(`G, b);
    $readmemb(`H, c);
    $readmemb(`I, sel);
    $readmemb(`J, ans);

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

    for(i = 0 ;i < 9999;i = i + 1)begin
        a1 = a[i];
        b1 = b[i];
        c1 = c[i];
        sel1 = sel[i];
        # `cycle
        if(alu1 === ans[i])
            $display(" %d PASS ", i);
        else
        begin
            error = error + 1;
            $display(" ERROR in line %d : Your: %d | A: %d | B: %d | C: %d | Sel: %d | Correct: %d", i,alu1,a[i],b[i],c[i],sel[i],ans[i]);

        end
        # `cycle
        if(i == 9998)
            Flag = 1;
    end
    if(Flag == 1)
    begin
        if(error == 0)begin
            $display("\n");
            $display("        **************************               ");
            $display("        *                        *        /|__/|  ");
            $display("        *     Successful !!      *      / O.O  | ");
            $display("        *                        *    /_____   | ");
            $display("        *  Simulation PASS!!     *   /^ ^ ^ \\  |");
            $display("        *                        *  |^ ^ ^ ^ |w| ");
            $display("        **************************   \\m___m__|_|");
            $display("\n");
        end else begin
            $display("\n");
            $display("        **************************               ");
            $display("        *                        *        /|__/|  ");
            $display("        *  OOPS!!                *      / X,X  | ");
            $display("        *                        *    /_____   | ");
            $display("        *  Simulation Failed!!   *   /^ ^ ^ \\  |");
            $display("        *                        *  |^ ^ ^ ^ |w| ");
            $display("        **************************   \\m___m__|_|");
            $display("         Totally has %d errors                     ", error);
            $display("\n");
		
        end
    end
    $finish;
end

endmodule