`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 12:08:52
// Design Name: 
// Module Name: bmu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2026 12:08:52
// Design Name: 
// Module Name: bmu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bmu(
    input clk,reset,
    input [33:0]rega,regb,regw,output[33:0]regc,regd
);
    wire [16:0] ar, ai, br, bi, wr, wi;
    wire [16:0] cr, ci, dr, di;
    wire [33:0]a,b,w,c,d;
    thirty_fourbit_reg r1(clk,reset,rega,a);
    thirty_fourbit_reg r2(clk,reset,regb,b);
    thirty_fourbit_reg r3(clk,reset,regw,w);
    thirty_fourbit_reg r4(clk,reset,c,regc);
    thirty_fourbit_reg r5(clk,reset,d,regd);
    assign ar=a[33:17];
    assign ai=a[16:0];
    assign br=b[33:17];
    assign bi=b[16:0];
    assign wr=w[33:17];
    assign wi=w[16:0];
    wire [20:0] pad_br, pad_bi, pad_wr, pad_wi;
    wire [41:0] s0, s1, v1, u0, u1, v2;
    wire [21:0] v1_trunc, v2_trunc;
    wire [21:0] out1, out2, out3, out4;
    wire [21:0] pad_ar, pad_ai;
    wire v1sign,v2sign,o1sign,o2sign,o3sign,o4sign;
    assign pad_br = {br[15:0],5'b0};
    assign pad_bi = {bi[15:0],5'b0};
    assign pad_wr = {wr[15:0],5'b0};
    assign pad_wi = {wi[15:0],5'b0};
    assign pad_ar = {ar[15:0],6'b0};
    assign pad_ai = {ai[15:0],6'b0};

    vedic_32bit ved1({11'b0,pad_br},{11'b0,pad_wr},0,s0);
    vedic_32bit ved2({11'b0,pad_bi},{11'b0,pad_wi},0,s1);    

    assign v1 = (br[16] ^ wr[16]) ? (bi[16]^wi[16]) ?(s1 - s0) :-(s1+s0):(bi[16]^wi[16]) ?(s0+s1):(s0 - s1);
    assign v1sign=(s0<s1)?(~(bi[16]^wi[16])):(br[16]^wr[16]);
    assign v1_trunc = v1sign?(~v1[41:20]+1):v1[41:20];  // 22bits

    assign out1 = (ar[16]) ? v1sign?(-pad_ar-v1_trunc):(v1_trunc-pad_ar):v1sign?(pad_ar-v1_trunc):(pad_ar+v1_trunc);
    assign out2 = (ar[16]) ? (v1sign?(v1_trunc-pad_ar):(-v1_trunc-pad_ar)):(v1sign?(pad_ar+v1_trunc):(pad_ar-v1_trunc));
    
    assign o1sign=(pad_ar<v1_trunc)?(v1sign):(ar[16]);
    assign o2sign=(pad_ar<v1_trunc)?(~v1sign):(ar[16]);
    
    vedic_32bit ved3({11'b0,pad_br},{11'b0,pad_wi},0,u0);
    vedic_32bit ved4({11'b0,pad_bi},{11'b0,pad_wr},0,u1);
    
    assign v2 = (br[16] ^ wi[16]) ? (bi[16]^wr[16])? -(u0 + u1):(u1-u0) : (bi[16]^wr[16])?(u0-u1):(u0 + u1);
    assign v2sign=(u1<u0)?(br[16]^wi[16]):(bi[16]^wr[16]);
    assign v2_trunc =v2sign?(~v2[41:20]+1):v2[41:20];
    
    assign out3 = (ai[16]) ? v2sign?(-pad_ai-v2_trunc):(v2_trunc-pad_ai):v2sign?(pad_ai-v2_trunc):(pad_ai+v2_trunc);              
    assign out4 = (ai[16]) ? v2sign?(v2_trunc-pad_ai):(-v2_trunc-pad_ai):v2sign?(pad_ai+v2_trunc):(pad_ai-v2_trunc);
    
    assign o3sign=(pad_ai<v2_trunc)?(v2sign):(ai[16]);
    assign o4sign=(pad_ai<v2_trunc)?(~v2sign):(ai[16]);
               
    assign cr = {o1sign,o1sign?(~out1[21:6]+1):out1[21:6]};  // 17bit 
    assign dr = {o2sign,o2sign?(~out2[21:6]+1):out2[21:6]};
    assign ci = {o3sign,o3sign?(~out3[21:6]+1):out3[21:6]};
    assign di = {o4sign,o4sign?(~out4[21:6]+1):out4[21:6]};
    assign c={cr,ci};
    assign d={dr,di};
    

endmodule
