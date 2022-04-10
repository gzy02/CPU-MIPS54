module MULT(
    input clk, //�˷���ʱ���ź�
    input reset, //��λ�źţ��ߵ�ƽ��Ч
    input [31:0] a, //������a(������)
    input [31:0] b, //������b��������
    output [63:0] z //�˻����z
);
    wire [31:0] tempa,tempb;
    wire [63:0] tempz;
    assign tempa=(a[31]==1'b1)?((~a)+1):a;//ȡ����һ
    assign tempb=(b[31]==1'b1)?((~b)+1):b;
    MULTU multu_uut(.clk(clk),.reset(reset),.a(tempa),.b(tempb),.z(tempz));
    assign z=(a[31]==b[31])?tempz:(~tempz)+1;//ͬ���򲻱䣬�����ȡ����һ

endmodule
