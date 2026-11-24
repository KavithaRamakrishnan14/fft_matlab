`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2025 13:17:12
// Design Name: 
// Module Name: fft
// Project Name: 

module fft(
    input [3:0] a,b,
    input data_clk,fft_clk,en,rst,
    output wire[3:0]fifo_output_data,
    output wire [3:0] dpram1_out,dpram1_out2,dpram3_out1,dpram3_out2,twidde_out1,bout1,bout2,
    output wire read,dpram_clk,
    wire [3:0]dpram1_addressi,dpram2_addressi,dpram3_addressi,dpram4_addressi,
    wire [3:0]dpram1_addressj,dpram2_addressj,dpram3_addressj,dpram4_addressj,
    output wire empty,full   
);

(* dont_touch = "true" *) wire CE2_test,CE2_test1,CE2_test2,CE2_test3,CE2_test4,CE2_test5,CE2_test6;

    //Declarations
    reg address_enable1; 
    wire dp1;
    wire twid;
    wire fft_ram_enable;
    wire data_enable;
    wire read1,read2;
    wire start;
    wire dpram1_clk,dpram2_clk,dpram4_clk;
    wire dpram1_enable,dpram2_enable,dpram4_enable;
    wire dpram1_enableb,dpram2_enableb,dpram4_enableb;
    wire dpram1_write,dpram2_write,dpram4_write;
    wire [3:0]dpram1_address,dpram2_address,dpram3_address,dpram4_address;
    wire [3:0]dpram1_addressb,dpram2_addressb,dpram3_addressb,twiddle;
    wire [3:0]A1,A2,A3,A4,A5;
    wire [3:0]dpram1_din,dpram2_din,dpram3_din,dpram4_din;
    wire [3:0]dpram1_dinb,dpram2_dinb,dpram3_dinb,dpram4_dinb;
    wire [3:0]dpram1_dout,dpram2_dout,dpram3_dout,dpram4_dout;
    wire [3:0]dpram1_doutb,dpram2_doutb,dpram3_doutb,dpram4_doutb;
    wire [3:0]bmuin1,bmuin2,bmuout1,bmuout2;
    wire fifo_write_enable;
    wire fifo_read_enable;
    wire [3:0]fifo_input_data;

//mychange
    wire dpram1_oe,dpram2oe,dpram3_oe,dpram4_oe;
    wire dpram1_clk2,dpram2_clk2,dpram3_clk2,dpram4_clk2;

    //Checking purpose
    assign dpram1_out=dpram1_dout;
    assign dpram1_out2=dpram1_doutb;
    assign dpram3_out1=dpram3_dout;
    assign dpram3_out2=dpram3_doutb;
    assign twidde_out1=dpram4_dout;
    assign bout1=bmuout1;
    assign bout2=bmuout2;
    assign read=read1;
    assign dpram_clk=dp1;
    assign dpram1_addressi=dpram1_address;
    assign dpram2_addressi=dpram2_address;
    assign dpram3_addressi=dpram3_address;
    assign dpram4_addressi=twiddle;
    assign dpram1_addressj=dpram1_addressb;
    assign dpram2_addressj=dpram2_addressb;
    assign dpram3_addressj=dpram3_addressb;
    assign dpram4_addressj=twiddle;
    //signal-Assignments
   assign dpram1_clk=dp1?data_clk:fft_clk;
    assign dpram2_clk=dp1?fft_clk:data_clk;
    assign dpram4_clk=twid?data_clk:fft_clk;
    assign dpram1_enable=dp1?data_enable:fft_ram_enable;
    assign dpram2_enable=dp1?fft_ram_enable:data_enable;
    assign dpram4_enable=twid?data_enable:fft_ram_enable;
    assign dpram1_enableb=dp1?0:fft_ram_enable;
    assign dpram2_enableb=dp1?fft_ram_enable:0;
    assign dpram4_enableb=twid?0:fft_ram_enable;
    assign dpram1_write=dp1?1:read1;
    assign dpram2_write=dp1?read1:1;
    assign dpram4_write=twid?1:0;
    assign dpram1_address=dp1?A5:(read1?A3:A1);
    assign dpram2_address=dp1?(read1?A3:A1):A5;
    assign dpram3_address=read1?A1:A3;
    assign dpram1_addressb=dp1?A5:(read1?A4:A2);
    assign dpram2_addressb=dp1?(read1?A4:A2):A5;
    assign dpram3_addressb=read1?A2:A4;
    assign dpram1_din=dp1?a:bmuout1;
    assign dpram2_din=dp1?bmuout1:a;
    assign dpram3_din=bmuout1;
    assign dpram4_din=b;
    assign dpram1_dinb=dp1?a:bmuout2;
    assign dpram2_dinb=dp1?bmuout2:a;
    assign dpram3_dinb=bmuout2;
    assign dpram4_dinb=b;
    assign bmuin1=dp1?(read1?dpram3_dout:dpram2_dout):(read1?dpram3_dout:dpram1_dout);
    assign bmuin2=dp1?(read1?dpram3_doutb:dpram2_doutb):(read1?dpram3_doutb:dpram1_doutb);
    //fifo
    assign fifo_input_data=(dp1)?dpram2_dout:dpram1_dout;
    //my change
    assign dpram1_oe=dp1?read1:1;
    assign dpram2_oe=dp1?1:read1;
    assign dpram4_oe=twid?0:1;
    assign dpram3_oe=~read2;
//delay using buffer
bufbdk b1 (dpram1_clk2,CE2_test1);
bufbdk b2 (CE2_test1,CE2_test2);
bufbdk b3 (CE2_test2,CE2_test3);
bufbdk b4 (CE2_test3,CE2_test4);
bufbdk b5 (CE2_test4,CE2_test5);
bufbdk b6 (CE2_test5,CE2_test6);

bufbdk b1 (dpram2_clk2,CE2_test1);
bufbdk b2 (CE2_test1,CE2_test2);
bufbdk b3 (CE2_test2,CE2_test3);
bufbdk b4 (CE2_test3,CE2_test4);
bufbdk b5 (CE2_test4,CE2_test5);
bufbdk b6 (CE2_test5,CE2_test6);

bufbdk b1 (dpram3_clk2,CE2_test1);
bufbdk b2 (CE2_test1,CE2_test2);
bufbdk b3 (CE2_test2,CE2_test3);
bufbdk b4 (CE2_test3,CE2_test4);
bufbdk b5 (CE2_test4,CE2_test5);
bufbdk b6 (CE2_test5,CE2_test6);

bufbdk b1 (dpram4_clk2,CE2_test1);
bufbdk b2 (CE2_test1,CE2_test2);
bufbdk b3 (CE2_test2,CE2_test3);
bufbdk b4 (CE2_test3,CE2_test4);
bufbdk b5 (CE2_test4,CE2_test5);
bufbdk b6 (CE2_test5,CE2_test6);

    //instantiations
    bmu b1(data_clk,rst,bmuin1,bmuin2,dpram4_dout,bmuout1,bmuout2);
    temp_address a1(address_enable1,data_clk,fft_clk,rst,A1,A2,A3,A4,A5,twiddle,data_enable,fft_ram_enable,read1,read2,dp1,twid,fifo_write_enable,fifo_read_enable);
dp dpram1 (
    .A1(dpram1_address),
    .A2(dpram1_adressb),
    .CE1(dpram1_clk),
    .CE2(dpram1_clk2),
    .WEB1(dpram1_write),
    .WEB2(dpram1_write),
    .OEB1(dpram1_oe),
    .OEB2(dpram1_oe),
    .CSB1(dpram1_enable),
    .CSB2(dpram1_enableb),
    .I1(dpram1_din),
    .I2(dpram1_dinb),
    .O1(dpram1_dout),
    .O2(dpram1_doutb)
    );
   dp dpram2 (
     .A1(dpram2_address),
    .A2(dpram2_adressb),
    .CE1(dpram2_clk),
    .CE2(dpram2_clk2),
    .WEB1(dpram2_write),
    .WEB2(dpram2_write),
    .OEB1(dpram2_oe),
    .OEB2(dpram2_oe),
    .CSB1(dpram2_enable),
    .CSB2(dpram2_enableb),
    .I1(dpram2_din),
    .I2(dpram2_dinb),
    .O1(dpram2_dout),
    .O2(dpram2_doutb)
    );
  dp dpram3 (
  .CE1(fft_clk),   
  .CSB1(fft_ram_enable),      
  .WEB1(read2),      
  .A1(dpram3_address),  
  .I1(dpram3_din),    
  .O1(dpram3_dout),  
  .CE2(dpram3_clk2),    
  .CSB2(fft_ram_enable),     
  .WEB2(read2),     
  .A2(dpram3_addressb), 
  .I2(dpram3_dinb),    
  .O2(dpram3_doutb),
    .OEB1(dpram3_oe),
    .OEB2(dpram3_oe),  
);
dp dpram4 (
  .CE1(dpram4_clk),    // input wire clka
  .CSB1(dpram4_enable),      // input wire ena
  .WEB1(dpram4_write),      // input wire [0 : 0] wea
  .A1(twiddle),  // input wire [3 : 0] addra
  .I1(dpram4_din),    // input wire [33 : 0] dina
  .O1(dpram4_dout),  // output wire [33 : 0] douta
  .CE2(dpram4_clk2),    // input wire clkb
  .CSB2(dpram4_enableb),      // input wire enb
  .WEB2(dpram4_write),      // input wire [0 : 0] web
  .A2(twiddle),  // input wire [3 : 0] addrb
  .I2(dpram4_dinb),    // input wire [33 : 0] dinb
  .O2(dpram4_doutb),
  .OEB1(dpram4_oe),
  .OEB2(dpram4_oe), // output wire [33 : 0] doutb
);
FIFO f1(.rst(rst),
    .inclk(fft_clk),
    .outclk(data_clk),
    .write_enable(fifo_write_enable),
    .read_enable(fifo_read_enable),
    .input_data(fifo_input_data),
    .output_data(fifo_output_data),
    .emptyo(empty),
    .fullo(full)
    );

//adjusting data clock
    initial 
        begin
            address_enable1=1;    
        end

  /*  always @(posedge data_clk) 
        begin
            if (en)
                begin
                    address_enable1<=1;
                end
        end*/
endmodule
