// ===== Home Work 3 : 1A2B Game ===== //

`define MAXHZ 5_000_000 // to 5 Hz

module HW3(clk, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR , LEDG);
	//input 	CLK_50;
	//wire 	CLK;
	wire 		CLK;
	assign 	CLK = clk;
	input    			clk;
	input  	[3:0]  	KEY;
	input 	[17:0] 	SW;
	
	output 	[6:0]   	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	output	reg [17:0]  LEDR;

	reg   	[17:0]	guess, answer, out;
	reg   	[31:0]  	count, times;
	reg   	[3:0]  	A, B, showA, showB, run;
	reg   	[1:0]		State, NextState;
	// reg    				flag = 0, rst = 0;
	reg   				CLK_5HZ;
	output 	[7:0] 	LEDG;
	
	assign 				LEDG[1:0] = State;
	assign 				LEDG[6] = _KEY3;
	assign 				LEDG[2] = _KEY1;
	wire      			_KEY1, _KEY3;
	reg 					flag;
	parameter    Set = 2'b00, Waiting = 2'b01, Play = 2'b10, SEnd = 2'b11 ;
	
	// Show N A N B in State Play, show Run Circle in State Waiting
	LED_Decoder U0(.data(A),   	.mode(State), .out(HEX7)); // num of A
	LED_Decoder U1(.data(showA),  .mode(State), .out(HEX6)); // show A
	LED_Decoder U2(.data(B),   	.mode(State), .out(HEX5)); // num of B
	LED_Decoder U3(.data(showB), 	.mode(State), .out(HEX4)); // show B
	
	// show num ( PASS, LOSE, Answer Num, Guess Num)
	// State 0: show num, State 3: show pass or lose, State 2: run Circle
	LED_Decoder U4(.data(out[15:12]), .mode(State), .out(HEX3)); 
	LED_Decoder U5(.data(out[11:8] ), .mode(State), .out(HEX2)); 
	LED_Decoder U6(.data(out[7:4]  ), .mode(State), .out(HEX1)); 
	LED_Decoder U7(.data(out[3:0]  ), .mode(State), .out(HEX0)); 
	
	// Debounce Button
	Debounce U8(.clk(CLK), .in(KEY[1]), .out(_KEY1));
	Debounce U9(.clk(CLK), .in(KEY[3]), .out(_KEY3));
	
	// Make CLK to 5HZ
	always @(posedge CLK) begin
		if( count >= `MAXHZ )begin
			count <= 1;
			CLK_5HZ <= ~ CLK_5HZ;   
		end else begin
			count <= count + 1;
		end
	end
 
	// ===== To do When press button ====== //
	
	
	
	// Run Circle
	always @(posedge CLK_5HZ)begin
		if(State == Waiting || State == SEnd)begin
			if(run < 5)
				run <= run + 1;
			else 
				run <= 0;
		end else if(State == Set)
		run <= 0;
	end
 
 
 
	// ===== Reset ===== //
	always @(negedge _KEY1, posedge CLK_5HZ)begin
		if(!_KEY1)begin
			State  <= Set;
		end else begin
			State  <= NextState;
		end                                                                                   
	end
	
 
 // KEY3 Press to start, guess
	always @(negedge _KEY3) begin
		case (State)
			Set:begin
				LEDR <= 17'b10101010101010101;
				times = 0;
			end
			Waiting:begin			
				times = 0;
				LEDR <= 0 ;
				LEDR <= 0;
				end
			Play:begin
				times = times +1;
				LEDR	= (LEDR << 1 ) + 1 ;
			end
			SEnd:begin
				times = 0;
				LEDR = 18'b101010101010101010;
			end
		endcase
	end
	
 
	// Change State
	always @(posedge CLK_5HZ,negedge _KEY1) begin
		if(!_KEY1)begin
			//LEDR <= 17'b10101010101010101;
			NextState <= Set;
		end
		else begin
			case (State)
				
				Set:begin
					if(!_KEY3)begin 
      				NextState <= Waiting;
     				end
				end
				Waiting:begin
					if(|SW)
						NextState <= Waiting;
					else if(!_KEY3)
						NextState <= Play;
					//LEDR <=  SW;;//(LEDR << 1 )+1;
				end
				Play:begin
					if(guess == answer && !_KEY3)  NextState <= SEnd;
					if(times >= 17)begin
						NextState <= SEnd;
					end
				end
				SEnd:begin
					if(!_KEY3 && !(|SW))
						NextState <= Set;
					else
						NextState <= SEnd;
				end
			endcase
		end
	end
		
	// Output
	always @(posedge CLK_5HZ) begin
		case (State)
		Set:begin
			out  = answer;
		end
		Waiting:begin
			out = {4{4'b1111}};
		end
		Play:begin
			out   = guess;
		end
		SEnd:begin
			if(answer == guess)
				out  = 16'b0000_0001_0010_0010; // PASS
			else
				out  = 16'b0100_0011_0010_0101; // LOSE
		end  
		endcase
	end
 
 
	// ===== Start Work ===== //
	always @(*)begin
		case (State)
			Set:begin
				answer  = SW[15:0];
				
				guess  = 0;
				
				A   = 0;
				B    = 0;
				showA = 0;
				showB = 0;
				flag <= 0;
			end
			Waiting:begin
				{A,showA,B,showB} =  {4{run}};
			end
			Play:begin
			
				if(!_KEY3)begin
					A = 0;
					B = 0;
					// Judeg A
					if (guess[15:12] 	== answer[15:12])  A = A + 1;
					if (guess[11:8]  	== answer[11:8] )  A = A + 1;
					if (guess[7:4]  	== answer[7:4]  )  A = A + 1;
					if (guess[3:0] 	== answer[3:0]  )  A = A + 1;
					
					// Judge B
					if(guess[15:12] == answer[11:8] 	|| guess[15:12] 	== answer[7:4]  	|| guess[15:12] == answer[3:0] ) B = B + 1 ;
					if(guess[11:8]  == answer[15:12]  || guess[11:8]  == answer[7:4]  	|| guess[11:8]  == answer[3:0] )B = B + 1 ;
					if(guess[7:4]  	== answer[15:12]  || guess[7:4]   == answer[11:8]  || guess[7:4]   == answer[3:0] )B = B + 1 ;
					if(guess[3:0]  	== answer[15:12]  || guess[3:0]   == answer[11:8]  || guess[3:0]   == answer[7:4] )B = B + 1 ;
				end else if(_KEY3) begin
					guess[15:0] = SW[15:0];
				end 
				showA  = 10;
				showB  = 11;
			end
			SEnd:begin
				{A,showA,B,showB} =  {4{4'b0011}};
			end
		endcase
	end
	endmodule


module LED_Decoder(data, out, mode);
	// ===== Decode the input data to 7-LED
	input   		[3:0] data;
	input   		[1:0] mode;
	output reg  [6:0] out;
	
	always@(*)begin
		if(mode == 0 || mode == 2)begin
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
		end else if(mode == 3) begin  // PASS of LOSE
			case(data)
				0 : out <= ~7'b1110011; // P
				1 : out <= ~7'b1110111; // A
				2 : out <= ~7'b1101101; // S
				3 : out <= ~7'b0111111; // O
				4 : out <= ~7'b0111000; // L
				5 : out <= ~7'b1111001; // E
				default : out <= ~7'b0000000; // Waiting Mode
			endcase
		end else if (mode == 1) begin // Run Circle
			case(data)
				0 : out <= ~7'b0000001; // 0
				1 : out <= ~7'b0000010; // 1
				2 : out <= ~7'b0000100; // 2
				3 : out <= ~7'b0001000; // 3
				4 : out <= ~7'b0010000; // 4
				5 : out <= ~7'b0100000; // 5
				default : out <= ~7'b0000000; // Waiting Mode
			endcase
		end
	end
endmodule
	
module Debounce(clk, in, out);
	input    in, clk;
	output  reg  out; 

	reg [31:0] count;

	always @(posedge clk)begin
		if(count >= 1000)begin
			count <= 0;
			out  <= in;
		end else if(out ^ in) count <= count + 1;
		else count <= 0;
	end
endmodule
