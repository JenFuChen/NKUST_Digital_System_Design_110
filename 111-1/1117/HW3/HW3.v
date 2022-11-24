module HW3(SW,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
input [17:0]SW;
output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
reg [7:0]A,B;
reg [15:0]C,D;
integer i;
wire[6:0]hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7;
reg [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
reg [6:0]H0,H1,H2,H3,H4,H5,H6,H7;
LED_Decoder L0(SW[17:14], hex7);
LED_Decoder L1(SW[13:10], hex6);
LED_Decoder L2(SW[9:6], hex5);
LED_Decoder L3(SW[5:2], hex4);
LED_Decoder L4(D[15:12], hex3);
LED_Decoder L5(D[11:8], hex2);
LED_Decoder L6(D[7:4], hex1);
LED_Decoder L7(D[3:0], hex0);
always@(*)begin
HEX7=hex7;
HEX6=hex6;
HEX5=hex5;
HEX4=hex4;
end
always@(*)begin
  A=SW[17:14]*10+SW[13:10];
  B=SW[9:6]*10+SW[5:2];
  case(SW[1:0])
   2'h0: begin
     if(SW[17:14]>4'd9 || SW[13:10]>4'd9 || SW[9:6]>4'd9 || SW[5:2]>4'd9)begin
      HEX1=~(7'b0110111);
      HEX2=~(7'b1110111);
      HEX3=~(7'b0110111);
      HEX0=~(7'b0000000);
     end
     else begin
      C=A+B;
      if(C<10)begin
       D[3:0]=C;
       D[7:4]=4'h0;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>9 && C < 100)begin
       D[3:0]=C %10;
       D[7:4]=C/10;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>99 && C < 1000)begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       D[11:8]=C/10;
       D[15:12]=4'h0;
      end
      else begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       C=C/10;
       D[11:8]=C%10;
       D[15:12]=C/10;
      end
      HEX3=hex3;
      HEX2=hex2;
      HEX1=hex1;
      HEX0=hex0;
     end
     end
   2'h1:begin
     if(SW[17:14]>4'd9 || SW[13:10]>4'd9 || SW[9:6]>4'd9 || SW[5:2]>4'd9)begin
      HEX1=~(7'b0110111);
      HEX2=~(7'b1110111);
      HEX3=~(7'b0110111);
      HEX0=~(7'b0000000);
     end
     else begin
      {HEX3,HEX2,HEX1,HEX0}=~28'h0;
      C=A-B;
      if(C<10)begin
       D[3:0]=C;
       D[7:4]=4'h0;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>9 && C < 100)begin
       D[3:0]=C %10;
       D[7:4]=C/10;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>99 && C < 1000)begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       D[11:8]=C/10;
       D[15:12]=4'h0;
      end
      else begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       C=C/10;
       D[11:8]=C%10;
       D[15:12]=C/10;
      end
      HEX3=hex3;
      HEX2=hex2;
      HEX1=hex1;
      HEX0=hex0;
      end
     end
   2'h2:begin
     if(SW[17:14]>4'd9 || SW[13:10]>4'd9 || SW[9:6]>4'd9 || SW[5:2]>4'd9)begin
      HEX1=~(7'b1110110);
      HEX2=~(7'b1110111);
      HEX3=~(7'b1110110);
      HEX0=~(7'b0000000);
     end
     else begin
      {HEX3,HEX2,HEX1,HEX0}=~28'h0;
      C=A*B;
      if(C<10)begin
       D[3:0]=C;
       D[7:4]=4'h0;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>9 && C < 100)begin
       D[3:0]=C %10;
       D[7:4]=C/10;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>99 && C < 1000)begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       D[11:8]=C/10;
       D[15:12]=4'h0;
      end
      else begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       C=C/10;
       D[11:8]=C%10;
       D[15:12]=C/10;
      end
      HEX3=hex3;
      HEX2=hex2;
      HEX1=hex1;
      HEX0=hex0;
      end
     end
   2'h3: begin
     if(B==4'h0)begin
     {HEX3,HEX2,HEX1,HEX0} = ~28'b0111110_0110111_1011110_1110001;
     end
     else if(SW[17:14]>4'd9 || SW[13:10]>4'd9 || SW[9:6]>4'd9 || SW[5:2]>4'd9)begin
      HEX1=~(7'b0110111);
      HEX2=~(7'b1110111);
      HEX3=~(7'b0110111);
      HEX0=~(7'b0000000);
     end
     else begin
      {HEX3,HEX2,HEX1,HEX0}=~28'h0;
      C=A/B;
       if(C<10)begin
       D[3:0]=C;
       D[7:4]=4'h0;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>9 && C < 100)begin
       D[3:0]=C %10;
       D[7:4]=C/10;
       D[11:8]=4'h0;
       D[15:12]=4'h0;
      end
      else if(C>99 && C < 1000)begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       D[11:8]=C/10;
       D[15:12]=4'h0;
      end
      else begin
       D[3:0]=C %10;
       C=C/10;
       D[7:4]=C%10;
       C=C/10;
       D[11:8]=C%10;
       D[15:12]=C/10;
      end
      HEX3=hex3;
      HEX2=hex2;
      HEX1=hex1;
      HEX0=hex0;
     end
    end
  endcase 
  
end
endmodule
module LED_Decoder(data, out);
 input [3:0] data;
 output reg [6:0] out;
 always@(*)begin
  case(data)
   0 : out <= ~7'b0111111;
   1 : out <= ~7'b0000110; 
   2 : out <= ~7'b1011011;
   3 : out <= ~7'b1001111;
   4 : out <= ~7'b1100110;
   5 : out <= ~7'b1101101;
   6 : out <= ~7'b1111101;
   7 : out <= ~7'b0000111;
   8 : out <= ~7'b1111111;
   9 : out <= ~7'b1101111;
   10: out <= ~7'b1110111;
   11: out <= ~7'b1111100;
   12: out <= ~7'b1011000;
   13: out <= ~7'b1011110;
   14: out <= ~7'b1111001;
   15: out <= ~7'b1110001;
  endcase
 end
 endmodule
// 指撥開關+-*-