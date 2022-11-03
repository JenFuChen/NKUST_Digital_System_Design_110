`timescale 1ns/10ps
`define cycle 10
`define terminateCycle 1000000

`define DATA "./IN2.DAT"

`define MAX 10

module tb;

integer i;
integer error;
integer flag;
integer dataCnt;
integer ansCnt;

reg [39:0] dataIn [`MAX:0];
reg [7:0] Xi, Yi, Wi, Xc, Yc;
reg clk = 0;
reg rst = 0;
reg [20:0] clkCnt = 0;


wire [7:0] X_Out, Y_Out;
wire ready;

initial begin
	$timeformat(-9, 1, " ns", 9);
	$readmemh(`DATA, dataIn);
end

GCC U1(.READY_(ready), .Xc(X_Out), .Yc(Y_Out), .Xi(Xi), .Yi(Yi), .Wi(Wi), .RESET_(rst), .CLK(clk));

always #(`cycle / 2) clk = ~clk;

always @(posedge clk) begin
	clkCnt = clkCnt + 1;
	if (clkCnt * 2 > `terminateCycle) begin
		$display("==========================");
		$display("| Failed for simulation! |");
		$display("| Please check your code |");
		$display("==========================");
		$finish;
	end
end

initial begin
    rst = 0;
    dataCnt = 1;
    ansCnt = 1;
    error = 0;
    $display("===== START =====");
    # `cycle
        rst = 1;
    # `cycle 
        rst = 0;

    while(dataCnt < `MAX)
    begin
        if(ready === 1)begin
            Xi = dataIn[ansCnt][39:32];
            Yi = dataIn[ansCnt][31:24];
            Wi = dataIn[ansCnt][23:16];
            Xc = dataIn[ansCnt][15:8];
            Yc = dataIn[ansCnt][7:0];
            $display("Xc = %d , Yc = %d || Correct: Xc = %d, Yc= %d", Xi, Yi, X_Out, Y_Out);
            if(Xc === X_Out && Yc === Y_Out)begin
                $display(" %d   PASS",ansCnt);
            end else begin
                $display(" %d   ERROR!!",ansCnt);
                error = error + 1;
            end

            #  `cycle
                ansCnt = ansCnt + 1;
                dataCnt = dataCnt + 1;
        end
        
    end
    # `cycle
		$display("Simulation Done");
		$display("There were %d errors", error);
		$finish;
end


endmodule