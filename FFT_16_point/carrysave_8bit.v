`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.01.2026 00:17:47
// Design Name: 
// Module Name: carrysave_8bit
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


module carrysave_8bit(
	input [7:0]x,y, input cin,
	output [7:0]s, output cout);
	wire [5:0]t1,t2,t3;
	wire cout51,cout52,cout53;
	carrysave_5bit c1(x[4:0],y[4:0],cin,t1,cout51);
	assign s[4:0]=t1[4:0];
	carrysave_5bit c2({2'b0,x[7:5]},{2'b0,y[7:5]},t1[5],t2,cout52);
	assign s[5]=t2[0];
	carrysave_5bit c3(5'b0,{1'b0,t2[5:1]},cout51,t3,cout53);
	assign s[7:6]=t3[1:0];
	assign cout=t3[2];
endmodule

