`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 22:08:47
// Design Name: 
// Module Name: vedic_16bit
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


module vedic_16bit(
	input [15:0]ai,
	input [15:0]bi,
	input cin,
	output [31:0]f
);
wire [15:0] p1,p2,p3,p4;
wire [15:0] q1;
wire [31:0] r1,r2;
wire cout16,fcout;
vedic_8bit e1(ai[7:0],bi[7:0],cin,p1);
vedic_8bit e2(ai[15:8],bi[7:0],cin,p2);
vedic_8bit e3(ai[7:0],bi[15:8],cin,p3);
vedic_8bit e4(ai[15:8],bi[15:8],cin,p4);
carrysave_16bit e5(p2,p3,0,q1,cout16);
assign r1={15'b0,cout16,q1,8'b0};
assign r2={p4,p1};
carrysave_32bit e6(r1,r2,0,f,fcout);
endmodule
