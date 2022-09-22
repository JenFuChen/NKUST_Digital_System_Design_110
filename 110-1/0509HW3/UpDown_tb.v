`timescale 10ns / 1ps
`define CYCLE 5

module updown_tb;
    reg         clk, reset;
    reg         up_down;
    reg   [3:0] ANS;
    wire  [3:0] temp, NEXT_ANS;
    wire  [3:0] count;
    integer     i, err_cnt, k, err_rst;

    parameter   up = 1, down = 0;

    UpDown U1(.clk(clk), .reset(reset), .up_down(up_down), .count(count));

    assign temp     = (up_down == 1)? (ANS==15)? 15:(ANS + 1): (ANS ==0)? 0:(ANS - 1);
    assign NEXT_ANS = (up_down == 1)? (temp == 15)? 15:temp:(temp == 0)? 0:temp;

    initial clk = 0;
    always #(`CYCLE/2) clk = ~clk;
    // pattern generate

    initial begin
        // SET UP THE OUTPUT FORMAT FOR THE TEXT DISPLAY
//        $timeformat(-9, 1, " ns", 9); // Display time in nanoseconds

        err_cnt = 0;
        err_rst = 0;
        reset   = 0;

        # `CYCLE;
        reset   = 1;
        up_down = 0;
        ANS     = 0;

        #(`CYCLE/4) check_reset;
        $display("|------------------------------------------------|");
        $display("|            |      CHECK_COUNT      |           |");
        $display("|------------------------------------------------|");
        # `CYCLE;
        reset   = 0;

        for (i = 0; i < 32; i = i + 1)begin
            up_down = 1;
            #(`CYCLE / 2) check_outputs; // call a task to verify outputs
            @(negedge clk) ANS = NEXT_ANS;
        end
        for (i = 0; i < 20; i = i + 1)begin
            up_down = 0;
            #(`CYCLE / 2) check_outputs; // call a task to verify outputs
            @(negedge clk) ANS = NEXT_ANS;

        end
        for (i = 0; i < 3; i = i + 1)begin
            up_down = 1;
            #(`CYCLE / 2) check_outputs; // call a task to verify outputs
            @(negedge clk) ANS = NEXT_ANS;
        end
        for (i = 0; i < 10; i = i + 1)begin
            up_down = 0;
            #(`CYCLE / 2) check_outputs; // call a task to verify outputs
            @(negedge clk) ANS = NEXT_ANS;
        end

        #(`CYCLE)
        if(err_cnt == 0 && err_rst == 0)begin
            $display("|------------------------------------------------|\n");
            $display("---------------------- PASS ----------------------");
            $display("All data have been generated successfully!");
            $display("--------------------------------------------------");
        end
        else if (err_cnt == 0 && err_rst == 1) begin
            $display("|------------------------------------------------|\n");
            $display("---------------------- ERROR ---------------------");
            $display("initial test, OUT != 0");
            $display("--------------------------------------------------");
        end
        else begin
            $display("|------------------------------------------------|\n");
            $display("---------------------- ERROR ---------------------");
            $display("There are %d errors!", err_cnt);
            $display("--------------------------------------------------");
        end
      $finish;
    end

    task check_reset;
        begin
        $display ("initial test, reset enable, OUT = %d", count);
        if (count != 0) err_rst = 1;
        end
    endtask

    task check_outputs;
        begin
            if(count === ANS)begin
                $display("|-  EXPECTED OUTPUT : %d  =  YOUR  OUTPUT : %d  -|", ANS, count);
            end
            else begin
                $display("|-  EXPECTED OUTPUT : %d !=  ERROR OUTPUT : %d  -|", ANS, count);
                err_cnt = err_cnt + 1;
            end
        end
    endtask
endmodule
