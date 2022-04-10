`timescale 1ns / 1ps

module dmem(
    input clk,
    input ena,
    input wena,
    input [3:0] WFLAG,
    input rena,
    input [31:0] res,//mips�ϵ�ʵ�ʵ�ַ Ҫ��ȥ32'h10010000
    input [31:0] data_in,
    output [31:0] data_out//����дʱ���z�������ʱ���������������
    );
    //reg [31:0] mem [63:0]; //��˵�������ʵ���Ѿ��㹻��̫��Ĵ洢���ɻ��������Ұ�����Դ��һ������
    
    wire [10:0]addr;
    assign addr=(res-32'h10010000);// (res-32'h10010000)/4;  //�ɵ�ַ��ֵ
    
    reg [7 : 0] mem [1024:0];
    assign data_out = (ena && rena && !wena) ? {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]} : 32'b0;//����дʱҪ���z

    always @ (posedge clk)//�½�����Ч//������������
    begin
        if (ena && wena)
        begin
            //mem[addr] <= data_in;
            mem[addr + 3] <= WFLAG[3] ? data_in[31:24] : mem[addr + 3];
            mem[addr + 2] <= WFLAG[2] ? data_in[23:16] : mem[addr + 2];
            mem[addr + 1] <= WFLAG[1] ? data_in[15:8]  : mem[addr + 1];
            mem[addr]     <= WFLAG[0] ? data_in[7:0]   : mem[addr];    
        end
    end
endmodule