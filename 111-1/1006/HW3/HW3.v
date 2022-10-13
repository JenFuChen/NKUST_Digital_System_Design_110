module HW3(CLK, RST, En, Valid, num, out);
// Finished
integer count = 0, i = 0, j = 1; 

input CLK, RST, En;
input [3:0] num;
output [39:0] out;
output Valid;

reg [3:0] data[0:9], temp;
reg [3:0] odd[0:9], even[0:9];
reg [39:0] out;
reg Valid;

always @(posedge CLK)
begin
	if(RST)
		begin
			out = 40'd0;
			Valid = 1'd0;
		end
	else if(En && count <= 9)
		begin
			if(num != 0)
				data[count] = num;
			else
				data[count] = 0;
			count = count + 1;
		end
	else
		begin
			if(count > 9 && count <20 ) 
			begin
				for(i = 0 ; i < 10 ; i = i + 1)
				begin
					for(j = i ; j < 10; j = j + 1)
					begin
						if(data[i][0] == 0 && data[j][0] == 0 && data[i] > data[j] && data[i] != 0 && data[j] != 0)
						begin
								temp = data[i];
								data[i] = data[j];
								data[j] = temp;
						end
					end
				end
			end
			else
			begin
				out = {data[0],data[1],data[2],data[3],data[4],data[5],data[6],data[7],data[8],data[9]};
				if(count == 22)
					Valid = 1;
			end
			count = count + 1;
	end
end
endmodule
