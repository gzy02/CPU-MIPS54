`timescale 1ns / 1ps

module dmem(
    input clk,
    input ena,
    input wena,
    input [3:0] WFLAG,
    input rena,
    input [31:0] res,//mips上的实际地址 要减去32'h10010000
    input [31:0] data_in,
    output [31:0] data_out//允许写时输出z，允许读时输出读出来的数据
    );
    //reg [31:0] mem [63:0]; //据说对于这个实验已经足够大，太大的存储生成会慢，并且板子资源不一定够用
    
    wire [10:0]addr;
    assign addr=(res-32'h10010000);// (res-32'h10010000)/4;  //由地址找值
    
    reg [7 : 0] mem [1024:0];
    assign data_out = (ena && rena && !wena) ? {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]} : 32'b0;//允许写时要输出z

    always @ (posedge clk)//下降沿有效//本地用上升沿
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