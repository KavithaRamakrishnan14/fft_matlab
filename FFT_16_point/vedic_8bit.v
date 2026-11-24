`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2026 21:48:25
// Design Name: 
// Module Name: vedic_8bit
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


module vedic_8bit(
	input [7:0]ai,
	input [7:0]bi,
	input cin,
	output [15:0]f
	);
	wire [7:0] p1,p2,p3,p4;
	wire [7:0] q1;
	wire [15:0] r1,r2;
	wire  fcout,cout8;
	vedicc_4bit f1(ai[3:0],bi[3:0],cin,p1);
	vedicc_4bit f2(ai[7:4],bi[3:0],cin,p2);
	vedicc_4bit f3(ai[3:0],bi[7:4],cin,p3);
	vedicc_4bit f4(ai[7:4],bi[7:4],cin,p4);
	carrysave_8bit e11(p2,p3,0,q1,cout8);
	assign r1={5'b0,cout8,q1,4'b0};
	assign r2={p4,p1};
	carrysave_16bit s11(r1,r2,0,f,fcout);
	endmodule 