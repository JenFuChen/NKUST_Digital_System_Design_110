`timescale 1ns/10ps
`define CYCLE     25.0
`define END_CYCLE 10000
`define PAT_LEN   128
`define EXP_LEN   120
`define DEL       5.0
`define PAT       "./pattern.dat"
`define EXP       "./golden.dat"

module testfixture;
  reg   [7:0] PAT [0:`PAT_LEN - 1];
  reg   [7:0] EXP [0:`EXP_LEN - 1];
  reg   [7:0] count = 0;
  reg         over  = 0;
  reg         check = 0;
  reg         start = 0;
  reg         reset = 0;
  reg         clk   = 0;

  // u_Average output port
  reg   [7:0] data;
  // u_Average input port
  wire        valid;
  wire  [7:0] out;

  integer     i;
  integer     error = 0;
  integer     w     = 0;
  integer     h     = 0;
  Average U1(.clk(clk), .reset(reset), .data(data), .valid(valid), .out(out));

  always begin #(`CYCLE/2) clk = ~clk; end

  // global control
  initial begin
    @(negedge clk); #`DEL; reset = 1'b1;
    #(`CYCLE*1);  #`DEL;#`DEL;reset = 1'b0; start = 1'b1;
    $display("-----------------------------------------------------\n");
    $display("START!!! Simulation Start .....\n");
    $display("-----------------------------------------------------\n");
  end
  // End of Cycle
  initial begin
    #`END_CYCLE;
    $display("-------------------------------------------------------------------\n");
    $display("Error!!! The simulation can't be terminated under normal operation!\n");
    $display("-------------------------FAIL--------------------------------------\n");
    $display("-------------------------------------------------------------------\n");
    $finish;
  end
  // initial pattern and expected result
  initial begin
    $readmemh(`PAT, PAT);
    $readmemh(`EXP, EXP);
  end
  // Send data to u_Average
  initial begin
    wait(start == 1'b1);
    for (i = 0; i < `PAT_LEN; i = i + 1) begin
      @(negedge clk) data <= PAT[i];
    end
  end

  initial begin
    wait(valid == 0); check = 1;
  end
  // Get data from u_Average
  always@(negedge clk) begin
    if (valid == 1 && check == 1) begin
      if (EXP[count] == out) begin
        $display("[%2d][%2d]: pass ", count[7:3], count[2:0]);
      end else begin
        error = error + 1;
        $display("[%2d][%2d]: The output data is %h, but the expected data is %h ", count[7:3], count[2:0], out, EXP[count]);
      end
      count <= count + 1;
      if (count == `EXP_LEN - 1) over = 1'b1;
    end
  end
  // All finish
  initial begin
    @(posedge over)
    $display("Simulation Over!");
    $display("-----------------------------------------------------------");
    if (over == 1'b1) begin
      if (error == 0) begin
        $display("\n");
        $display("\n");
        $display("            ****************************                   ");
        $display("            **                        **           |\__||  ");
        $display("            **  Congratulations !!    **          / O.O  | ");
        $display("            **                        **        /_____   | ");
        $display("            **  Simulation PASS!!     **       /^ ^ ^ \\  |");
        $display("            **                        **      |^ ^ ^ ^ |w| ");
        $display("            ****************************       \\m___m__|_|");
        $display("\n");
        $display("-----------------------------------------------------------");
      end
      else begin
        $display("\n");
        $display("\n");
        $display("            ****************************                   ");
        $display("            **                        **           |\__||  ");
        $display("            **  OOPS!!                **          / X,X  | ");
        $display("            **                        **        /_____   | ");
        $display("            **  Simulation Failed!!   **       /^ ^ ^ \\  |");
        $display("            **                        **      |^ ^ ^ ^ |w| ");
        $display("            ****************************       \\m___m__|_|");
        $display("\n");
        $display("        Final Simulation Result: found %d error !          ", error);
        $display("-----------------------------------------------------------");
      end
      $finish;
    end
  end
endmodule
