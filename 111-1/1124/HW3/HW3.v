// ===== Home Work 3 : 1A2B Game ===== //

`define MAXHZ 5_000_000 // to 5 Hz : 

module HW3(CLK, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);

	input 				CLK;
	input 	[3:0] 	KEY;
	input  	[17:0] 	SW;
	output 	[6:0]  	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	
	reg 		[15:0]	guess, answer, out;
	reg 		[31:0] 	count, countButton, countButton2;
	reg 					flag = 0, rst = 0;
	reg 					CLK_5HZ;
	reg 		[3:0]		A, B;
	reg 		[1:0] 	mode = 0;
	reg 		[2:0] 	flagA, flagB;
	
	// Show N A N B
	LED_Decoder U0(.data(A), 		.mode(mode), .out(HEX7));	// num
	LED_Decoder U1(.data(4'b1010), 	.mode(mode), .out(HEX6));	// A
	LED_Decoder U2(.data(B), 		.mode(mode), .out(HEX5));	// num
	LED_Decoder U3(.data(4'b1011),	.mode(mode), .out(HEX4));	// B
	
	// show num
	LED_Decoder U4(.data(out[15:12]), .out(HEX3));	
	LED_Decoder U5(.data(out[11:8] ), .out(HEX2));	
	LED_Decoder U6(.data(out[7:4]  ), .out(HEX1));	
	LED_Decoder U7(.data(out[3:0]  ), .out(HEX0));	
	
	// make CLK to 5HZ
	always @(posedge CLK) begin	
		if( count >= `MAXHZ )begin		
			count <= 1;
			CLK_5HZ <= ~ CLK_5HZ;			
		end else begin
			count <= count + 1;
		end
	end
	 
	// Clean Button: could be a children module
	always @(posedge CLK) begin
		if(countButton >= 1000)begin
			countButton <= 0;
			_KEY1 <= KEY[1];
		end else if(_KEY1 ^ KEY[1]) countButton <= countButton + 1;
		else countButton <= 0;
	end
	
	always @(posedge CLK) begin
		if(countButton2 >= 1000)begin
			countButton2 <= 0;
			_KEY3 <= KEY[3];
		end else if(_KEY3 ^ KEY[3]) countButton2 <= countButton2 + 1;
		else countButton2 <= 0;
	end
	
	// ===== To do When press button ====== //
	
	// KEY1
	always @(negedge _KEY1) begin
		rst = ~rst;
	end
	// KEY3
	
	always @(negedge _KEY3) begin
		flag = ~flag;
	end
	
	// ===== Reset ===== //
	always @(*)begin
		if(!rst)begin
			mode 	<= 0;
			guess	<= 0;
			answer 	<= 0;
			flagA 	<= 0;
			flagB 	<= 0;
			A		<= 0;
			B 		<= 0;
			flag 	<= 0;
		end		
	end
	
	// ===== Start Work ===== //
	always @(*)begin
		if( !flag  )begin
			answer 	= SW[15:0];
			out		= answer;
		end else begin
			if( flag && ~(|(SW)))begin
				guess[15:0] = SW[15:0];
				// Judeg A
				A = (guess[15:12] 	== answer[15:12]) ? A + 1 : A;
				A = (guess[11:8] 	== answer[11:8] ) ? A + 1 : A;
				A = (guess[7:4] 	== answer[7:4]  ) ? A + 1 : A;
				A = (guess[3:0] 	== answer[3:0]  ) ? A + 1 : A;
				
				// Judge B
				B = (guess[15:12] 	== answer[11:8] 	|| guess[15:12] 	== answer[7:4] 		|| guess[15:12]		== answer[3:0] ) ? B + 1 : B;
				B = (guess[11:8] 	== answer[15:12] 	|| guess[11:8] 		== answer[7:4] 		|| guess[11:8] 		== answer[3:0] ) ? B + 1 : B;
				B = (guess[7:4] 	== answer[15:12] 	|| guess[7:4] 		== answer[11:8] 	|| guess[7:4] 		== answer[3:0] ) ? B + 1 : B;
				B = (guess[3:0] 	== answer[15:12] 	|| guess[3:0] 		== answer[11:8] 	|| guess[3:0] 		== answer[7:4] ) ? B + 1 : B;
				
				if(A == 4)	mode = 3;
				else 			mode = 0;
			end else begin

			end			
		end
	end
endmodule

module LED_Decoder(data, out, mode);
	// ===== Decode the input data to 7-LED
	input 		[3:0] data;
	input			[1:0] mode;
	output reg 	[6:0] out;
	
	always@(*)begin
		if(mode == 0)begin
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
				10: out <= ~7'b1110111; // A
				11: out <= ~7'b1111100; // b
				12: out <= ~7'b1011000; // c
				13: out <= ~7'b1011110; // d
				14: out <= ~7'b1111001; // E
				15: out <= ~7'b1110001; // F
			endcase
		end
		else if(mode == 3) begin // PASS of LOSE
			case(data)
				0 : out <= ~7'b1110011; // P
				1 : out <= ~7'b1110111; // A
				2 : out <= ~7'b1101101; // S

				3 : out <= ~7'b0111111; // O
				4 : out <= ~7'b0111000; // L
				5 : out <= ~7'b1111001; // E
				default : out <= ~7'b0000000; // Waiting Mode
			endcase
		end
	end
	
 endmodule