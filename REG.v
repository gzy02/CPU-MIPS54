`timescale 1ns / 1ps
module myreg #(parameter init = 32'h00000000)(//寄存器初始值为0
    input clk,//上升沿为PC寄存器赋值
    input rst,//异步重置 高电平清零
            //当ena无效时，rst也可以重置寄存器
    input ena,//有效信号高电平 此时PC寄存器读入data_in 的值，否则保持原有输出
    input [31:0] data_in,//所有数据存入寄存器内部
    output reg [31:0] data_out//内部存储的值 工作时作为输出
    );
    always @ (negedge clk or posedge rst)
    begin
        if(rst==1'b1)
            data_out<=init;
        else if(ena==1'b1)
            data_out<=data_in;
    end
endmodule
