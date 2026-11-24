`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 11:37:48
// Design Name: 
// Module Name: carrysave_5bit
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

module carrysave_5bit(
	input [4:0]x,y, input cin,
	output [5:0]s, output cout);
	wire [3:0]st;
	wire [4:0]c;
	wire [3:0]ct;
	assign const=0;
	full_add fa0 (x[0],y[0],cin,s[0],c[0]);
	half_add ha0 (x[1],y[1],st[0],c[1]);
	half_add ha1 (x[2],y[2],st[1],c[2]);
	half_add ha2 (x[3],y[3],st[2],c[3]);
	half_add ha4 (x[4],y[4],st[3],c[4]);
	half_add hac0 (st[0],c[0],s[1],ct[0]);
	full_add fac1 (st[1],c[1],ct[0],s[2],ct[1]);
	full_add fac2 (st[2],c[2],ct[1],s[3],ct[2]);
	full_add fac3 (st[3],c[3],ct[2],s[4],ct[3]);
	half_add hac1 (c[4],ct[3],s[5],cout);
endmodule

module full_add(input a,b,c, output sum,carry);
wire s1,s2,s3;
half_add h1(a,b,s1,carry1);
half_add h2(s1,c,sum,carry2);
or(carry,carry1,carry2);
endmodule

module half_add(input a,b,output sum,carry);
assign sum = a^b;
assign carry=a&b;
endmodule
