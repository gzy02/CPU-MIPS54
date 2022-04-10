`timescale 1ns / 1ps

module cpu(
    input clk,
    input ena,
    input rst,
    output DM_ena,//CPU�Ƿ��ʹ��
    output DM_W,
    output [3:0] WFLAG,
    output DM_R,
    input [31:0]IM_inst,//ָ��
    input [31:0]DM_rdata,//��������
    output [31:0]DM_wdata,
    output [31:0]PC_out,
    output [31:0]ALU_out
    );

    wire [31:0] instr;  //ָ��
    assign instr=IM_inst;

    //��ָ����Ƭ����
    wire [5:0] op     = instr[31:26];
    wire [4:0] ins_rs = instr[25:21];
    wire [4:0] ins_rt = instr[20:16];
    wire [4:0] ins_rd = instr[15:11];
    wire [4:0] shamt  = instr[10:6];
    wire [5:0] func   = instr[5:0];
    wire [15:0] immediate = instr[15:0];

    wire ADD   = op == 6'b0 && func == 6'b100000;
    wire ADDU  = op == 6'b0 && func == 6'b100001;
    wire SUB   = op == 6'b0 && func == 6'b100010;
    wire SUBU  = op == 6'b0 && func == 6'b100011;
    wire AND   = op == 6'b0 && func == 6'b100100;
    wire OR    = op == 6'b0 && func == 6'b100101;
    wire XOR   = op == 6'b0 && func == 6'b100110;
    wire NOR   = op == 6'b0 && func == 6'b100111;
    wire SLT   = op == 6'b0 && func == 6'b101010;
    wire SLTU  = op == 6'b0 && func == 6'b101011;
    wire SLL   = op == 6'b0 && func == 6'b000000;
    wire SRL   = op == 6'b0 && func == 6'b000010;
    wire SRA   = op == 6'b0 && func == 6'b000011;
    wire SLLV  = op == 6'b0 && func == 6'b000100;
    wire SRLV  = op == 6'b0 && func == 6'b000110;
    wire SRAV  = op == 6'b0 && func == 6'b000111;
    wire JR    = op == 6'b0 && func == 6'b001000;
    wire ADDI  = op == 6'b001000;
    wire ADDIU = op == 6'b001001;
    wire ANDI  = op == 6'b001100;
    wire ORI   = op == 6'b001101;
    wire XORI  = op == 6'b001110;
    wire LW    = op == 6'b100011;
    wire SW    = op == 6'b101011;
    wire BEQ   = op == 6'b000100;
    wire BNE   = op == 6'b000101;
    wire SLTI  = op == 6'b001010;
    wire SLTIU = op == 6'b001011;
    wire LUI   = op == 6'b001111;
    wire J     = op == 6'b000010;
    wire JAL   = op == 6'b000011;

    //extend 23
    wire DIV   = op == 6'b000000 && immediate == 16'b00000_00000_011010;
    wire DIVU  = op == 6'b000000 && ins_rd == 5'b00000 && func == 6'b011011;
    wire MUL   = op == 6'b011100 && shamt == 5'b00000 && func == 6'b000010;//mul rd, rs, rt
    wire MULT  = op == 6'b000000 && shamt == 5'b00000 && func == 6'b011000;
    wire MULTU = op == 6'b000000 && ins_rd == 5'b00000 && func == 6'b011001 && shamt == 5'b00000;
    wire BGEZ  = op == 6'b000001 && ins_rt == 5'b00001;
    wire JALR  = op == 6'b000000 && ins_rt == 5'b00000 && func == 6'b001001;
    wire LBU   = op == 6'b100100;
    wire LHU   = op == 6'b100101;
    wire LB    = op == 6'b100000;
    wire LH    = op == 6'b100001;
    wire SB    = op == 6'b101000;
    wire SH    = op == 6'b101001;
    wire BREAK = op == 6'b000000 && func == 6'b001101;
    wire SYSCALL=op == 6'b000000 && func == 6'b001100;
    wire ERET  = instr == 32'b010000_10000_00000_00000_00000_011000;
    wire MFHI  = op == 6'b000000 && ins_rs == 5'b00000 && ins_rt == 5'b00000 && shamt == 5'b00000 && func == 6'b010000;
    wire MFLO  = op == 6'b000000 && ins_rs == 5'b00000 && ins_rt == 5'b00000 && shamt == 5'b00000 && func == 6'b010010;
    wire MTHI  = op == 6'b000000 && ins_rd == 5'b00000 && ins_rt == 5'b00000 && shamt == 5'b00000 && func == 6'b010001;
    wire MTLO  = op == 6'b000000 && ins_rd == 5'b00000 && ins_rt == 5'b00000 && shamt == 5'b00000 && func == 6'b010011;
    wire MFC0  = op == 6'b010000 && ins_rs == 5'b00000 && shamt  == 5'b00000 && func  == 6'b000000;
    wire MTC0  = op == 6'b010000 && ins_rs == 5'b00100 && shamt  == 5'b00000 && func  == 6'b000000;
    wire CLZ   = op == 6'b011100 && shamt == 5'b00000  && func   == 6'b100000;
    wire TEQ   = op == 6'b000000 && func  == 6'b110100;

    //ALUģ�鼰������
    wire ZF, SF, CF, OF;
    wire [31:0] rd, rs, rt, A, B;
    wire [4:0] ALUC;//ALU��״̬��
    assign ALUC[4]=LUI||ADD||ADDI||CLZ||LW||SW ||LB||SB||LBU||LH||LHU||SH;
    assign ALUC[3]=SLT||SLTU||SLL||SRL||SRA||SLLV||SRLV||SRAV||SLTI||SLTIU;
    assign ALUC[2]=AND||OR||XOR||NOR||SRA||SLLV||SRLV||SRAV||ANDI||ORI||XORI;
    assign ALUC[1]=SUB||SUBU||XOR||NOR||SLL||SRL||SRLV||SRAV||XORI||BEQ||BNE||BGEZ||CLZ||TEQ;
    assign ALUC[0]=ADDU||SUBU||OR||NOR||SLTU||SRL||SLLV||SRAV||ADDIU||BEQ||BNE||SLTIU||ORI||ADD||ADDI||LW||SW ||LB||SB||LBU||LH||LHU||SH||TEQ;
    /*parameter OTHER = 5'b00000, ADDU|ADDIU = 5'b00001, SUB|BGEZ = 5'b00010, SUBU|BNE|BEQ|TEQ = 5'b00011,
                AND|ANDI = 5'b00100, OR|ORI = 5'b00101, XOR|XORI = 5'b00110, NOR = 5'b00111,
                SLT|SLTI = 5'b01000, SLTU|SLTIU = 5'b01001, SLL = 5'b01010, SRL = 5'b01011,
                SRA = 5'b01100, SLLV = 5b01101, SRLV = 5'b01110, SRAV = 5'b01111,LUI = 5'b10000,
                ADD||ADDI||LW||SW||LB||SB||LBU||LH||LHU||SH = 5'b10001, CLZ = 5'b10010
                */

    assign A = (SLL || SRL || SRA) ? shamt : rs;
    assign B = BGEZ ? 0 : (ADDIU || ADDI || LW || SW || SLTI || SLTIU || LB ||SB || LBU || LH || LHU || SH) ? {{16{immediate[15]}},immediate[15:0]} ://�з�����չ
    (ANDI || ORI || XORI || LUI) ? immediate : rt;//�޷�����չ

    ALU alu(.a(A),
           .b(B),
           .aluc(ALUC),
           .r(ALU_out),
           .zero(ZF),
           .carry(CF),
           .negative(SF),
           .overflow(OF)
        );

    //�˷�ģ��
    wire [31:0] multu_lo,multu_hi;
    wire [63:0] multu_res;
    assign multu_lo=multu_res[31:0];
    assign multu_hi=multu_res[63:32];
    MULTU mymultu(.clk(clk),.reset(rst),.a(A),.b(B),.z(multu_res));

    wire [31:0] mult_lo,mult_hi;
    wire [63:0] mult_res;
    assign mult_lo=mult_res[31:0];
    assign mult_hi=mult_res[63:32];
    MULT mymult(.clk(clk),.reset(rst),.a(A),.b(B),.z(mult_res));


    //����ģ��,ע����Ҫ32�����ڲ������꣡����
    wire [31:0] divu_lo,divu_hi;
    wire busyDIVU,startDIVU,doneDIVU;
    assign startDIVU=DIVU && ~busyDIVU && !doneDIVU;
    DIVU mydivu(
        .dividend(A),
        .divisor(B),
        .start(startDIVU),
        .clock(~clk),//���������½���
        .reset(rst),
        .q(divu_lo),
        .r(divu_hi),
        .busy(busyDIVU),
        .done(doneDIVU)
        );
    wire [31:0] div_lo,div_hi;
    wire busyDIV,startDIV,doneDIV;
    assign startDIV=DIV && ~busyDIV && !doneDIV;
    DIV mydiv(
        .dividend(A),
        .divisor(B),
        .start(startDIV),
        .clock(~clk),//���������½���
        .reset(rst),
        .q(div_lo),
        .r(div_hi),
        .busy(busyDIV),
        .done(doneDIV)
        );

    //LO HI �Ĵ���ģ��
    wire [31:0] teplo,tephi;//��ʱlo,hi
    wire [31:0] finlo,finhi;//����lo,hi�Ĵ�����ֵ���̣�lo  ;������hi
    assign teplo = MULTU ? multu_lo : MULT||MUL ? mult_lo : doneDIVU ? divu_lo : doneDIV ? div_lo : MTLO ? rs : 32'b0;
    assign tephi = MULTU ? multu_hi : MULT||MUL ? mult_hi : doneDIVU ? divu_hi : doneDIV ? div_hi : MTHI ? rs : 32'b0;
    wire enalo,enahi;
    assign enalo=doneDIV||doneDIVU||MTLO||MULTU||MULT||MUL;//дlo
    assign enahi=doneDIV||doneDIVU||MTHI||MULTU||MULT||MUL;//дhi
    myreg reg_lo(clk, rst, enalo, teplo, finlo);//finlo������lo�Ĵ�����ֵ
    myreg reg_hi(clk, rst, enahi, tephi, finhi);//finhi������hi�Ĵ�����ֵ

    //CP0ģ��
    //parameter SYSTCALL_ERR=4'b1000,BREAK_ERR=4'b1001,TEQ_ERR=4'b1101;
    wire [4:0] cause;
    wire [31:0] rdata,status,exc_addr;
    assign cause = SYSCALL ? 4'b1000 : BREAK ? 4'b1001 : TEQ && ZF ? 4'b1101 : 4'b0000;
    
    wire [31:0] PC,NPC;
    CP0 mycp0(.clk(clk),
              .rst(rst),
              .mfc0(MFC0),
              .mtc0(MTC0),
              .pc(PC),
              .addr(ins_rd),//MFC0 MTC0��rt��ֵд��CP0��rd
              .wdata(rt),
              //.exception(),
              .eret(ERET),
              .cause(cause),
              .rdata(rdata),
              .status(status),
              .exc_addr(exc_addr)
        );
        
    //PC�Ĵ���ģ�鼰�����
    wire [31:0] PC_Res; //ָ����������PC
    assign NPC = PC + 4;
    assign PC_Res = (busyDIV||busyDIVU||doneDIV||doneDIVU) ? PC : //������æ(32),����������(1)�����޷����µ�ָ��,Ҫ�ͺ�33����
                    (SYSCALL||ERET||BREAK||(TEQ && ZF)) ? exc_addr : //��ȷ���Բ��ԣ����������������������� û��ͨ��mars������
                    JALR ? rs :
                    (JAL || J) ? {PC[31:28], instr[25:0], 2'b00} : JR ? rs :
                    (BEQ && ZF) || (BNE && !ZF) || (BGEZ && !SF) ?//BGEZ��SUBָͬ��ж�SFΪ0����֤��rs>=0
                    NPC + {{14{immediate[15]}}, immediate[15:0], 2'b0} : NPC;
    myreg #(32'h00400000) mypcreg(clk,rst,ena,PC_Res,PC);//�½��ظ��£���0x00400000��ʼ //�����ز��Ե�ʱ����posedge!!!!!!!!!!
    
    //regfileģ�鼰�����
    wire rf_wena = !(JR || SW || BEQ || BNE || J || BGEZ || DIV || DIVU || MTLO || MTHI || MULT ||MULTU || MTC0 || SH || SB);// || ALUC==5'b00000);//�Ƿ�����д,���г��Ķ��ǲ�����д�� MUL����д
    wire [4:0] rd_addr;//Ҫд��ļĴ�����ַ
    
    //������������ָ���Լ�MFC0��д��regfile�ĵ�ַ��rt��
    assign rd_addr = JAL ? 5'b11111 : (ADDI || ADDIU || ANDI || ORI || XORI || LW || MFC0 ||
                                     SLTI || SLTIU || LUI || LBU || LB || LH || LHU) ? ins_rt : ins_rd;
    assign rd = MUL ? mult_lo : MFC0 ? rdata : MFLO ? finlo : MFHI ? finhi : JAL || JALR ? PC + 4 :
                LW ? DM_rdata : LB ? {{24{DM_rdata[7]}},DM_rdata[7:0]} : LBU ? {24'b0,DM_rdata[7:0]} :
                LH ? {{16{DM_rdata[15]}},DM_rdata[15:0]} : LHU ? {16'b0,DM_rdata[15:0]} : ALU_out;//Ҫд���ֵ

    regfile cpu_ref(
        .clk(clk),
        .ena(ena),//�����ena��Ϊ0ʱ�������޸ļĴ����ѵ�ֵ
        .rst(rst),//�첽���� �ߵ�ƽ����
        .write_ena(rf_wena),//�Ƿ�����д
        .rd_addr(rd_addr),//Ҫд��ļĴ�����ַ
        .rs_addr(ins_rs),
        .rt_addr(ins_rt),
        .rd(rd),//Ҫд���ֵ
        .rs(rs),//��ʱ��������ɼĴ�����ַ�ҵ��ļĴ���ֵ����ͬ
        .rt(rt)
        );
    
    //CPUģ����������
    assign DM_ena=1'b1;
    assign DM_wdata = SW ? rt : SB ? {24'b0,rt[7:0]}: SH ? {16'b0,rt[15:0]}: 32'b0;
    assign PC_out=PC;
    assign DM_R=LW || LBU || LB || LH || LHU;
    assign DM_W=SW || SB || SH;
    assign WFLAG = SW ? 4'b1111 : 
                   SB ? 4'b0001 : 
                   SH ? 4'b0011 : 4'b0000;
endmodule
