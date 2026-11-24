`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.12.2025 11:35:49
// Design Name: 
// Module Name: carrysave
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

module carrysave(
    input [3:0]x,y,z,input cin,
    output [3:0]s,output cout);
    wire const,s13,s12,s11,c13,c12,c11,c10,c22,c21,c20,s01,c01,s23;
    assign const = 0;
    full_add fa0 (x[0],y[0],z[0],s01,c10);
    full_add fa1 (x[1],y[1],z[1],s11,c11);
    full_add fa2 (x[2],y[2],z[2],s12,c12);
    full_add fa3 (x[3],y[3],z[3],s13,c13);
    full_add fa4 (s01,cin,0,s[0],c01);
    full_add fa5 (c10,s11,c01,s[1],c20);
    full_add fa6 (c11,s12,c20,s[2],c21);
    full_add fa7 (c12,s13,c21,s[3],c22);
    full_add fa8 (c13,const,c22,s23,cout);            
endmodule

module full_add(input a,b,c, output sum,carry ); 
    wire s1,s2,s3; 
    half_add h1(a,b,s1,s2); 
    half_add h2(s1,c,sum,s3); 
    or(carry,s2,s3); 
endmodule

module half_add(input a , b, output sum,carry); 
  assign sum= a^b; 
  assign carry = a&b; 
endmodule
