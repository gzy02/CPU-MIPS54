
`timescale 1ns / 1ps
module regfile(
    input clk,
    input rst,//异步重置 高电平清零
    input ena,//整体的ena，为0时不允许修改寄存器堆的值
    input write_ena,//是否允许写
    input [4:0] rd_addr,//要写入的寄存器地址
    input [4:0] rs_addr,
    input [4:0] rt_addr,
    input [31:0] rd,//要写入的值
    output [31:0] rs,//由寄存器地址找寄存器值
    output [31:0] rt
);
    wire [31:0] Ena32; //对于32个寄存器，哪个允许写
    wire [31:0] array_reg[31:0];
    //wire [1023:0] array_reg;

    assign Ena32 = (write_ena && rd_addr && ena) ? (1 << rd_addr) : 32'h00000000; //0号寄存器不可写入!
    /*
    genvar i;
    generate//避免重复写32行
        for(i = 0; i < 32; i = i + 1)
        begin : Regfiles
            myreg myregfile(clk, rst, Ena32[i], rd, array_reg[i]);//作业要求时钟下降沿写入
        end
    endgenerate*/
    myreg myregfile1(clk, rst, Ena32[0], rd, array_reg[0]);
    myreg myregfile2(clk, rst, Ena32[1], rd, array_reg[1]);
    myreg myregfile3(clk, rst, Ena32[2], rd, array_reg[2]);
    myreg myregfile4(clk, rst, Ena32[3], rd, array_reg[3]);
    myreg myregfile5(clk, rst, Ena32[4], rd, array_reg[4]);
    myreg myregfile6(clk, rst, Ena32[5], rd, array_reg[5]);
    myreg myregfile7(clk, rst, Ena32[6], rd, array_reg[6]);
    myreg myregfile8(clk, rst, Ena32[7], rd, array_reg[7]);
    myreg myregfile9(clk, rst, Ena32[8], rd, array_reg[8]);
    myreg myregfile10(clk, rst, Ena32[9], rd, array_reg[9]);
    myreg myregfile11(clk, rst, Ena32[10], rd, array_reg[10]);
    myreg myregfile12(clk, rst, Ena32[11], rd, array_reg[11]);
    myreg myregfile13(clk, rst, Ena32[12], rd, array_reg[12]);
    myreg myregfile14(clk, rst, Ena32[13], rd, array_reg[13]);
    myreg myregfile15(clk, rst, Ena32[14], rd, array_reg[14]);
    myreg myregfile16(clk, rst, Ena32[15], rd, array_reg[15]);
    myreg myregfile17(clk, rst, Ena32[16], rd, array_reg[16]);
    myreg myregfile18(clk, rst, Ena32[17], rd, array_reg[17]);
    myreg myregfile19(clk, rst, Ena32[18], rd, array_reg[18]);
    myreg myregfile20(clk, rst, Ena32[19], rd, array_reg[19]);
    myreg myregfile21(clk, rst, Ena32[20], rd, array_reg[20]);
    myreg myregfile22(clk, rst, Ena32[21], rd, array_reg[21]);
    myreg myregfile23(clk, rst, Ena32[22], rd, array_reg[22]);
    myreg myregfile24(clk, rst, Ena32[23], rd, array_reg[23]);
    myreg myregfile25(clk, rst, Ena32[24], rd, array_reg[24]);
    myreg myregfile26(clk, rst, Ena32[25], rd, array_reg[25]);
    myreg myregfile27(clk, rst, Ena32[26], rd, array_reg[26]);
    myreg myregfile28(clk, rst, Ena32[27], rd, array_reg[27]);
    myreg myregfile29(clk, rst, Ena32[28], rd, array_reg[28]);
    myreg myregfile30(clk, rst, Ena32[29], rd, array_reg[29]);
    myreg myregfile31(clk, rst, Ena32[30], rd, array_reg[30]);
    myreg myregfile32(clk, rst, Ena32[31], rd, array_reg[31]);

    assign rs=ena?array_reg[rs_addr]:32'b0;
    assign rt=ena?array_reg[rt_addr]:32'b0;
    //assign rs=ena?array_reg[ {rs_addr, 5'b11111} -: 32]:32'bz;
    //assign rt=ena?array_reg[ {rt_addr, 5'b11111} -: 32]:32'bz;

endmodule
