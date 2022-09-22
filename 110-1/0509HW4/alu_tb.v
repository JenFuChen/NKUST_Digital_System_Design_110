 `timescale 1ns / 1ps  
 `define PAT "./pattern.dat"
 `define EXP "./golden.dat"

module alu_tb;
    parameter PAT_NUM = 2048;

    //PAT_reg
    reg [10:0]pat_mem[0:PAT_NUM-1];
    reg [7:0] exp_mem[0:PAT_NUM-1];
    
    //Inputs
    reg[3:0] A,B;
    reg[2:0] ALU_op;

    //Ans
    reg [7:0] Ans;
    
    //Outputs
    wire[7:0] ALU_Out;
    // Verilog code for ALU
    integer i,err;
    alu U1(.a(A),.b(B),.c(ALU_Out),.op(ALU_op));
    initial begin
      $readmemb(`PAT, pat_mem);
      $readmemb(`EXP, exp_mem); 

      A = 8'h00;
      B = 8'h00;
      ALU_op = 3'h0;
      err = 0;
      #0.5;
      $display("|------------------------------------------------|");     
      $display("|            |   Start Simulation    |           |");
      $display("|------------------------------------------------|");
      $display("|        INPUTS        |  EXPECTED  |    YOUR    |");
      $display("|  OP  |   A   |   B   |     ALU    |     ALU    |");
      $display("|------|-------|-------|------------|------------|");
      #5;

      for (i=0;i<PAT_NUM;i=i+1) begin
        ALU_op = pat_mem[i][10:8];
        A = pat_mem [i][7:4];
        B = pat_mem [i][3:0];
        #10
        Ans = exp_mem [i];
        #10 check_outputs;
      end
      
      $display("|------|-------|-------|------------|------------|");
      $display("|  OP  |   A   |   B   |     ALU    |     ALU    |");
      $display("|        INPUTS        |  EXPECTED  |    YOUR    |");
      $display("|------------------------------------------------|");


      if(err == 0) begin
      $display("|                    ALL PASS                    |");
      end else begin
      $display("|              There are %d errors!              |", err);
      end

      $display("|------------------------------------------------|");
      $finish;
    
      
    end

    task check_outputs;
        begin
            if(Ans === ALU_Out)begin
                $display("|- %b    %b    %b    %b ==  %b -|",ALU_op,A,B, Ans, ALU_Out);
            end
            else begin
                $display("|- %b    %b    %b    %b !=  %b -|",ALU_op,A,B, Ans, ALU_Out);
                err = err + 1;
            end
        end
    endtask


endmodule
