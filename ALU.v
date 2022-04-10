`timescale 1ns / 1ps

module ALU(
        input [31:0] a,
        input [31:0] b,
        input [4:0] aluc,
        output [31:0] r,
        output reg zero,
        output reg carry,
        output reg negative,
        output reg overflow
    );

    parameter ADDU = 5'b00001, SUB = 5'b00010, SUBU = 5'b00011,
              AND = 5'b00100, OR = 5'b00101, XOR = 5'b00110, NOR = 5'b00111,
              SLT = 5'b01000, SLTU = 5'b01001, SLL = 5'b01010, SRL = 5'b01011,
              SRA = 5'b01100, SLLV = 5'b01101, SRLV = 5'b01110, SRAV = 5'b01111,
              LUI = 5'b10000, ADD = 5'b10001, CLZ = 5'b10010;

    /*parameter OTHER = 5'b00000, ADDU|ADDIU = 5'b00001, SUB|BGEZ = 5'b00010, SUBU|BNE|BEQ = 5'b00011,
                AND|ANDI = 5'b00100, OR|ORI = 5'b00101, XOR|XORI = 5'b00110, NOR = 5'b00111,
                SLT|SLTI = 5'b01000, SLTU|SLTIU = 5'b01001, SLL = 5'b01010, SRL = 5'b01011,
                SRA = 5'b01100, SLLV = 5b01101, SRLV = 5'b01110, SRAV = 5'b01111, LUI = 5'b10000,
                ADD|ADDI = 5'b10001, CLZ = 5'b10010*/
    wire [31:0] clz_res;
    assign r = aluc==ADD || aluc==ADDU?(a+b):
                aluc==SUB || aluc==SUBU?(a-b):
                aluc==AND ? (a&b):
                aluc==OR  ? (a|b):
                aluc==XOR ? (a^b):
                aluc==NOR ? ~(a|b):
                aluc==SLT ? ($signed(a) < $signed(b)):
                aluc==SLTU? a<b:
                aluc==SLL || aluc==SLLV ? b<<a:
                aluc==SRL || aluc==SRLV ? b>>a:
                aluc==SRA || aluc==SRAV ? $signed($signed(b) >>> a)://要声明为有符号才会自动补最高位
                aluc==LUI ? {b[15:0],16'b0}:
                aluc==CLZ ? clz_res : 32'h0;
    
    CLZCOUNT clzcount(a,clz_res);
    
    always @ (*)
    begin
        //ZF
        zero <= r==0;

        //CF
        if (aluc == ADDU && (a > r || b > r ) || aluc == SUBU && a < b
            || aluc == SLTU && a < b)
            carry <= 1'b1;
        else if ((aluc==SRA || aluc==SRAV || aluc==SRL || aluc==SRLV) && a[3:0]>0) //右移
            carry <= b[a[3:0]-1];
        else if((aluc==SLL || aluc==SLLV)&&a[3:0]>0)//左移
            carry <= b[32-a[3:0]];
        else
            carry <= carry;

        //OF
        if (aluc == ADD && $signed(a) > 0 && $signed(b)>0 && $signed(r) < 0
            || aluc == SUB && $signed(a) < 0 && $signed(b) > 0 && $signed(r) > 0)
            overflow <= 1'b1;
        else
            overflow <= overflow;

        //SF
        if(aluc==SLT)
            negative <= r[0];//SLT本质上是做减法，SF记得要特判
        else
            negative <= r[31];
    end


endmodule
