module F_adder( 
    input [63:0] ain, bin, cin,
    output [63:0] sum,cout
);
   
    assign sum = ain^bin^cin;//异或运算算加法
    assign cout = ((ain&bin)|(cin&ain)|(cin&bin))<<1;//需要进位的位数全部填充1，其他的填0
endmodule