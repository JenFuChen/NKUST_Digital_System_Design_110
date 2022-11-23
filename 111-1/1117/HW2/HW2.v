module HW2(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	input [18:0] SW;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

	reg [3:0] num1_1, num1_2, num2_1, num2_2, num3_1, num3_2, num4_1, num4_2;
	
	LED_Decoder U_1(.data(SW[17:14]), .out(HEX7));
	LED_Decoder U_2(.data(SW[17:14]), .out(HEX6));
	LED_Decoder U_3(.data(SW[17:14]), .out(HEX5));
	LED_Decoder U_4(.data(SW[17:14]), .out(HEX4));
	LED_Decoder U_5(.data(SW[17:14]), .out(HEX3));
	LED_Decoder U_6(.data(SW[17:14]), .out(HEX2));
	LED_Decoder U_7(.data(SW[17:14]), .out(HEX1));
	LED_Decoder U_8(.data(SW[17:14]), .out(HEX0));
	
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
// {HEX3,HEX2,HEX1,HEX0} = 28'b0111110_1010100_1011110_1110001;
