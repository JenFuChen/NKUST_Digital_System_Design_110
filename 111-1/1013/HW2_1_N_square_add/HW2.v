module HW2(CLK, RST, EN, Valid, Order, Sum, temp);
input CLK, RST, EN;
input [3:0] Order;
output [10:0] Sum,temp;
output Valid;

// Finished 1013

reg [10:0] Sum, temp;
reg [1:0] State, NextState;
reg [3:0] counter;
reg Valid;

parameter 	IN = 2'b00,
				ADD = 2'b01,
				OUT = 2'b10;

always @(posedge CLK or posedge RST)
begin
	if(RST)
		State <= IN;
	else 
		State <= NextState;
		
end

always @(posedge CLK)
begin
	if(counter < Order+1 && ! RST)
		begin
			temp = temp + counter*counter;
			counter = counter + 1;
		end
end

always @(*)
begin
	case(State)
		IN:
		begin
			if(EN == 0)
				NextState = IN;
			else
				NextState = ADD;
		end
		ADD:
		begin
			if(counter == Order)
				NextState = OUT;
			else
				NextState = ADD;
		end
		OUT:
		begin
			if(counter == Order)
				NextState = OUT;
			else
				NextState = IN;
		end
	endcase

end

always @(State)
begin
	case(State)
		IN:
			begin 
				Sum =0;
				Valid = 0;
			end
		ADD: 
			begin 
				Sum = 0;
				Valid = 0;
			end
		OUT: 
			begin 
				Sum = temp;
				Valid = 1;
			end
	endcase
end



endmodule
