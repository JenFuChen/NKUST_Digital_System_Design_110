module GCC(READY_, Xc, Yc, Xi, Yi, Wi, RESET_, CLK);
input CLK, RESET_;
input [7:0] Xi, Yi;
input [3:0] Wi;
output READY_;
output [7:0] Xc, Yc;

reg READY_, delay;
reg [7:0] Xc, Yc;

reg [7:0] X_tmp[0:5];
reg [7:0] Y_tmp[0:5];
reg [3:0] W_tmp[0:5];

reg rm_valid;
reg [2:0] num, rm_num;
reg [16:0] distance[0:5];
reg [16:0] max_dis;
reg same_dis[0:5];

wire [14:0] XW_sum = X_tmp[0] * W_tmp[0] + X_tmp[1] * W_tmp[1] + X_tmp[2] * W_tmp[2] + X_tmp[3] * W_tmp[3] + X_tmp[4] * W_tmp[4] + X_tmp[5] * W_tmp[5];
wire [14:0] YW_sum = Y_tmp[0] * W_tmp[0] + Y_tmp[1] * W_tmp[1] + Y_tmp[2] * W_tmp[2] + Y_tmp[3] * W_tmp[3] + Y_tmp[4] * W_tmp[4] + Y_tmp[5] * W_tmp[5];
wire [6:0] W_sum = W_tmp[0] + W_tmp[1] + W_tmp[2] + W_tmp[3] + W_tmp[4] + W_tmp[5];

wire [7:0] Xc_n = (XW_sum + W_sum[6:1]) / W_sum;
wire [7:0] Yc_n = (YW_sum + W_sum[6:1]) / W_sum;

integer i, j;

always@(posedge CLK, negedge RESET_)begin
    if(!RESET_)begin
        for(i = 0; i < 6; i = i + 1)begin
            X_tmp[i] <= 8'd0;
            Y_tmp[i] <= 8'd0;
            W_tmp[i] <= 4'd0;
        end
    end
    else begin
        if(rm_valid)begin
            X_tmp[rm_num] <= Xi;
            Y_tmp[rm_num] <= Yi;
            W_tmp[rm_num] <= Wi;
        end
        else begin
            X_tmp[num] <= Xi;
            Y_tmp[num] <= Yi;
            W_tmp[num] <= Wi;
        end
    end
end

always@(posedge CLK, negedge RESET_)begin
    if(!RESET_)begin
        READY_ <= 1'b1;
        delay <= 1'b1;
        Xc <= 8'd0;
        Yc <= 8'd0;
        num <= 3'd0;
        rm_valid <= 1'b0;
    end
    else begin
        Xc <= Xc_n;
        Yc <= Yc_n;
        delay <= 1'b0;
        READY_ <= delay;
        if(num < 3'd6) num <= num + 1'd1;
        if(num > 3'd4) rm_valid <= 1'b1;
    end
end

always@(*)begin
    rm_num = 3'bZZZ;
    if(rm_valid)begin
        for(j = 0; j < 6; j = j + 1)begin
            distance[j] = (X_tmp[j] - Xc_n) * (X_tmp[j] - Xc_n) + (Y_tmp[j] - Yc_n) * (Y_tmp[j] - Yc_n);
        end
        max_dis = distance[0];
        rm_num = 3'd0;
        for(j = 1; j < 6; j = j + 1)begin
            if(max_dis < distance[j])begin
                max_dis = distance[j];
                rm_num = j;
            end
        end
    end
end
endmodule
