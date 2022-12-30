`define MAXHZ 5_000_000 // to 5 Hz :   
module HW1(clk, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLOCK, iIRDA, LEDR, LEDG, SW, KEY);
	
	input 			clk;
	input 			iIRDA;
	input	[3:0]  	KEY;
	input [17:0] 	SW;
	assign rst = KEY[0];
	output VGA_HS, VGA_VS;
	output VGA_BLANK_N,VGA_CLOCK;
	output [7:0] VGA_R,VGA_G,VGA_B;
	
	output 		[7:0] 	LEDG; 
	output 	 	[17:0] 	LEDR;
	
	
	wire 	[31:0] 	IR_Data;
	wire 	[7:0]		keyCode;
	wire 				keyValid;
	wire      		_KEY0, _KEY1, _KEY2, _KEY3;
	reg 	[1:0]		moveR, moveL;
	VGA U1(clk, rst, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B,VGA_BLANK_N,VGA_CLOCK, moveR, moveL);
	
	IR_RECEIVE U2(.iCLK(clk), .iRST_n(rst), .iIRDA(iIRDA), .oDATA_READY(keyValid), .oDATA(IR_Data));
	
	Debounce U3(.clk(clk), .in(KEY[0]), .out(_KEY0));
	Debounce U4(.clk(clk), .in(KEY[1]), .out(_KEY1));
	Debounce U5(.clk(clk), .in(KEY[2]), .out(_KEY2));
	Debounce U6(.clk(clk), .in(KEY[3]), .out(_KEY3));
	
	assign keyCode = IR_Data[23:16];
	assign LEDG = keyCode;
	assign LEDR = {_KEY3, _KEY2, _KEY1, _KEY0};
	wire CLK_50M;
	always@(negedge keyValid)begin
		case(keyCode)
			8'h1A:begin
				moveL = 2;
			end
			8'h1E:begin
				moveL = 1;
			end
			default: moveL = 0;
		endcase
	end
	always@(negedge _KEY2, negedge _KEY3)begin
		if(!_KEY3)
			moveR = 2;
		else if(!_KEY2)
			moveR = 1;
		else
			moveR = 0;
	end
endmodule

module VGA(clk, rst, VGA_HS, VGA_VS ,VGA_R, VGA_G, VGA_B,VGA_BLANK_N,VGA_CLOCK, moveR, moveL);

	input clk, rst;
	output VGA_HS, VGA_VS;
	output reg [7:0] VGA_R,VGA_G,VGA_B;
	output VGA_BLANK_N,VGA_CLOCK;

	reg VGA_HS, VGA_VS;
	reg[10:0] counterHS;
	reg[9:0] counterVS;
	reg [2:0] valid;
	reg clk25M;

	reg [12:0] X,Y;
	
	
	parameter H_FRONT = 16;
	parameter H_SYNC  = 96;
	parameter H_BACK  = 48;
	parameter H_ACT   = 640;//
	parameter H_BLANK = H_FRONT + H_SYNC + H_BACK;
	parameter H_TOTAL = H_FRONT + H_SYNC + H_BACK + H_ACT;

	parameter V_FRONT = 11;
	parameter V_SYNC  = 2;
	parameter V_BACK  = 32;
	parameter V_ACT   = 480;//
	parameter V_BLANK = V_FRONT + V_SYNC + V_BACK;
	parameter V_TOTAL = V_FRONT + V_SYNC + V_BACK + V_ACT;
	assign VGA_SYNC_N = 1'b0;
	assign VGA_BLANK_N = ~((counterHS<H_BLANK)||(counterVS<V_BLANK));
	assign VGA_CLOCK = ~clk25M;

	always@(posedge clk)
		clk25M = ~clk25M;

	always@(posedge clk25M)
	begin
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
	// For Circle
	reg signed [31:0] offsetY = 0, offsetX = 0;
	reg [9:0] 	objX 	= 200;
	reg [9:0] 	objY 	= 160;
	reg [3:0] 	flag 	= 1;
	reg [31:0] 	r 		= 30;
	reg [23:0] colorChange;
	wire  				CLK_5HZ;
	wire 					CLK_square;
	
	Clock C0(clk, 1000000 , CLK_5HZ);
	Clock C1(clk25M, 50000 , CLK_square);
	
	
	reg [23:0] color[3:0];
	
	// For Rectangle Bar
	input [1:0] moveL , moveR;
	reg signed [10:0] offsetR = 0, offsetL = 0;
	reg [10:0] leftSquare = 100, rightSquare = 100;
	
	////////////////////////////////////////////////////
	always@(posedge clk25M)
	begin
		if (!rst) 
		begin
			{VGA_R,VGA_G,VGA_B}<=0;
			
		end
		else 
		begin
			if( ((X - objX) * (X - objX)  + (Y - objY) * (Y - objY)) <= r*r)
				{VGA_R,VGA_G,VGA_B}<= colorChange;
			else if( Y < leftSquare + offsetL  && Y > offsetL && X < 40)
				{VGA_R,VGA_G,VGA_B}<= 24'h194569;
			else if( Y < rightSquare + offsetR && Y > offsetR && X > 600)
				{VGA_R,VGA_G,VGA_B}<= 24'hC44536;
			else
				{VGA_R,VGA_G,VGA_B}<= 24'hFFFFFF;
		end
	end
	
	always @(posedge CLK_square)begin
		case(moveR)
			1:begin
			if(offsetR <= 370)
				offsetR = offsetR + 1;
			end
			2:begin
			if ( offsetR >=  10)
				offsetR = offsetR - 1;
			end
			default:begin
				offsetR = offsetR;
			end
		endcase
		case(moveL)
		
			1:begin
			if(offsetL <= 370)
				offsetL = offsetL + 1;
			end
			2:begin
			if ( offsetL >=  10)
				offsetL = offsetL - 1;
			end
			default:begin
				offsetL = offsetL;
			end
		endcase
	end
	
	always @(posedge CLK_5HZ)begin
		if(!rst)
		begin
			objX = 200;
			objY = 160;
		end
		else
		begin
			objX = objX + offsetX;
			objY = objY + offsetY;
		end
		if(objY < 460-r && objX < 620 - r && objX > r+15 && objY > r+15)begin
			flag = flag;			
		end
		else if(objY <= r+15) begin
			flag= 2;
		end
		else if(objX >= 620 - r)begin
			flag = 3;
		end
		else if(objY >= 460 - r)begin
			flag = 4;
		end
		else if(objX <= r+15)begin
			flag = 1;
		end
	end
	
	always @(posedge CLK_5HZ)begin
		case(flag)
			1:begin
				offsetY = -2;
				offsetX = 3;
				colorChange = color[0];
			end
			2:begin
				offsetY = 2;
				offsetX = 3;
				colorChange = color[1];
			end
			3:begin
				offsetY =2;
				offsetX = -3;
				colorChange = color[2];
			end
			4:begin
				offsetY = -2;
				offsetX = -3;
				colorChange = color[3];
			end
		endcase
	end
	///////////////////////////////////////////
	always@(posedge clk,negedge rst)begin
		if(!rst)begin
			color[0]<=24'h000000;//
			color[1]<=24'h000000;//
			color[2]<=24'h000000;//
			color[3]<=24'h000000;//
		end else begin
			color[0]<=24'h0000ff;//blue
			color[1]<=24'h00ff00;//green
			color[2]<=24'hff0000;//red
			color[3]<=24'h000000;//
		end
	end

endmodule

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
