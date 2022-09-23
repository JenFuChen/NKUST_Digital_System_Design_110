module UpDown(clk, reset, up_down, count);
input         clk;
input         reset;
input         up_down;
output  [3:0] count;

//===================== Your Design =====================
reg [3:0]count;         //暫存器功能

always @(posedge clk)   //正緣觸發CLK
begin
    if(reset)           //如果歸零
        count <= 4'b0000;
    else
        if(up_down == 1'b1)         //判斷上下數，1為上數
            if(count == 4'b1111)
                count <= 4'b1111;
            else
                count <= count + 1;
        else if(up_down == 1'b0)    //0為下數
            if(count == 4'b0000)
                count <= 4'b0000;
            else
                count <= count-1;
end

//===================== Your Design =====================
endmodule