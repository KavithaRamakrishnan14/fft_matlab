`timescale 1ns/1ps
module dp(A1,A2,CE1,CE2,WEB1,WEB2,OEB1,OEB2,CSB1,CSB2,I1,I2,O1,O2);
  input [9:0] A1,A2;
  input WEB1, WEB2;
  input CE1, CE2;
  input OEB1, OEB2;
  input CSB1, CSB2;
  input [35:0] I1,I2;
  output [35:0] O1, O2;

 (* dont_touch = "true" *) wire CE2_test1,CE2_test2,CE2_test3,CE2_test4,CE2_test5,CE2_test6;
 DPRAM_1024x36 M1 (
    .A1(A1),
    .A2(A2),
    .CE1(CE1),
    .CE2(CE2_test6),
    .WEB1(WEB1),
    .WEB2(WEB2),
    .OEB1(OEB1),
    .OEB2(OEB2),
    .CSB1(CSB1),
    .CSB2(CSB2),
    .I1(I1),
    .I2(I2),
    .O1(O1),
    .O2(O2)
  );

bufbdk b1 (CE2,CE2_test1);
bufbdk b2 (CE2_test1,CE2_test2);
bufbdk b3 (CE2_test2,CE2_test3);
bufbdk b4 (CE2_test3,CE2_test4);
bufbdk b5 (CE2_test4,CE2_test5);
bufbdk b6 (CE2_test5,CE2_test6);
endmodule
