module DIV(
    input [31:0]dividend,//������
    input [31:0]divisor,//����
    input start,//������������
    input clock,
    input reset,
    output [31:0]q,//��
    output [31:0]r,//����
    output busy,//������æ��־λ
    output done
    );
    wire [31:0] tepdividend,tepdivisor,tepq,tepr;
    assign tepdividend=dividend[31]?(~dividend)+1:dividend;
    assign tepdivisor=divisor[31]?(~divisor)+1:divisor;
    DIVU divu_uut(.dividend(tepdividend),.divisor(tepdivisor),.start(start),.clock(clock),.reset(reset),.q(tepq),.r(tepr),.busy(busy),.done(done));
    assign q=(dividend[31]==divisor[31])?tepq:(~tepq)+1;
    assign r=dividend[31]?(~tepr)+1:tepr;
endmodule

