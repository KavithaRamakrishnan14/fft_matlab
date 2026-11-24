`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.01.2026 22:08:06
// Design Name: 
// Module Name: vedic_32bit
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


module vedic_32bit(
	input [31:0]ai,
	input [31:0]bi,
	input cin,
	output [41:0]out
    );
    wire [31:0] p1,p2,p3,p4;
    wire [31:0] q1;
    wire [63:0]f;
    wire [63:0] r1,r2;
    wire cout32,fcout;
    vedic_16bit e1(ai[15:0],bi[15:0],cin,p1);
    vedic_16bit e2(ai[31:16],bi[15:0],cin,p2);
    vedic_16bit e3(ai[15:0],bi[31:16],cin,p3);
    vedic_16bit e4(ai[31:16],bi[31:16],cin,p4);
    carrysave_32bit e5(p2,p3,0,q1,cout32);
    assign r1={31'b0,cout32,q1,16'b0};
    assign r2={p4,p1};
    carrysave_64bit e6(r1,r2,0,f,fcout);
    assign out=f[41:0];
endmodule
