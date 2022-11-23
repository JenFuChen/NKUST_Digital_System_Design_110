module HW3(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	input [18:0] SW;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

	reg [7:0] A, B;
	reg [15:0] result;

	parameter flag = 1;
	// Display current num
	// A
	LED_Decoder U_1(.data(SW[17:14]), .mode(1), .out(HEX7));
	LED_Decoder U_2(.data(SW[13:10]), .mode(1), .out(HEX6));
	// B
	LED_Decoder U_3(.data(SW[9:6]), .mode(1), .out(HEX5));
	LED_Decoder U_4(.data(SW[5:2]), .mode(1), .out(HEX4));

	// Result Display
	LED_Decoder U_5(.data(result[15:12]), .mode(flag), .out(HEX3));
	LED_Decoder U_6(.data(result[11:8]), .mode(flag), .out(HEX2));
	LED_Decoder U_7(.data(result[7:4]), .mode(flag), .out(HEX1));
	LED_Decoder U_8(.data(result[3:0]), .mode(flag), .out(HEX0));

	assign A = SW[17:10];
	assign B = SW[9:20];

	always @(*) begin
		if(SW[17:14] > 4'b1011 || SW[13:10] > 4'b1011 || SW[9:6] > 4'b1011 || SW[5:2] > 4'b1011)begin
			flag = 0
			result = 16'b0000_0001_0010_0011;// UndF
		end
		else begin
			flag = 1;
			case (SW[1:0])
				2'b00: result = A + B;
				2'b01: result = A - B;
				2'b10: result = A * B;
				2'b11: result = A / B;
			endcase
		end
	end
endmodule

module LED_Decoder(data, mode, out);
	input [3:0] data;
	input mode;
	output reg[6:0] out;

	always@(*)begin
		if(mode == 1)begin
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
		else begin
			case(data)
				0 : out <= ~7'b0111110; // U
				1 : out <= ~7'b1010100; // n
				2 : out <= ~7'b1011110; // d
				3 : out <= ~7'b1110001; // F
			endcase
		end

		
	end

endmodule

// {HEX3,HEX2,HEX1,HEX0} = 28'b0111110_1010100_1011110_1110001; UndF
