`define MAXHZ 5_000_000 // to 5 Hz :   
module Final(clk, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLOCK, iIRDA, LEDR, LEDG, SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	
	input 				clk;
	input 				iIRDA;
	input		[3:0]  	KEY;
	input 	[17:0] 	SW;

	// ===== VGA ===== //
	output 				VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLOCK;
	output 	[7:0] 	VGA_R,VGA_G, VGA_B;
	
	// ===== Show Data ===== //
	output 	[7:0] 	LEDG;
	output 	[17:0] 	LEDR;
	output 	[6:0]   	HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	
	// ===== IR Remoter ===== //
	wire 		[7:0]		keyCode;
	wire 		[31:0] 	IR_Data;
	wire 					keyValid;
	wire      			_KEY0, _KEY1, _KEY2, _KEY3;
	
	// ===== Game Use ===== //
	reg 					winValid;
	reg		[1:0]		player = 0;
	reg 		[17:0] 	result_in = 0;
	reg		[31:0] 	timer = 0;
	reg		[3:0] 	playTimes;
	reg 		[1:0] 	mode;
	reg 	[17:0] 	TicTac;
	wire 		[1:0]		result;
	
	// wire			clk;
	wire 			CLK_5HZ;
	wire 			show; 
	
	assign 	rst = KEY[0];
	assign 	keyCode = IR_Data[23:16] ;
	assign 	LEDG[4:0] = keyCode; // verify key code data
	assign 	LEDG[7:6] = result; // show who win
	assign 	LEDR = TicTac;
	
	parameter delay = 1;

	// ===== State ===== //
	reg [1:0] State, NextState;
	parameter START = 0, GAMING = 1, WIN = 3,ENDING = 2;
	
	// ===== Screen output ===== //
	VGA U1(clk, rst, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B,VGA_BLANK_N,VGA_CLOCK, player, TicTac, result, State);
	
	// ===== Remoter data ===== //
	IR_RECEIVE U2(.iCLK(clk), .iRST_n(rst), .iIRDA(iIRDA), .oDATA_READY(keyValid), .oDATA(IR_Data));
	
	Clock C1(clk, 5000000, CLK_5HZ);
	Clock C2(clk, 50000000, show);

	Debounce U3(.clk(clk), .in(KEY[0]), .out(_KEY0));

	// Display game information
	LED_Decoder U9(.data(playTimes >= 1 ? playTimes - 1: 0 ), .mode(0), .out(HEX0)); 
	LED_Decoder U10(.data(0), .mode(0), .out(HEX1));
	LED_Decoder U11(.data(result), .mode(0), .out(HEX2));
	LED_Decoder U12(.data(winValid), .mode(0), .out(HEX3));
	
	LED_Decoder U13(.data(player), .mode(0), .out(HEX4));
	LED_Decoder U14(.data(0), .mode(0), .out(HEX5));
	LED_Decoder U15(.data(State), .mode(0), .out(HEX6));
	LED_Decoder U16(.data(0), .mode(0), .out(HEX7));

	CheckWin U8(.data(TicTac), .out(result), .times(playTimes));
	
	always @(posedge clk or negedge rst)begin
		if(~rst)
			State <= START;
		else
			State <= NextState;
	end
	
	always @(negedge keyValid or posedge clk)begin
		case(State)
			START:begin
				if(keyCode == 8'h12)
					NextState = GAMING;
				else
					NextState = START;
			end
			GAMING:begin
				if(winValid || playTimes == 10)
					NextState = ENDING;
				else
					NextState = GAMING;
			end
			ENDING:begin
				if(~winValid || keyCode == 8'h00)
					NextState = START;
				else
					NextState = ENDING;
			end
		endcase
	end
	// ===== Fill in game data here ===== //
	always @(negedge keyValid or negedge rst)begin
		if(~rst)begin
			result_in = 0;
			player = 0;
			playTimes = 0;
		end else begin
			if(State == START)begin
				// Due to the trigger is keyValid
				// User have to press any key to reset data.
				result_in = 0;
				playTimes = 0;
				player = 0;
			end
			else if(State == GAMING)begin
				case(keyCode)
					8'h01:begin
						// Judge game data to fill in user data.
						if(result_in[1:0] == 2'b00)begin
							result_in[1:0] <= player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h02:begin
						if(result_in[3:2] == 2'b00)begin
							result_in[3:2] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h03:begin
						if(result_in[5:4] == 2'b00)begin
							result_in[5:4] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h04:begin
						if(result_in[7:6] == 2'b00)begin
							result_in[7:6] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h05:begin
						if(result_in[9:8] == 2'b00)begin
							result_in[9:8] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h06:begin
						if(result_in[11:10] == 2'b00)begin
							result_in[11:10] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h07:begin
						if(result_in[13:12] == 2'b00)begin
							result_in[13:12] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h08:begin
						if(result_in[15:14] == 2'b00)begin
							result_in[15:14] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					8'h09:begin
						if(result_in[17:16] == 2'b00)begin
							result_in[17:16] = player;
							player = player == 1 ? 2 : 1;
							playTimes = playTimes + 1;
						end
					end
					default:begin
						player = player;
					end
				endcase
			end 
			else if(State == ENDING)begin

				player = 1;
			end
		end
	end
	
	always @(posedge clk or negedge keyValid)begin
		case(State)
			START:begin
				TicTac = 0;
			end
			GAMING:begin
				TicTac = result_in;
			end
			ENDING:begin
				TicTac = result_in;
			end
			default:begin
				TicTac = 1;
			end
		endcase
	end
	
	// This always is about delay check win result to show user data then jump to ENDING State. 
	// Contorl the winValid
	always @(negedge rst, posedge show)begin
		if(!rst)begin
			timer = 0;
			winValid = 0;
		end else begin
			if(result == 2'b11)begin
				timer = 0;
				winValid = 0;
			end else if( ( result != 2'b11) && timer < delay)begin
				winValid = 1;
				timer = timer + 1;
			end else begin
				timer = 0;
				winValid = 0;
			end
		end
	end
	
endmodule

// ===== Check data is win or lose ===== //
module CheckWin( data, out, times);
	input [17:0] data;
	input [3:0] times;
	output reg [1:0] out; // 00: Reset | 01: Player 1 | 10: Player 2 | 11: Judging
	
	reg [31:0] count;
	
	always @(*) begin
			if({data[17:16],data[9:8], data[1:0]} == 6'b01_01_01 || 
				{data[13:12],data[9:8], data[5:4]} == 6'b01_01_01 || 
				{data[13:12],data[7:6], data[1:0]} == 6'b01_01_01 || 
				{data[15:14],data[9:8], data[3:2]} == 6'b01_01_01 || 
				{data[17:16],data[11:10], data[5:4]} == 6'b01_01_01 || 
				data[5:0] 	== 6'b01_01_01 || 
				data[11:6] 	== 6'b01_01_01 || 
				data[17:12] == 6'b01_01_01 )	begin			
					out = 2'b01; // player 1 win
			end
			else if(
				{data[17:16],data[9:8], data[1:0]} == 6'b10_10_10 || 
				{data[13:12],data[9:8], data[5:4]} == 6'b10_10_10 || 
				{data[13:12],data[7:6], data[1:0]} == 6'b10_10_10 || 
				{data[15:14],data[9:8], data[3:2]} == 6'b10_10_10 || 
				{data[17:16],data[11:10], data[5:4]} == 6'b10_10_10 || 
				data[5:0] 	== 6'b10_10_10 ||
				data[11:6] 	== 6'b10_10_10 ||
				data[17:12] == 6'b10_10_10 ) begin
					out = 2'b10; // player 2 win
			end else if(times >= 10) begin
					out = 2'b00; // play times over 10
			end else
				out <= 2'b11; // nothing happened
	end
endmodule


module VGA(clk, rst, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B,VGA_BLANK_N,VGA_CLOCK, player, result_in, result,  state);
	input 				clk, rst;
	input		[1:0]		state; // Receieve in which state
	input 	[1:0]  	player; // Receieve player 1 or 2
	input 	[1:0] 	result; // who win
	input 	[17:0] 	result_in; // Receieve user location (game data)
	
	output 				VGA_HS, VGA_VS;
	output 				VGA_BLANK_N, VGA_CLOCK;
	output reg [7:0] 	VGA_R, VGA_G, VGA_B;

	reg 					clk25M;
	reg 					VGA_HS, VGA_VS;
	reg		[10:0] 	counterHS;
	reg		[9:0] 	counterVS;
	reg 		[2:0] 	valid;
	reg 		[12:0] 	X, Y;
	
	reg 	[23:0]	color[0:5];
	
	parameter H_FRONT = 16;
	parameter H_SYNC  = 96;
	parameter H_BACK  = 48;
	parameter H_ACT   = 640;
	parameter H_BLANK = H_FRONT + H_SYNC + H_BACK;
	parameter H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_ACT;

	parameter V_FRONT = 11;
	parameter V_SYNC  = 2;
	parameter V_BACK  = 32;
	parameter V_ACT   = 480;
	parameter V_BLANK = V_FRONT + V_SYNC + V_BACK;
	parameter V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_ACT;
	assign VGA_SYNC_N = 1'b0;
	assign VGA_BLANK_N = ~((counterHS<H_BLANK)||(counterVS<V_BLANK));
	assign VGA_CLOCK = ~clk25M;

	always@(posedge clk)
		clk25M = ~clk25M;

	always@(posedge clk25M)	begin
		if(!rst) 
			counterHS <= 0;
		else begin
		
			if(counterHS == H_TOTAL) 
				counterHS <= 0;
			else 
				counterHS <= counterHS + 1'b1;
			
			if(counterHS == H_FRONT-1)
				VGA_HS <= 1'b0;
			if(counterHS == H_FRONT + H_SYNC -1)
				VGA_HS <= 1'b1;
				
			if(counterHS >= H_BLANK)
				X <= counterHS-H_BLANK;
			else
				X <= 0;	
		end
	end

	always@(posedge clk25M)
	begin
		if(!rst) 
			counterVS <= 0;
		else begin
		
			if(counterVS == V_TOTAL) 
				counterVS <= 0;
			else if(counterHS == H_TOTAL) 
				counterVS <= counterVS + 1'b1;
				
			if(counterVS == V_FRONT-1)
				VGA_VS <= 1'b0;
			if(counterVS == V_FRONT + V_SYNC -1)
				VGA_VS <= 1'b1;
			if(counterVS >= V_BLANK)
				Y <= counterVS-V_BLANK;
			else
				Y <= 0;
		end
	end

	// ===== Main Screen Output ==== //
	always@(posedge clk25M) begin
		if (!rst) begin
			{VGA_R,VGA_G,VGA_B} <= 0 ;
		end else begin
			if(state == 0)begin
				// Show pre-start screen 
				{VGA_R,VGA_G,VGA_B} <= 24'h64A682; // background
				
				if( ((X - 270) * (X - 270)  + (Y - 240) * (Y - 240)) <= 1600)
					{VGA_R,VGA_G,VGA_B}<=  color[3]; 
				if( ((X - 270) * (X - 270)  + (Y - 240) * (Y - 240)) <= 400)
					{VGA_R,VGA_G,VGA_B}<=  24'h64A682;
				
				if( ((X < 413 && X > 323)  && (Y < 280 && Y > 200))	 && ( (X - Y >= 115) && (X - Y <= 145)  ) )
					{VGA_R,VGA_G,VGA_B} <=  color[3];
				if( ((X < 413 && X > 323)  && (Y < 280 && Y > 200))	 && ( (X + Y >= 595) && (X + Y <= 625)  ) )
					{VGA_R,VGA_G,VGA_B} <=  color[3];
				
			end
			else if(state == 1)begin

				// Draw TicTacToe line
				if(( X <= 218 && X >= 208) || (X >= 421 && X <=431))
					{VGA_R,VGA_G,VGA_B} <= color[0];
				else if(( Y >= 155 && Y <= 165) || (Y <= 325 && Y >= 315))
					{VGA_R,VGA_G,VGA_B} <= color[0];
				else
					{VGA_R,VGA_G,VGA_B}<= color[3];
				
				// Judge each result data is '2'b01' or '2'b10' to show 'O' or 'X'
				// each 'O' or 'X' is design by math.

				// Left Up
				// O
				if(result_in[1:0] == 2'b01)begin
					if( ((X - 107) * (X - 107)  + (Y - 80) * (Y - 80)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 107) * (X - 107)  + (Y - 80) * (Y - 80)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[1:0] == 2'b10)begin
				// X
					if( ((X < 150 && X > 60)  && (Y < 120 && Y > 40)) && ( ( (X - Y >= 22) && (X - Y <= 32)  )  || ( (X + Y >= 182) && (X + Y <= 192) )) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				// Middle  Up
				if(result_in[3:2] == 2'b01)begin
					// O
					if( ((X - 320) * (X - 320)  + (Y - 80) * (Y - 80)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 320) * (X - 320)  + (Y - 80) * (Y - 80)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[3:2] == 2'b10)begin
					// X
					if( ((X < 363 && X > 273)  && (Y < 120 && Y > 40))	 && ( ((X - Y >= 235) && (X - Y <= 245) ) ||  ( (X + Y >= 395) && (X + Y <= 405)  ) ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					// if( ((X < 363 && X > 273)  && (Y < 120 && Y > 40))	 && ( (X + Y >= 395) && (X + Y <= 405)  ) )
					// 	{VGA_R,VGA_G,VGA_B} <=  24'hCA1F3D;
				end
				
				// Right Up
				if(result_in[5:4] == 2'b01)begin
					// O
					if( ((X - 533) * (X - 533)  + (Y - 80) * (Y - 80)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 533) * (X - 533)  + (Y - 80) * (Y - 80)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[5:4] == 2'b10)begin
					// X
					if( ((X < 576 && X > 486)  && (Y < 120 && Y > 40))	 && ( (X - Y >= 448) && (X - Y <= 458)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 576 && X > 486)  && (Y < 120 && Y > 40))	 && ( (X + Y >= 608) && (X + Y <= 618)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				
				// Left Middle
				if(result_in[7:6] == 2'b01)begin
					// O
					if( ((X - 107) * (X - 107)  + (Y - 240) * (Y - 240)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					
					if( ((X - 107) * (X - 107)  + (Y - 240) * (Y - 240)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[7:6] == 2'b10)begin
					// X
					if( ((X < 150 && X > 60)  && (Y < 280 && Y > 200))	 && ( (X - Y >= -138) && (X - Y <= -128)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 150 && X > 60)  && (Y < 280 && Y > 200))	 && ( (X + Y >= 342) && (X + Y <= 352)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				// Middle 
				if(result_in[9:8] == 2'b01)begin
					// O
					if( ((X - 320) * (X - 320)  + (Y - 240) * (Y - 240)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 320) * (X - 320)  + (Y - 240) * (Y - 240)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[9:8] == 2'b10)begin
					// X
					if( ((X < 363 && X > 273)  && (Y < 280 && Y > 200))	 && ( (X - Y >= 75) && (X - Y <= 85)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 363 && X > 273)  && (Y < 280 && Y > 200))	 && ( (X + Y >= 555) && (X + Y <= 565)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				// Right Middle
				if(result_in[11:10] == 2'b01)begin
					// O
					if( ((X - 533) * (X - 533)  + (Y - 240) * (Y - 240)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 533) * (X - 533)  + (Y - 240) * (Y - 240)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[11:10] == 2'b10)begin
					// X
					if( ((X < 576 && X > 486)  && (Y < 280 && Y > 200))	 && ( (X - Y >= 288) && (X - Y <= 298)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 576 && X > 486)  && (Y < 280 && Y > 200))	 && ( (X + Y >= 768) && (X + Y <= 778)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				// Left Down
				if(result_in[13:12] == 2'b01)begin
					// O
					if( ((X - 107) * (X - 107)  + (Y - 400) * (Y - 400)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 107) * (X - 107)  + (Y - 400) * (Y - 400)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[13:12] == 2'b10)begin
					// X
					if( ((X < 150 && X > 60)  && (Y < 440 && Y > 360))	 && ( (X - Y >= -298) && (X - Y <= -288)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 150 && X > 60)  && (Y < 440 && Y > 360))	 && ( (X + Y >= 502) && (X + Y <= 512)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				// Middle Down
				if(result_in[15:14] == 2'b01)begin
					// O
					if( ((X - 320) * (X - 320)  + (Y - 400) * (Y - 400)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 320) * (X - 320)  + (Y - 400) * (Y - 400)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[15:14] == 2'b10)begin
					// X
					if( ((X < 363 && X > 273)  && (Y < 440 && Y > 360))	 && ( (X - Y >= -85) && (X - Y <= -75)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 363 && X > 273)  && (Y < 440 && Y > 360))	 && ( (X + Y >= 715) && (X + Y <= 725)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
				
				// Right Down
				
				if(result_in[17:16] == 2'b01)begin
					// O
					if( ((X - 533) * (X - 533)  + (Y - 400) * (Y - 400)) <= 1600)
						{VGA_R,VGA_G,VGA_B}<=  color[1];
					if( ((X - 533) * (X - 533)  + (Y - 400) * (Y - 400)) <= 900)
						{VGA_R,VGA_G,VGA_B}<=  color[3];
				end else if(result_in[17:16] == 2'b10)begin
					// X
					if( ((X < 576 && X > 486)  && (Y < 440 && Y > 360))	 && ( (X - Y >= 128) && (X - Y <= 138)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
					if( ((X < 576 && X > 486)  && (Y < 440 && Y > 360))	 && ( (X + Y >= 928) && (X + Y <= 938)  ) )
						{VGA_R,VGA_G,VGA_B} <=  color[2];
				end
		
			
			end
			else if(state == 2)begin	
				// Show who win the game
				if(result == 2'b01)
					{VGA_R,VGA_G,VGA_B}<= color[1];
				else if(result == 2'b10)
					{VGA_R,VGA_G,VGA_B}<= color[2];
				else if (result == 2'b00)
					{VGA_R,VGA_G,VGA_B}<= color[0];
			end		
		end
	end
	
	// ===== Color ===== //
	always@(posedge clk,negedge rst)begin
		if(!rst)begin
			color[0]<=24'h000000;
			color[1]<=24'h000000;
			color[2]<=24'h000000;
			color[3]<=24'h000000;
		end else begin
			color[0]<=24'hCACACA;	// Gray 
			color[1]<=24'h2E77AE;  	// Light blue: Player 1
			color[2]<=24'hCA1F3D;	// Red: Player 2
			color[3]<=24'hFFFFFF;	// White
		end
	end

endmodule

// ===== Reomter data ===== //
// this module is the default code in e-learning
module IR_RECEIVE(iCLK,iRST_n,iIRDA,oDATA_READY,oDATA);
					
	input iCLK;        //input clk,50MHz
	input iRST_n;      //rst
	input iIRDA;       //Irda RX output decoded data

	output oDATA_READY; //data ready
	output reg [31:0] oDATA; //output data,32bit 	
					
	parameter IDLE = 2'b00;   //State Machine 
	parameter GUIDANCE = 2'b01;    
	parameter DATAREAD = 2'b10;    


	parameter IDLE_DUR = 230000;  // idle_count    230000*0.02us = 4.60ms, threshold for IDLE--------->GUIDANCE
	parameter GUIDANCE_DUR = 210000;  // guidance_count   210000*0.02us = 4.20ms, 4.5-4.2 = 0.3ms < BIT_AVAILABLE_DUR = 0.4ms,threshold for GUIDANCE------->DATAREAD
	parameter DATAREAD_DUR = 262143;  // data_count    262143*0.02us = 5.24ms, threshold for DATAREAD-----> IDLE

	parameter DATA_HIGH_DUR = 41500;	 // data_count    41500 *0.02us = 0.83ms, sample time from the posedge of iIRDA
	parameter BIT_AVAILABLE_DUR = 20000;   // data_count    20000 *0.02us = 0.4ms,  the sample bit pointer,can inhibit the interference from iIRDA signal

	reg [17:0] idle_count;           
	reg idle_count_flag;       
	reg [17:0] guidance_count;           
	reg guidance_count_flag;      
	reg [17:0] data_count;            
	reg data_count_flag;    
	  
	reg [5:0] bitcount; //sample bit pointer
	reg [1:0] state;   //state reg
	reg [31:0] data;   //data reg
	reg [31:0] data_buf; //data buf
	reg data_ready; //data ready flag


	assign oDATA_READY = data_ready;

	//state change between IDLE,GUIDE,DATA_READ according to irda edge or counter
	always @(posedge iCLK or negedge iRST_n)
	begin 
		  if (!iRST_n)	     
			  state <= IDLE;
		  else 
				 case (state)
					 IDLE     : if (idle_count > IDLE_DUR)  
									  state <= GUIDANCE; 
					 GUIDANCE : if (guidance_count > GUIDANCE_DUR)
									  state <= DATAREAD;
					 DATAREAD : if ((data_count >= DATAREAD_DUR) || (bitcount >= 33))
											state <= IDLE;
				  default  : state <= IDLE; 
				 endcase
	end
	//idle counter switch when iIRDA is low under IDLE state
	always @(posedge iCLK or negedge iRST_n)
	begin	
		  if (!iRST_n)
				idle_count_flag <= 1'b0;
		  else if ((state == IDLE) && !iIRDA)
				 idle_count_flag <= 1'b1;
			else                           
				 idle_count_flag <= 1'b0;		     		 	
	 end  		  
	//idle counter works on iclk under IDLE state only
	always @(posedge iCLK or negedge iRST_n)
	begin	
		  if (!iRST_n)
				idle_count <= 0;
		  else if (idle_count_flag)    //the counter works when the flag is 1
				 idle_count <= idle_count + 1'b1;
			else  
				 idle_count <= 0;	         //the counter resets when the flag is 0		      		 	
	end
		
	//state counter switch when iIRDA is high under GUIDE state
	always @(posedge iCLK or negedge iRST_n)	
	begin
		  if (!iRST_n)
				guidance_count_flag <= 1'b0;
		  else if ((state == GUIDANCE) && iIRDA)
				 guidance_count_flag <= 1'b1;
			else  
				 guidance_count_flag <= 1'b0;     		 	
	end
	//state counter works on iclk under GUIDE state only
	always @(posedge iCLK or negedge iRST_n)	
	begin
		  if (!iRST_n)
				guidance_count <= 0;
		  else if (guidance_count_flag)    //the counter works when the flag is 1
				 guidance_count <= guidance_count + 1'b1;
			else  
				 guidance_count <= 0;	        //the counter resets when the flag is 0		      		 	
	end
	//data counter switch
	always @(posedge iCLK or negedge iRST_n)
	begin
		  if (!iRST_n) 
				data_count_flag <= 0;	
		  else if ((state == DATAREAD) && iIRDA)
				 data_count_flag <= 1'b1;  
			else
				 data_count_flag <= 1'b0; 
	end
	//data read decode counter based on iCLK
	always @(posedge iCLK or negedge iRST_n)	
	begin
		  if (!iRST_n)
				data_count <= 1'b0;
		  else if(data_count_flag)      //the counter works when the flag is 1
				 data_count <= data_count + 1'b1;
			else 
				 data_count <= 1'b0;        //the counter resets when the flag is 0
	end
	///////////////////////////////////////////////////////////////////////////////////////////////

	//data reg pointer counter 
	always @(posedge iCLK or negedge iRST_n)
	begin
		 if (!iRST_n)
			 bitcount <= 6'b0;
		  else if (state == DATAREAD)
			begin
				if (data_count == BIT_AVAILABLE_DUR)
						bitcount <= bitcount + 1'b1; //add 1 when iIRDA posedge
			end   
		  else
			  bitcount <= 6'b0;
	end	  
	//data decode base on the value of data_count 	
	always @(posedge iCLK or negedge iRST_n)
	begin
		  if (!iRST_n)
			  data <= 0;
			else if (state == DATAREAD)
			begin
				 if (data_count >= DATA_HIGH_DUR) //2^15 = 32767*0.02us = 0.64us
					 data[bitcount-1'b1] <= 1'b1;  //>0.52ms  sample the bit 1
			end
			else
				 data <= 0;	
	end		 
	//set the data_ready flag 
	always @(posedge iCLK or negedge iRST_n)
	begin 
		  if (!iRST_n)
			  data_ready <= 1'b0;
		 else if (bitcount == 32)   
			begin
				 if (data[31:24] == ~data[23:16])
				 begin		
						data_buf <= data;     //fetch the value to the databuf from the data reg
					  data_ready <= 1'b1;   //set the data ready flag
				 end	
				 else
					  data_ready <= 1'b0 ;  //data error
			end
			else
				data_ready <= 1'b0 ;
	end
	//read data
	always @(posedge iCLK or negedge iRST_n)
	begin
		  if (!iRST_n)
				oDATA <= 32'b0000;
		  else if (data_ready)
			  oDATA <= data_buf;  //output
	end	  
endmodule

// ===== Debounce the key press ===== //
module Debounce(clk, in, out);
	input    in, clk;
	
	output  reg  out; // valid data

	reg [31:0] count;

	always @(posedge clk)begin
		if(count >= 1000)begin
			count <= 0;
			out  <= in;
		end else if(out ^ in) count <= count + 1;
		else count <= 0;
	end
endmodule

// ===== Frequency divider ===== //
// user can use it to divide the clk to any new CLK
module Clock(clk, HZ, out);
	input clk;
	input [31:0] HZ;
	
	output reg out;
	
	reg [31:0] count;
	
	always@(posedge clk)begin
		if( count >= HZ )begin
			count <= 1;
			out <= ~ out;   
		end else begin
			count <= count + 1;
		end
	end
endmodule

// ===== LED Decoder ===== //
// show 0~9 on seven-segment display LED
// mode is about custom the display such as 'PASS' or 'LOSE' or run circle.
module LED_Decoder(data, out, mode);
	// ===== Decode the input data to 7-LED
	input   		[3:0] data;
	input   		[1:0] mode;
	output reg  [6:0] out;
	
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
		end else if(mode == 1) begin  // PASS of LOSE
			case(data)
				0 : out <= ~7'b1110011; // P
				1 : out <= ~7'b1110111; // A
				2 : out <= ~7'b1101101; // S
				3 : out <= ~7'b0111111; // O
				4 : out <= ~7'b0111000; // L
				5 : out <= ~7'b1111001; // E
				default : out <= ~7'b0000000; // Waiting Mode
			endcase
		end else if (mode == 2) begin // Run Circle
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
	