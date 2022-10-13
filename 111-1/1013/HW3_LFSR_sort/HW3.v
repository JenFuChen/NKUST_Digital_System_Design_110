module HW3(CLK, RST, out, temp);
input CLK,RST;
output [7:0] out[0:7], temp;

reg [7:0] out[0:7], temp;
// Building
always @(posedge CLK)
begin
	if(RST)
		out = 8'hF1;
		temp = 8'hF1;
	else
		temp = {temp[1:0],temp[0]^temp[2]}


end



endmodule
