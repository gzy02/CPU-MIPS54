`timescale 1ns / 1ps
module CLZCOUNT(
    input [31:0] a,
    output [31:0] clz_res
    );
    assign clz_res = a[31] ? 0 :
                     a[30] ? 1 :
                     a[29] ? 2 :
                     a[28] ? 3 :
                     a[27] ? 4 :
                     a[26] ? 5 :
                     a[25] ? 6 :
                     a[24] ? 7 :
                     a[23] ? 8 :
                     a[22] ? 9 :
                     a[21] ? 10 :
                     a[20] ? 11 :
                     a[19] ? 12 :
                     a[18] ? 13 :
                     a[17] ? 14 :
                     a[16] ? 15 :
                     a[15] ? 16 :
                     a[14] ? 17 :
                     a[13] ? 18 :
                     a[12] ? 19 :
                     a[11] ? 20 :
                     a[10] ? 21 :
                     a[9] ? 22 :
                     a[8] ? 23 :
                     a[7] ? 24 :
                     a[6] ? 25 :
                     a[5] ? 26 :
                     a[4] ? 27 :
                     a[3] ? 28 :
                     a[2] ? 29 :
                     a[1] ? 30 : 
                     a[0] ? 31 : 32;
endmodule
