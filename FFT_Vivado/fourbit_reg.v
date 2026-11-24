`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 11:36:16
// Design Name: 
// Module Name: fourbit_reg
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


module dff(	
	input d,clk,reset,
	output reg q,qb
);
	always @(posedge clk) begin 
		if (reset) begin 
			q<=0;
		end
		else begin
			q<=d;
		end
			qb<=~q;
	end
endmodule

module thirty_fourbit_reg (
	input clk,reset,input [33:0]a,output[33:0]b
);
	wire [33:0]qb;
	dff f1(a[0],clk,reset,b[0],qb[0]);
	dff f2(a[1],clk,reset,b[1],qb[1]);
	dff f3(a[2],clk,reset,b[2],qb[2]);
	dff f4(a[3],clk,reset,b[3],qb[3]);
	dff f5(a[4],clk,reset,b[4],qb[4]);
	dff f6(a[5],clk,reset,b[5],qb[5]);
	dff f7(a[6],clk,reset,b[6],qb[6]);
	dff f8(a[7],clk,reset,b[7],qb[7]);
	dff f9(a[8],clk,reset,b[8],qb[8]);
	dff f10(a[9],clk,reset,b[9],qb[9]);
	dff f11(a[10],clk,reset,b[10],qb[10]);
	dff f12(a[11],clk,reset,b[11],qb[11]);
	dff f13(a[12],clk,reset,b[12],qb[12]);
	dff f14(a[13],clk,reset,b[13],qb[13]);
	dff f15(a[14],clk,reset,b[14],qb[14]);
	dff f16(a[15],clk,reset,b[15],qb[15]);
	dff f17(a[16],clk,reset,b[16],qb[16]);
	dff f18(a[17],clk,reset,b[17],qb[17]);
	dff f19(a[18],clk,reset,b[18],qb[18]);
	dff f20(a[19],clk,reset,b[19],qb[19]);
	dff f21(a[20],clk,reset,b[20],qb[20]);
	dff f22(a[21],clk,reset,b[21],qb[21]);
	dff f23(a[22],clk,reset,b[22],qb[22]);
	dff f24(a[23],clk,reset,b[23],qb[23]);
	dff f25(a[24],clk,reset,b[24],qb[24]);
	dff f26(a[25],clk,reset,b[25],qb[25]);
	dff f27(a[26],clk,reset,b[26],qb[26]);
	dff f28(a[27],clk,reset,b[27],qb[27]);
	dff f29(a[28],clk,reset,b[28],qb[28]);
	dff f30(a[29],clk,reset,b[29],qb[29]);
	dff f31(a[30],clk,reset,b[30],qb[30]);
	dff f32(a[31],clk,reset,b[31],qb[31]);
	dff f33(a[32],clk,reset,b[32],qb[32]);
	dff f34(a[33],clk,reset,b[33],qb[33]);
endmodule

