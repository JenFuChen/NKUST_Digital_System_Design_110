module Average(clk, reset, data, valid, out);
input        clk, reset;
input  [7:0] data;
output reg valid;
output reg[7:0] out;
//===================== Your Design =====================
reg [8:0] sum;
reg [7:0] form1[127:0]; //  存輸入資料
integer cnt = 0,i = 0, j = 0;
//開始存資料
always @(posedge clk)
begin
    if(reset)
    begin
        valid = 1'b0;
        j = 0;
        cnt = 0;
        sum = 9'b000000000;
        out = 8'b00000000;
        for(i = 0 ; i < 128 ;i = i + 1)begin
            form1[i] = 8'b00000000;
        end
    end
    else begin
        valid = 1'b0;
        // 128 筆資料存入
        if(cnt <= 127) begin
            form1[cnt] = data;
            cnt = cnt + 1;
            valid = 1'b0;
        end
        // 存完之後改做這邊
        else begin
            if(j < 120)begin
                sum = form1[j][7:0] + form1[j+8][7:0];
                valid = 1'b1;
                out = (sum >> 1) + sum[0];
                j = j + 1;
            end
        end
    end
end
//===================== Your Design =====================
endmodule
