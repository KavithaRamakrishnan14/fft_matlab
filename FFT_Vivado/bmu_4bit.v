`timescale 1ns/1ps
module bmu_4bit(
    input clk,reset,
    input [3:0]rega,regb,regw,output[3:0]regc,regd
);
    wire [1:0] ar, ai, br, bi, wr, wi;
    wire [1:0] cr, ci, dr, di;
    wire [3:0]a,b,w,c,d;
    thirty_fourbit_reg r1(clk,reset,rega,a);
    thirty_fourbit_reg r2(clk,reset,regb,b);
    thirty_fourbit_reg r3(clk,reset,regw,w);
    thirty_fourbit_reg r4(clk,reset,c,regc);
    thirty_fourbit_reg r5(clk,reset,d,regd);
    assign ar=a[3:2];
    assign ai=a[1:0];
    assign br=b[3:2];
    assign bi=b[1:0];
    assign wr=w[3:2];
    assign wi=w[1:0];
    //wire [20:0] pad_br, pad_bi, pad_wr, pad_wi;
    wire [7:0] s0, s1, v1, u0, u1, v2;
   // wire [3:0] v1_trunc, v2_trunc;
    wire [7:0] out1, out2, out3, out4;
    //wire [3:0] pad_ar, pad_ai;
    wire v1sign,v2sign,o1sign,o2sign,o3sign,o4sign;
   /* assign pad_br = {br[15:0],5'b0};
    assign pad_bi = {bi[15:0],5'b0};
    assign pad_wr = {wr[15:0],5'b0};
    assign pad_wi = {wi[15:0],5'b0};
    assign pad_ar = {ar[15:0],6'b0};
    assign pad_ai = {ai[15:0],6'b0}; */

    vedic_4bit ved1(br,wr,0,s0);
    vedic_4bit ved2(bi,wi,0,s1);    

    assign v1 = (br[1] ^ wr[1]) ? (bi[1]^wi[1]) ?(s1 - s0) :-(s1+s0):(bi[1]^wi[1]) ?(s0+s1):(s0 - s1);
    assign v1sign=(s0<s1)?(~(bi[1]^wi[1])):(br[1]^wr[1]);
   // assign v1_trunc = v1sign?(~v1[41:20]+1):v1[41:20];  // 22bits

    assign out1 = (ar[1]) ? v1sign?(-ar-v1):(v1-ar):v1sign?(ar-v1):(ar+v1);
    assign out2 = (ar[1]) ? (v1sign?(v1-ar):(-v1-ar)):(v1sign?(ar+v1):(ar-v1));
    
    assign o1sign=(ar<v1)?(v1sign):(ar[1]);
    assign o2sign=(ar<v1)?(~v1sign):(ar[1]);
    
    vedic_4bit ved3(br,wi,0,u0);
    vedic_4bit ved4(bi,wr,0,u1);
    
    assign v2 = (br[1] ^ wi[1]) ? (bi[1]^wr[1])? -(u0 + u1):(u1-u0) : (bi[1]^wr[1])?(u0-u1):(u0 + u1);
    assign v2sign=(u1<u0)?(br[1]^wi[1]):(bi[1]^wr[1]);
    //assign v2_trunc =v2sign?(~v2[41:20]+1):v2[41:20];
    
    assign out3 = (ai[1]) ? v2sign?(-ai-v2):(v2-ai):v2sign?(ai-v2):(ai+v2);              
    assign out4 = (ai[1]) ? v2sign?(v2-ai):(-v2-ai):v2sign?(ai+v2):(ai-v2);
    
    assign o3sign=(ai<v2)?(v2sign):(ai[1]);
    assign o4sign=(ai<v2)?(~v2sign):(ai[1]);
               
    assign cr = {o1sign,o1sign?(~out1[7:0]+1):out1[7:0]};  // 17bit 
    assign dr = {o2sign,o2sign?(~out2[7:0]+1):out2[7:0]};
    assign ci = {o3sign,o3sign?(~out3[7:0]+1):out3[7:0]};
    assign di = {o4sign,o4sign?(~out4[7:0]+1):out4[7:0]};
    assign c={cr,ci};
    assign d={dr,di};
    

endmodule
