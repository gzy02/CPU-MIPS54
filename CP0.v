`timescale 1ns / 1ps
module CP0(
    input clk,
    input rst,
    input mfc0,//ָ���cp0�Ĵ���
    input mtc0,//ָ�дcp0�Ĵ���
    input [31:0] pc,//ָ���ַ�Ĵ���
    input [4:0] addr,//Ҫд��cp0�Ĵ����ĵ�ַ
    input [31:0] wdata,//Ҫд��cp0�Ĵ���������
    //input exception,//�Ƿ����쳣(����û�п����ж����κ��жϽ�ֹ ���Ҫ���������status[10:8] status[0]������)
    input eret,//ָ��쳣����
    input [4:0] cause,//cp[13]��[6:2]λ
    output [31:0] rdata,//��cp0�Ĵ���ʱ���������
    output [31:0] status,//cp[12] //CPU54�� ��ʵ�ò���
    output [31:0] exc_addr//cp0[14]�������쳣ʱΪ�쳣��ڵ�ַ
    );
    
    parameter SYSTCALL_ERR=4'b1000,BREAK_ERR=4'b1001,TEQ_ERR=4'b1101;
    reg [31:0] cp0[31 : 0];//32��32λ�Ĵ���
    assign status = cp0[12];
    assign rdata = (mfc0 == 1'b1) ? cp0[addr] : 32'h00000000;//��cp0
    assign exc_addr = (eret == 1'b1) ? cp0[14] : 32'h00400004;//�쳣��ڵ�ַ
    wire exception;
    assign exception = (status[0] == 1'b1) && 
                       ((status[1] == 1'b1 && cause == SYSTCALL_ERR) ||
                        (status[2] == 1'b1 && cause == BREAK_ERR) ||
                        (status[3] == 1'b1 && cause == TEQ_ERR));
    always @(negedge clk or posedge rst)//�½���
    begin
        if(rst == 1'b1)
        begin
            cp0[0] <= 32'b0; cp0[1] <= 32'b0; cp0[2] <= 32'b0; cp0[3] <= 32'b0;
            cp0[4] <= 32'b0; cp0[5] <= 32'b0; cp0[6] <= 32'b0; cp0[7] <= 32'b0;
            cp0[8] <= 32'b0; cp0[9] <= 32'b0; cp0[10] <= 32'b0; cp0[11] <= 32'b0;
            cp0[12] <= 32'b0; cp0[13] <= 32'b0; cp0[14] <= 32'b0; cp0[15] <= 32'b0;
            cp0[16] <= 32'b0; cp0[17] <= 32'b0; cp0[18] <= 32'b0; cp0[19] <= 32'b0;
            cp0[20] <= 32'b0; cp0[21] <= 32'b0; cp0[22] <= 32'b0; cp0[23] <= 32'b0;
            cp0[24] <= 32'b0; cp0[25] <= 32'b0; cp0[26] <= 32'b0; cp0[27] <= 32'b0;
            cp0[28] <= 32'b0; cp0[29] <= 32'b0; cp0[30] <= 32'b0; cp0[31] <= 32'b0;
        end
        else
        begin
            if(mtc0 == 1'b1)
                cp0[addr] <= wdata;//ָ�дcp0�Ĵ���
            else if(exception)//�쳣�������ж�
            begin
                cp0[12] <= status << 5;//������λ���ж�
                cp0[13] <= {24'b0, cause, 2'b0};
                cp0[14] <= pc;//��ŵ�ǰָ���ַ
            end
            else if(eret == 1'b1)
                cp0[12] <= status >> 5;//д��
        end
    end
endmodule
