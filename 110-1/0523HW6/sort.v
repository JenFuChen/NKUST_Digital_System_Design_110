module sort (
    input   clk,
    input   rst,
    input   data_vaild,
    input   [7:0]   data,
    output  reg vaild,
    output  reg[7:0]   sort_data
);
    
//===================== Your Design =====================
reg [7:0] form[9:0][5:0],temp;
integer i , j,cnt,k,cnt2;
always @(posedge clk)
begin
    if(rst)
    begin
        vaild <= 0;
        sort_data <= 8'b00000000;
        cnt <= 0;
        j <= 0;
        k <= 0;
        cnt <= 0;
        cnt2 <= 0;
        temp = 8'b00000000;
        for(i = 0 ; i < 10 ; i = i + 1)begin
            for(j = 0 ; j < 6; j = j + 1)
                form[i][j] <= 8'b00000000;
        end
    end
    else 
    begin
        if(cnt < 60)
        begin
            form[cnt/6][cnt%6] <= data;
            cnt <= cnt + 1;
            vaild <= 1'b0;
        end
        else
        begin
            // if(i < 10)begin
            //     vaild <= 1'b0;
            //     if(form[i][j] > form[i][k])begin
            //         temp <= form[i][k];
            //         form[i][k] <= form[i][j];
            //         form[i][j] <= temp;
            //     end
            //     i <= (cnt- 60)/6;
            //     j <= (cnt - 60)%6;
            //     k <= j+1;
            //     cnt <= cnt + 1;
            // end
            // else
            // begin
            for(i = 0 ; i < 60 ;i = i + 1)begin
                sort_data <= form[i/6][i%6];
                vaild <= 1'b1;
            end
            // end
        end
    end
end

//===================== Your Design =====================


endmodule

