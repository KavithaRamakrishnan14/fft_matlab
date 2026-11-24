`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 21:44:33
// Design Name: 
// Module Name: carrysave_32bit
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


module carrysave_32bit(
	input [31:0]x,y, input cin,
	output [31:0]s, output cout
    );
    wire cout16;
    carrysave_16bit s1(x[15:0],y[15:0],cin,s[15:0],cout16);
    carrysave_16bit s2(x[31:16],y[31:16],cout16,s[31:16],cout);   
endmodule
