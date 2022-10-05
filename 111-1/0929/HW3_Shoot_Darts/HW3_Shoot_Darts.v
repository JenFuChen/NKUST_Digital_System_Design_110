module HW3_Shoot_Darts(x1, x2, x3, x4, y1, y2, y3, y4, A, B, C, D, Max);
input [3:0] x1, x2, x3, x4, y1, y2, y3, y4;
output [2:0] A, B, C, D, Max;
wire [2:0] temp1, temp2;

/*===:==Function=====*/
// Output the Score of 4 group input
Score A1(.x(x1), .y(y1), .score(A));
Score B1(.x(x2), .y(y2), .score(B));
Score C1(.x(x3), .y(y3), .score(C));
Score D1(.x(x4), .y(y4), .score(D));

assign temp1 = A > B ? A : B;
assign temp2 = C > D ? C : D;
assign Max = temp1 > temp2 ? temp1 : temp2;

/*=====End=====*/

endmodule


module Score(x, y, score);
input [3:0] x, y;
output [2:0] score;
reg [2:0] score;

always @(*)
begin
	// Output the score by case function
	case({F1(x,y), F2(x,y), F3(x,y)})// Combine the result of each Function to 6 bit
		6'b101010	: score = 3'd1;
		6'b101001	: score = 3'd2;
		6'b011001	: score = 3'd3;// why
		6'b010101	: score = 3'd4;
		6'b010110	: score = 3'd5;
		6'b100110	: score = 3'd6;
		6'b011010	: score = 3'd7;
		default		: score = 3'd0;
	endcase
end

// Each result of funtion: >0 : 2'b01 ; <0 : 2'b10 ; =0 : 2'b00
function[1:0] F1;// y = -2x + 16
input signed[3:0] x,y;
	if((y + 2*x -16) > 0)
		F1 = 2'b01;
	else if((y + 2*x -16) < 0)
		F1 = 2'b10;
	else
		F1 = 2'b00;
endfunction

function[1:0] F2;// y = 2x - 9  
input signed[3:0] x,y;
	if((-y + 2*x - 9) > 0)
		F2 = 2'b01;
	else if((-y + 2*x + 9) < 0)
		F2 = 2'b10;
	else
		F2 = 2'b00;
endfunction

function[1:0] F3;// y = 10
input signed[3:0] x,y;
	if((y - 10) > 0)
		F3 = 2'b01;
	else if((y - 10) < 0)
		F3 = 2'b10;
	else
		F3 = 2'b00;
endfunction

endmodule

