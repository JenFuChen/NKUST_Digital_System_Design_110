// use switch to control LED

module HW1(SW, LEDR);

input [15:0] SW;
output reg [15:0] LEDR;

always@(*) begin

	LEDR = SW;
	
end


endmodule