`timescale 1ns/10ps
`define PAT "./pattern.dat"
`define EXP "./golden.dat"



module testfixture();
parameter N_EXP = 64;
parameter N_PAT = N_EXP;

reg [5:0] pat_mem [0:N_EXP-1];
reg exp_mem [0:N_EXP-1];



reg [1:0] S;
reg [3:0] in;
wire      z;

reg       exp_z;

integer i;
integer pass;
integer error;

MUX U1(
    .in(in),
    .s(S),
    .z(z)
);


initial begin
    $dumpfile("MUX.vcd");
    $dumpvars;

    $readmemb(`PAT, pat_mem);
    $readmemb(`EXP, exp_mem);

    pass  = 0; 
    error = 0;

    S = 0;
    in = 0;
    exp_z =0;
 
    $display("-----------------------------------------------------\n");
 	$display("START!!! Simulation Start .....\n");
 	$display("-----------------------------------------------------\n");
    #20; 

    for(i=0;i<N_EXP;i=i+1) begin
        {S, in} = pat_mem[i];
        exp_z   = exp_mem[i];

        #15;

        if( exp_z === z)
            pass = pass + 1; 
        else begin
            $display("FWPASS : Output %d are wrong! in=%b s=%b the real output is %b, but expected result is %b", i, in, S, z, exp_z);
            error = error + 1;
        end
    end
    

    $display("-------------------------------------------------------------\n");

    if(error == 0) begin
        $display("                       ALL PASS                            \n");
    end else begin
        $display("                  There are %d errors!                     \n", error);
    end

    $display("-------------------------------------------------------------\n");
    $finish;

end

endmodule
