module hw7(clk_in,clr,clk_out);
input clk_in,clr;
output clk_out;
reg [3:0]cnt_p,cnt_n;
reg clk_p,clk_n;

assign clk_out = clk_n | clk_p;
// Finished
always@(posedge clk_in)begin
if(clr)  
 cnt_p <= 4'd0;
else if(cnt_p==4'd10)
 cnt_p <= 4'd0;
else   
 cnt_p <= cnt_p + 4'd1;
end
always@(posedge clk_in)begin
if(clr)  
 clk_p <= 4'd0;
else if(cnt_p < 4'd5)  
 clk_p <= 4'd1;
else   
 clk_p <= 4'd0;
end
always@(negedge clk_in)begin
if(clr)  
 cnt_n <= 4'd0;
else if(cnt_n==4'd10)
 cnt_n <= 4'd0;
else   
 cnt_n <= cnt_n + 4'd1;
end
always@(negedge clk_in)begin
if(clr)  
 clk_n <= 4'd0;
else if(cnt_p < 4'd5)  
 clk_n <= 4'd1;
else   
 clk_n <= 4'd0;
end
 
endmodule