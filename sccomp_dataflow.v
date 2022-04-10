module sccomp_dataflow(
    input clk_in,
    input reset,
    //input [15:0] sw,
    output [7:0] o_seg,
    output [7:0] o_sel
    /*output [31:0] inst,
    output [31:0] res,
    output [31:0] r_data,
    output [31:0] w_data,
    output [31:0] pc*/
);
    //wire clk_in;
    
    wire [31:0] pc,inst;
    wire dw,dr,dena;
    wire [31:0]w_data,r_data;
    wire [31:0]instr,res;
    wire [31:0]im_addr;
    wire [3:0] WFLAG;
    assign inst=instr;
    assign im_addr=pc-32'h00400000;
    imem imemory(
        .addr(im_addr[12:2]),
        .instr(instr)
    );/*Ö¸Áî´æ´¢Æ÷*/
    dmem dmemory(
        .clk(clk_in),
        .ena(1'b1),
        .wena(dw),
        .WFLAG(WFLAG),
        .rena(dr),
        .res(res),
        .data_in(w_data),
        .data_out(r_data)
    );/*Êý¾Ý´æ´¢Æ÷*/
    cpu sccpu(
        .clk(clk_in),
        .ena(1'b1),
        .rst(reset),
        .IM_inst(instr),
        .DM_rdata(r_data),//¸Ä
        .DM_ena(dena),
        .DM_W(dw),
        .WFLAG(WFLAG),
        .DM_R(dr),
        .DM_wdata(w_data),
        .PC_out(pc),
        .ALU_out(res)
    );

    //wire seg7_cs,switch_cs,DM_CS;
    //assign DM_CS=1;
    //wire seg7_cs;
    //assign seg7_cs=1;
    //clk_div cpu_clk(clk,10,clk_in);/*·ÖÆµ*/
    //io_sel io_mem(res, DM_CS, dw, dr, seg7_cs, switch_cs);
    //sw_mem_sel sw_mem(switch_cs, sw, r_data, rdata);
    seg7x16 seg7(clk_in, reset, 1'b1, pc, o_seg, o_sel);

endmodule
