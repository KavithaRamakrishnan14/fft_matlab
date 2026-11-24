`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 21:51:45
// Design Name: 
// Module Name: carrysave_64bit
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


module carrysave_64bit(
	input [63:0]x,y, input cin,
	output [63:0]s, output cout
    );
    wire cout32;
    carrysave_32bit t1(x[31:0],y[31:0],cin,s[31:0],cout32);
    carrysave_32bit t2(x[63:32],y[63:32],cout32,s[63:32],cout); 
endmodule
