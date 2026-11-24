`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 21:21:31
// Design Name: 
// Module Name: carrysave_16bit
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


module carrysave_16bit(
	input [15:0]x,y, input cin,
	output [15:0]s, output cout
    );
    wire cout81;
    carrysave_8bit e1(x[7:0],y[7:0],cin,s[7:0],cout81);
    carrysave_8bit e2(x[15:8],y[15:8],cout81,s[15:8],cout);
endmodule
