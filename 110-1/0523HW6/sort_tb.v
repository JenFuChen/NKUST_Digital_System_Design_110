`timescale 1ns/10ps
`define CYCLE 30.0
`define END_CYCEL 100000

`define PAT "./pattern.dat"
`define EXP "./golden.dat"
`define TIMES 10

module sort_tb;
    
    integer pass,err;
    integer times;
    reg [7:0]   pat_mem[0:(`TIMES*6)-1];
    reg [7:0]   exp_mem[0:(`TIMES*6)-1];
    
    reg rst,clk;
    reg state,next_state;
    reg [7:0]   data_counter,ans_counter;
    reg [7:0] data;
    reg data_vaild;
    wire [7:0] sort_data;
    wire vaild;
    

    sort U1 (
        .clk(clk),
        .rst(rst),
        .data_vaild(data_vaild),
        .data(data),
        .vaild(vaild),
        .sort_data(sort_data)
    );
   


    initial begin
        $readmemh(`PAT, pat_mem);
        $readmemh(`EXP, exp_mem); 
    end

    always begin #((`CYCLE)/2) clk = ~clk; end
    initial begin
        err = 0;
        pass =0;
        times=0;
        data_counter = 8'h0;
        ans_counter = 8'h0;
        state = 1'b0;
        next_state = 1'b0;
        clk = 1'b0;
        rst = 1'b0;
        @(posedge clk) #(`CYCLE*0.1)	rst = 1'b1;
		@(negedge clk) #(`CYCLE*1.2)    rst = 1'b0;
        $display("\n");
        $display("                                     _____          ");
        $display("    **************************      /     \\         ");
        $display("    *                        *      vvvvvvv  /|__/|  ");
        $display("    *       START      !!    *         I   / O.O  | ");
        $display("    *                        *         I /_____   | ");
        $display("    *  Simulation Start!!    *        J|/^ ^ ^ \\  |");
        $display("    *                        *         |^ ^ ^ ^ |w| ");
        $display("    **************************          \\m___m__|_|");
        $display("\n");
     end
    
    initial begin
        # (`END_CYCEL*`CYCLE)
        $display("\n");
        $display("    ************************************               ");
        $display("    *                                  *        /|__/| ");
        $display("    *             ERROR!!              *      / X,X  | ");
        $display("    *                                  *    /_____   | ");
        $display("    *  Simulation can't be terminated  *   /^ ^ ^ \\  |");
        $display("    *                                  *  |^ ^ ^ ^ |w| ");
        $display("    ************************************   \\m___m__|_|");
        $display("\n");
 	    $finish;
    end
    
    always@(posedge clk)begin
        if(times == `TIMES)begin
            if(err == 0)begin
                $display("\n");
                $display("        **************************               ");
                $display("        *                        *        /|__/|  ");
                $display("        *     Successful !!      *      / O.O  | ");
                $display("        *                        *    /_____   | ");
                $display("        *  Simulation PASS!!     *   /^ ^ ^ \\  |");
                $display("        *                        *  |^ ^ ^ ^ |w| ");
                $display("        **************************   \\m___m__|_|");
                $display("\n");
            end else begin
                $display("\n");
                $display("        **************************               ");
                $display("        *                        *        /|__/|  ");
                $display("        *  OOPS!!                *      / X,X  | ");
                $display("        *                        *    /_____   | ");
                $display("        *  Simulation Failed!!   *   /^ ^ ^ \\  |");
                $display("        *                        *  |^ ^ ^ ^ |w| ");
                $display("        **************************   \\m___m__|_|");
                $display("         Totally has %d errors                     ", err);
                $display("\n");
            end
            $finish;
        end
    end


    always@(negedge clk)begin
        state = next_state;
    end

    always@(*)begin
        case(state)
            1'b0: next_state = ((data_counter % 6==0) && data_counter != 0)? 1'b1:1'b0;  
            1'b1: next_state = ((ans_counter %6 ==0) && ans_counter !=0)? 1'b0:1'b1;
            default:next_state  =1'b0;
        endcase//(state)
    end

    always@(*)begin
        data = pat_mem[data_counter-1];
        case(state)
            1'b0:data_vaild = (!rst ) ? 1:0;
            default: data_vaild = 0;
        endcase//(state)
    end
    

    always@(negedge clk)begin
        if(!rst)begin
            case(state)
                1'b0: begin
                   data_counter <= data_counter + 1; 
                end
            endcase//(state)
        end
    end

    always@(negedge clk) begin
        case(state)
            1'b1:begin
                if(vaild)begin
                    #(`CYCLE*0.45)
                    if(exp_mem[times*6 + ans_counter] === sort_data)begin
                        pass = pass + 1; 
                    end else begin
                        err = err + 1;
                        $display("Times:%d , expected value : %h !=  receive value : %h " , times+1 ,exp_mem[times*6+ans_counter] , sort_data);
                    end
                    ans_counter = ans_counter + 1;
                    if(ans_counter == 6 ) times <= times +1;
                end
            end
            default:ans_counter= 0;
        endcase//(state)
    end


    



endmodule
