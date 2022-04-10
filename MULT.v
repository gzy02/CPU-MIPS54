module MULT(
    input clk, //乘法器时钟信号
    input reset, //复位信号，高电平有效
    input [31:0] a, //输入数a(被乘数)
    input [31:0] b, //输入数b（乘数）
    output [63:0] z //乘积输出z
);
    wire [31:0] tempa,tempb;
    wire [63:0] tempz;
    assign tempa=(a[31]==1'b1)?((~a)+1):a;//取反加一
    assign tempb=(b[31]==1'b1)?((~b)+1):b;
    MULTU multu_uut(.clk(clk),.reset(reset),.a(tempa),.b(tempb),.z(tempz));
    assign z=(a[31]==b[31])?tempz:(~tempz)+1;//同号则不变，异号则取反加一

endmodule
