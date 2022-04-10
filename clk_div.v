module clk_div(
    input I_CLK,
    input [31:0] div,
    output O_CLK
    );
    reg clk=0;
    integer a=0;
    always @ (posedge I_CLK)
        begin
            if(a<div/2-1)
            begin
                a<=a+1;
            end
            else
            begin
                a<=0;
                clk<=~clk;
            end
        end
    assign O_CLK=clk;
endmodule