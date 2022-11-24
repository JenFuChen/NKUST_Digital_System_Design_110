module HW1(clk, SW, KEY, LEDR);
    input clk;
    input [17:0] SW;
    input [3:0] KEY;
    output reg [17:0] LEDR;
	 
    reg [17:0] counter=0, counter2=0, count=0;
    reg _KEY1, _KEY3;
	 
	reg clk5 = 0;
	/// make CLK to  5HZ
    always @(posedge clk) begin
        if(counter2 >= 5_000_000)begin
            counter2 <= 1;
            clk5 <= ~clk5;
        end else begin
            counter2 <= counter2 + 1;
        end
    end
	 
	 /// Clean Button
    always @(posedge clk) begin
        if(count >= 1000)begin
            count <= 0;
            _KEY1 <= KEY[1];
            _KEY3 <= KEY[3];
        end else if(_KEY1 ^ KEY[1] || _KEY3 ^ KEY[3]) count <= count + 1;
        else count <= 0;
    end

	 /// Work
    always @(posedge clk5) begin
		 if(!_KEY1)begin
			counter <= 18'b11_1110_0000_0000_0000;
			LEDR <= ~18'b11_1111_1111_1111_1111;
		 end
       else begin
            if(_KEY3 == 1) begin
                LEDR <= ~18'b000000000000000000;
                
            end
            else begin

            end
       end
    end
endmodule
// case(SW[17:16])
//     2'b00:begin
//         LEDR <= ~ (18'b10_1010_1010_1010_1010);
//         end
//         2'b01:begin
//         if(counter != 0)
//             LEDR <= (counter >> 1);
//         else 
//             counter <= 18'b11_1110_0000_0000_0000;
//         end
//         2'b10:begin

//         end
//         2'b11:begin

//         end
// endcase
