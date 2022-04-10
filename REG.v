`timescale 1ns / 1ps
module myreg #(parameter init = 32'h00000000)(//�Ĵ�����ʼֵΪ0
    input clk,//������ΪPC�Ĵ�����ֵ
    input rst,//�첽���� �ߵ�ƽ����
            //��ena��Чʱ��rstҲ�������üĴ���
    input ena,//��Ч�źŸߵ�ƽ ��ʱPC�Ĵ�������data_in ��ֵ�����򱣳�ԭ�����
    input [31:0] data_in,//�������ݴ���Ĵ����ڲ�
    output reg [31:0] data_out//�ڲ��洢��ֵ ����ʱ��Ϊ���
    );
    always @ (negedge clk or posedge rst)
    begin
        if(rst==1'b1)
            data_out<=init;
        else if(ena==1'b1)
            data_out<=data_in;
    end
endmodule
