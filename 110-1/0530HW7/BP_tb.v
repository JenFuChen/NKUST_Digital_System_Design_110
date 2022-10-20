`timescale 1ns/10ps
`define PAT "./pattern1.dat"
`define EXP "./golden1.dat"
// `define PAT "./pattern2.dat"
// `define EXP "./golden2.dat"
`define CYCLE 30.0
`define TIMES 64


module BP_tb ;

    integer times,pass,err;

    reg clk,rst;
    reg pat_mem [0:`TIMES-1];
    reg [3:0] exp_mem [0:`TIMES];
    
    wire jump = (rst)? 1'b0: pat_mem[times];
    wire [3:0]ans = exp_mem [times];
    wire [3:0]out;

    BP U1(.clk(clk),.rst(rst) ,.jump(jump) ,.out(out));


    always begin #((`CYCLE)/2) clk = ~clk; end


    initial begin
        $readmemb(`PAT, pat_mem);
        $readmemh(`EXP, exp_mem); 
    end

    initial begin
        clk = 1;
        rst = 1'b0;
        @(posedge clk) #(`CYCLE*0.1)	rst = 1'b1;
		@(negedge clk) #(`CYCLE*1.2)    rst = 1'b0;
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
        if(`PAT == "./pattern1.dat")
            $display("------------------PATTERN1-----------------------");
        else
            $display("------------------PATTERN2-----------------------");
    end

    always @(posedge clk) begin
        if( (err+pass) == `TIMES ) begin //times == `TIMES + 1
            if(err == 0)begin
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
                $display("         Totally has %d errors                     ", err);
                $display("\n");
            end
            $finish;
        end
    end   

    always@(negedge clk or posedge rst)begin
        if(rst)begin
            times <= 0;
        end else begin
            times <= times + 1;
        end
    end

    always@(negedge clk or posedge rst)begin
        if(rst)begin
            pass <= 0;
            err  <= 0;
        end else begin
            if((pass+err) < `TIMES)begin
                #(`CYCLE*0.4)       
                if(out === ans) begin
                    pass <= pass + 1;
                end else begin
                    $display(" %2d times jumps: expected value : %h !=  receive value : %h",times,ans,out);
                    err <= err + 1;
                end
                
            end
        end
    end
    
endmodule

