`timescale 10ns / 1ps
`define CYCLE 1.4

module testfixture;
reg  x, y;
wire s;
reg  c_in;
wire c_out;

reg result;
reg c;
integer num = 0;
integer i;
integer err = 0;
integer ans;

FA U1(.s(s), .Carry_out(c_out), .x(x), .y(y), .Carry_in(c_in));

initial begin
  for(i=0;i<=7;i=i+1)
    begin
      #`CYCLE x = i[0]; y = i[1]; c_in = i[2];
      
      #`CYCLE {c, result} = i[0] + i[1] + i[2];
      
      if((c === c_out) && (result === s))
        $display("%d data is correct", num);
      else begin
        $display("%d data is error !! your data is %b, correct data is %b", num, {c_out, s}, {c, result});
        err = err + 1;
      end
      num = num + 1;
    end
  
  
  if(err == 0) begin
    $display("-------------------PASS-------------------");
    $display("All data have been generated successfully!");    
  end else begin
    $display("-------------------ERROR-------------------");
    $display("There are %d errors!", err);
  end
    
  #10 $finish;
  
end
endmodule
