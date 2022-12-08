


module HW3(iClk,iRST_n,iIRDA, SW, LEDR, LEDG, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, SRAM_ADDR, SRAM_DQ, SRAM_OE_N, SRAM_WE_N, SRAM_CE_N, SRAM_LB_N, SRAM_UB_N);

	input 				iClk, iRST_n, iIRDA;
	inout		[15:0] 	SRAM_DQ;
	input 	[15:0] 	SW;
	
	output 				SRAM_OE_N, SRAM_WE_N, SRAM_CE_N, SRAM_LB_N, SRAM_UB_N;
	output 	[3:0] 	SRAM_ADDR;
	output 	[6:0] 	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output 	[7:0] 	LEDG;
	
	output reg 	[17:0] 		LEDR;
	
	wire 		[31:0] 	IR_Data;
	wire 		[7:0]		keyCode;
	wire 					keyValid;
	
	reg 		[15:0] 	storage;
	reg 		[7:0] 	lowNum;
	reg 					mode;

	IR_RECEIVE U1(.iCLK(iClk), .iRST_n(iRST_n), .iIRDA(iIRDA), .oDATA_READY(keyValid), .oDATA(IR_Data));
	
	SRAM U0(.WE(SRAM_WE_N), .OE(SRAM_OE_N), .CE(SRAM_CE_N), .LB(SRAM_LB_N), .UB(SRAM_UB_N), .DATA(SRAM_DQ), .ADDR(SRAM_ADDR));
	
	
	LED_Decoder U2(.data(storage[3:0]), 	.mode(mode), 	.out(HEX0));
	LED_Decoder U3(.data(storage[7:4]),		.mode(mode), 	.out(HEX1));
	LED_Decoder U4(.data(storage[11:8]), 	.mode(mode), 	.out(HEX2));
	LED_Decoder U5(.data(storage[15:12]), 	.mode(mode), 	.out(HEX3));
	
	LED_Decoder U6(.data(lowNum[3:0]), .mode(mode),		.out(HEX4));
	LED_Decoder U7(.data(lowNum[7:4]), .mode(mode),		.out(HEX5));
	
	assign keyCode = IR_Data[23:16];
	assign LEDG = keyCode;
	
	always @(negedge keyValid) begin
		case (keyCode)
			8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h08, 8'h09:begin // down
				mode = 0;
				storage = {storage[11:0], keyCode[3:0] };
			end
			8'h0F:begin
				mode = 0;
				lowNum = storage[7:0];
			end
			8'h13:begin
				mode = 1;
			end
			default: LEDR = {18{1'b1}};
		endcase
	end
	
endmodule



module SRAM(WE, CE, OE, LB, UB, ADDR, DATA);
	
	
	
	
	
	inout		[15:0] 	DATA;
	
	output	[3:0] 	ADDR;
	output 				WE, CE, OE, LB, UB;
	wire 		[15:0] 	data_in;
	wire 		[15:0] 	data_out;
	
	wire mod;
	
	// H: Read mode ; L: Write mode
	assign WE = !mod; 
	assign OE =  mod;
	
	

endmodule


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
				default: out <= ~7'b0000000;
			endcase
		end else if (mode == 1)begin
			out <= ~7'b0000000;
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
