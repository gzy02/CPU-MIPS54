`timescale 1ns / 1ps
module MULTU(
    input clk,      //乘法器时钟信号
    input reset,    //复位信号，高电平有效
    input [31:0] a, //输入数a(被乘数）
    input [31:0] b, //输入数b（乘数）
    output [63:0] z //乘积输出z
    );
    
    wire [63:0] P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31;
    wire [63:0] S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20,S21,S22,S23,S24,S25,S26,S27,S28,S29;
    wire [63:0] C0,C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29;
    
    assign P0 = b[0]?a:4'b0;
    assign P1 = b[1]?a<<1:4'b0;
    assign P2 = b[2]?a<<2:4'b0;
    assign P3 = b[3]?a<<3:4'b0;
    assign P4 = b[4]?a<<4:4'b0;
    assign P5 = b[5]?a<<5:4'b0;
    assign P6 = b[6]?a<<6:4'b0;
    assign P7 = b[7]?a<<7:4'b0;
    assign P8 = b[8]?a<<8:4'b0;
    assign P9 = b[9]?a<<9:4'b0;
    assign P10 = b[10]?a<<10:4'b0;
    assign P11 = b[11]?a<<11:4'b0;
    assign P12 = b[12]?a<<12:4'b0;
    assign P13 = b[13]?a<<13:4'b0;
    assign P14 = b[14]?a<<14:4'b0;
    assign P15 = b[15]?a<<15:4'b0;
    assign P16 = b[16]?a<<16:4'b0;
    assign P17 = b[17]?a<<17:4'b0;
    assign P18 = b[18]?a<<18:4'b0;
    assign P19 = b[19]?a<<19:4'b0;
    assign P20 = b[20]?a<<20:4'b0;
    assign P21 = b[21]?a<<21:4'b0;
    assign P22 = b[22]?a<<22:4'b0;
    assign P23 = b[23]?a<<23:4'b0;
    assign P24 = b[24]?a<<24:4'b0;
    assign P25 = b[25]?a<<25:4'b0;
    assign P26 = b[26]?a<<26:4'b0;
    assign P27 = b[27]?a<<27:4'b0;
    assign P28 = b[28]?a<<28:4'b0;
    assign P29 = b[29]?a<<29:4'b0;
    assign P30 = b[30]?a<<30:4'b0;
    assign P31 = b[31]?a<<31:4'b0;
    
    F_adder M0(.ain(P0),.bin(P1),.cin(P2),.sum(S0),.cout(C0));
    F_adder M1(.ain(S0),.bin(P3),.cin(C0),.sum(S1),.cout(C1));
    F_adder M2(.ain(S1),.bin(P4),.cin(C1),.sum(S2),.cout(C2));
    F_adder M3(.ain(S2),.bin(P5),.cin(C2),.sum(S3),.cout(C3));
    F_adder M4(.ain(S3),.bin(P6),.cin(C3),.sum(S4),.cout(C4));
    F_adder M5(.ain(S4),.bin(P7),.cin(C4),.sum(S5),.cout(C5));
    F_adder M6(.ain(S5),.bin(P8),.cin(C5),.sum(S6),.cout(C6));
    F_adder M7(.ain(S6),.bin(P9),.cin(C6),.sum(S7),.cout(C7));
    F_adder M8(.ain(S7),.bin(P10),.cin(C7),.sum(S8),.cout(C8));
    F_adder M9(.ain(S8),.bin(P11),.cin(C8),.sum(S9),.cout(C9));
    F_adder M10(.ain(S9),.bin(P12),.cin(C9),.sum(S10),.cout(C10));
    F_adder M11(.ain(S10),.bin(P13),.cin(C10),.sum(S11),.cout(C11));
    F_adder M12(.ain(S11),.bin(P14),.cin(C11),.sum(S12),.cout(C12));
    F_adder M13(.ain(S12),.bin(P15),.cin(C12),.sum(S13),.cout(C13));
    F_adder M14(.ain(S13),.bin(P16),.cin(C13),.sum(S14),.cout(C14));
    F_adder M15(.ain(S14),.bin(P17),.cin(C14),.sum(S15),.cout(C15));
    F_adder M16(.ain(S15),.bin(P18),.cin(C15),.sum(S16),.cout(C16));
    F_adder M17(.ain(S16),.bin(P19),.cin(C16),.sum(S17),.cout(C17));
    F_adder M18(.ain(S17),.bin(P20),.cin(C17),.sum(S18),.cout(C18));
    F_adder M19(.ain(S18),.bin(P21),.cin(C18),.sum(S19),.cout(C19));
    F_adder M20(.ain(S19),.bin(P22),.cin(C19),.sum(S20),.cout(C20));
    F_adder M21(.ain(S20),.bin(P23),.cin(C20),.sum(S21),.cout(C21));
    F_adder M22(.ain(S21),.bin(P24),.cin(C21),.sum(S22),.cout(C22));
    F_adder M23(.ain(S22),.bin(P25),.cin(C22),.sum(S23),.cout(C23));
    F_adder M24(.ain(S23),.bin(P26),.cin(C23),.sum(S24),.cout(C24));
    F_adder M25(.ain(S24),.bin(P27),.cin(C24),.sum(S25),.cout(C25));
    F_adder M26(.ain(S25),.bin(P28),.cin(C25),.sum(S26),.cout(C26));
    F_adder M27(.ain(S26),.bin(P29),.cin(C26),.sum(S27),.cout(C27));
    F_adder M28(.ain(S27),.bin(P30),.cin(C27),.sum(S28),.cout(C28));
    F_adder M29(.ain(S28),.bin(P31),.cin(C28),.sum(S29),.cout(C29));
    assign z=S29+C29;
    /*reg [63:0] tepz;
    assign z = tepz;
    always @(posedge clk or posedge reset)
        begin
        if(reset==1'b1)
            tepz<=0;
        else        
            tepz<=S29+C29;
        end*/
endmodule

