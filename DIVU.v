module DIVU(
    input [31:0]dividend,//被除数
    input [31:0]divisor,//除数
    input start,//启动除法运算   
    input clock,
    input reset,
    output [31:0]q,//商
    output [31:0]r,//余数
    output reg busy,//除法器忙标志位
    output reg done
    );
    wire ready;
    reg[4:0]count;
    reg [31:0] reg_q;
    reg [31:0] reg_r;//余数，初始值为零，随后移位改变
    reg [31:0] reg_b;//除数，计算时改变
    reg busy2,r_sign;
    assign ready = ~busy & busy2;
    wire [32:0] sub_add;    
    assign sub_add = r_sign?({reg_r,reg_q[31]} + {1'b0,reg_b}):({reg_r,reg_q[31]} - {1'b0,reg_b}); //加、减法器

    assign r = r_sign? reg_r + reg_b : reg_r;
    assign q = reg_q;
    
    
    always @(posedge clock or posedge reset)begin
        if (reset == 1) begin //重置
            count <= 5'b0;
            busy <= 0;
            busy2 <= 0;
            reg_r <= 32'b0;
            reg_b <= 32'b0;
            reg_q <= 32'b0;
            done <= 1'b0;
        end else begin
            busy2 <= busy;
            if (start) begin //开始除法运算，初始化
                reg_r <= 32'b0;
                r_sign <= 0;
                reg_q <= dividend;
                reg_b <= divisor;
                count <= 5'b0;
                busy <= 1'b1;
                done <= 1'b0;
            end 
            else if (busy) begin //循环操作
                reg_r <= sub_add[31:0]; //部分余数
                r_sign <= sub_add[32]; //如果为负，下次相加
                reg_q <= {reg_q[30:0],~sub_add[32]};
                count <= count +5'b1; //计数器加一
                if (count == 5'b11111) begin
                    busy <= 0; //结束除法运算
                    done <= 1'b1;
                end
                else done <=1'b0;
            end
            else begin
                done <= 1'b0;
            end
        end
     end
endmodule

 