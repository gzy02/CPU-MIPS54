module F_adder( 
    input [63:0] ain, bin, cin,
    output [63:0] sum,cout
);
   
    assign sum = ain^bin^cin;//���������ӷ�
    assign cout = ((ain&bin)|(cin&ain)|(cin&bin))<<1;//��Ҫ��λ��λ��ȫ�����1����������0
endmodule