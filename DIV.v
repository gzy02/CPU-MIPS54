module DIV(
    input [31:0]dividend,//被除数
    input [31:0]divisor,//除数
    input start,//启动除法运算
    input clock,
    input reset,
    output [31:0]q,//商
    output [31:0]r,//余数
    output busy,//除法器忙标志位
    output done
    );
    wire [31:0] tepdividend,tepdivisor,tepq,tepr;
    assign tepdividend=dividend[31]?(~dividend)+1:dividend;
    assign tepdivisor=divisor[31]?(~divisor)+1:divisor;
    DIVU divu_uut(.dividend(tepdividend),.divisor(tepdivisor),.start(start),.clock(clock),.reset(reset),.q(tepq),.r(tepr),.busy(busy),.done(done));
    assign q=(dividend[31]==divisor[31])?tepq:(~tepq)+1;
    assign r=dividend[31]?(~tepr)+1:tepr;
endmodule

