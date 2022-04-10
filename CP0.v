`timescale 1ns / 1ps
module CP0(
    input clk,
    input rst,
    input mfc0,//指令：读cp0寄存器
    input mtc0,//指令：写cp0寄存器
    input [31:0] pc,//指令地址寄存器
    input [4:0] addr,//要写入cp0寄存器的地址
    input [31:0] wdata,//要写入cp0寄存器的数据
    //input exception,//是否发生异常(这里没有考虑中断屏蔽和中断禁止 如果要做就请加上status[10:8] status[0]的特判)
    input eret,//指令：异常返回
    input [4:0] cause,//cp[13]的[6:2]位
    output [31:0] rdata,//读cp0寄存器时输出的数据
    output [31:0] status,//cp[12] //CPU54里 其实用不到
    output [31:0] exc_addr//cp0[14]，发生异常时为异常入口地址
    );
    
    parameter SYSTCALL_ERR=4'b1000,BREAK_ERR=4'b1001,TEQ_ERR=4'b1101;
    reg [31:0] cp0[31 : 0];//32个32位寄存器
    assign status = cp0[12];
    assign rdata = (mfc0 == 1'b1) ? cp0[addr] : 32'h00000000;//读cp0
    assign exc_addr = (eret == 1'b1) ? cp0[14] : 32'h00400004;//异常入口地址
    wire exception;
    assign exception = (status[0] == 1'b1) && 
                       ((status[1] == 1'b1 && cause == SYSTCALL_ERR) ||
                        (status[2] == 1'b1 && cause == BREAK_ERR) ||
                        (status[3] == 1'b1 && cause == TEQ_ERR));
    always @(negedge clk or posedge rst)//下降沿
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
                cp0[addr] <= wdata;//指令：写cp0寄存器
            else if(exception)//异常发生，中断
            begin
                cp0[12] <= status << 5;//左移五位关中断
                cp0[13] <= {24'b0, cause, 2'b0};
                cp0[14] <= pc;//存放当前指令地址
            end
            else if(eret == 1'b1)
                cp0[12] <= status >> 5;//写回
        end
    end
endmodule
