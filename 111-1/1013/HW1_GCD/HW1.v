module HW1(CLK, RST, EN, Valid, A, B, outcome);
input CLK, RST, EN;
input [7:0] A, B;
output [10:0] outcome;
output Valid;



reg [7:0] D,E,F;
reg [10:0] outcome;
reg [1:0] State, NextState;
reg Valid;

parameter 	IN = 2'b00,
				DIV = 2'b01,
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
	case(State)
		IN:
			begin
				if(EN == 1)
					begin
						D = A > B ? A : B;
						E = B > A ? A : B;
						F  = D - E;
					end
			end
		DIV:
			begin
				F = D - E;
				if(F < E)
					begin
						D = E;
						E = F;
					end
				else
					begin
						D = F;
					end
			end
		OUT:
			F = 0 ;
		endcase
end

always @(*)
begin
	case(State)
		IN:
		begin
			if(EN == 1)
				NextState = IN;
			else
				NextState = DIV;
		end
		DIV:
		begin
			if(F == 0)
				NextState = OUT;
			else
				NextState = DIV;
		end
		OUT:
		begin
			if(F == 0 && EN == 0)
				NextState = OUT;
			else if (EN == 1)
				NextState = IN;
		end
	endcase

end

always @(State)
begin
	case(State)
		IN:
			begin 
				outcome = 0;
				Valid = 0;
			end
		DIV: 
			begin 
				outcome = F;
				Valid = 0;
			end
		OUT: 
			begin 
				outcome = F;
				Valid = 1;
			end
	endcase
end



endmodule
