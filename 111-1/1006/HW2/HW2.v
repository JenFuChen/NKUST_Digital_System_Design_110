module HW2(clk,rst,a,b,c,d);
input clk,rst;
input [ 7: 0] a,b;
output [7:0] c,d;
reg [7:0] c, d;
reg [7:0] ans, mod;
integer i = 0;
always@(posedge clk)
begin
	if(rst)
	begin
		c <= 0;
		d <= 0;
	end
	else
	begin
		if(i == 0)
		begin
			c <= a;
			d <= 0;
		end
		else
		begin
			if(i>= 1&& i < 10)
			begin
				if(b > mod)
				begin
					d <= d << 1;
					c <= c << 1;
				end
				else
				begin
					
					d <= d - b;
					d <= d << 1;
					d <= d +1;
					c <= c << 1;
					c <= c +1;
					
				end
			end
			else
			begin
				c <= c >> 1;
				d <= d >> 1;
			end
		end
		i = i + 1;
		
		
	end

end



endmodule
