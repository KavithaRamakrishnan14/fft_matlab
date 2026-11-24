`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.01.2026 11:34:51
// Design Name: 
// Module Name: vedicc_4bit
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

module vedicc_4bit(
	input [3:0]a,
	input [3:0]b,
	input cin,
	output [7:0]f
	);
wire [4:0]s,c;
wire [4:0]p;
wire d,fcout;
wire cout,cs,cd;
assign f[0] = a[0]&b[0];
half_add h1(a[1]&b[0],a[0]&b[1],f[1],c[0]);
full_add f1(a[2]&b[0],a[1]&b[1],a[0]&b[2],s[0],c[1]);
full_add_4bit f2(a[3]&b[0],a[2]&b[1],a[1]&b[2],a[0]&b[3],s[1],c[2],d);
full_add f3(a[3]&b[1],a[2]&b[2],a[1]&b[3],s[2],c[3]);
half_add h2(a[3]&b[2],a[2]&b[3],s[3],c[4]);
assign s[4]=a[3]&b[3];
carrysave_5bit cs1(s,c,cin,p,cout);
assign f[4:2]=p[2:0];
half_add h5(p[3],d,f[5],cs);
half_add h6(p[4],cs,f[6],cd);
full_add h7(s[4],cd,cout,f[7],fcout);
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

module full_add_4bit(input a,b,c,cin, output sum,output  carry_1,carry_2);
wire sum1,carry1,carry2;
full_add h1(a,b,c,sum1,carry1);
half_add h2(sum1,cin,sum,carry2);
half_add h3(carry1,carry2,carry_1,carry_2);
endmodule

