`timescale 1ns / 1ps

module imem(
    input [10:0] addr,
    output[31:0] instr
    );
    dist_mem_gen_0 instr_mem(.a(addr),.spo(instr));
endmodule