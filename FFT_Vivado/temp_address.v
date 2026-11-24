`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 16:44:48
// Design Name: 
// Module Name: temp_address
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


module temp_address(
input en,        // this enable is for overall address block
    input data_clk,
    input fft_clk,
    input rst,
    output reg [3:0] A1, A2, A3, A4,
    output wire[3:0]data_addr,
    output reg [3:0]twiddle,
    output reg data_enable,enable,read1,read2,dpram1, //enable is for fft
    output wire twidd,
    output reg fifo_enable,
    output wire fifo_read_enable
    );
    reg [1:0]state;
    parameter 
    WAIT = 2'b00,
    S1   = 2'b01,
    S2   = 2'b10;
    parameter FFT_POINT=16;
    parameter points_countbit=3;
    parameter counter_countbit=3;
    parameter FFT_OPPOINT=8;
    parameter FFT_STAGES=5; //2^4 ->4 stages need ->since output generates in 5th stage
    integer fifo_read_count=0;
    reg [points_countbit-1:0]stage=0;
    reg[points_countbit:0]address_hold=0;
    reg [counter_countbit:0]comp_counter=0; // computation counter counts no. of butterfly computation
    reg [counter_countbit:0]counter2=0;
    reg [points_countbit+1:0]fft_counter=0;
    reg [points_countbit+1:0]data_counter=0;
    reg fft;
    reg twid; // twiddle factor address index
    reg [3:0]A5;
    assign twidd=twid;
    assign data_addr={A5[0],A5[1],A5[2],A5[3]};
    assign states=state;
    assign fifo_read_enable=(fifo_read_count>30);//condition doesn't satisfies means 0 will stores
    initial begin
        state=0;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;A5=0;
        read1=0;
        read2=1;
        enable=0;
        dpram1=1; // used to enable dpram
        fft=0;
        twid=1; // it is twiddle factor address enable signal (control signal)
        twiddle=0;
        data_enable=1; 
        fifo_enable=0;
    end
    always@(posedge data_clk or posedge rst) begin
        if(rst)begin
            A5<=0;
            data_counter<=0;
            dpram1<=1;
            twid<=1;
            twiddle<=0;
            data_enable<=0;
        end
        else begin
            if(en)begin
                if(fifo_read_count<32)begin
                    fifo_read_count<=fifo_read_count+1;
                end
                data_enable<=1;
                if(data_counter<FFT_POINT-1)begin
                    data_counter<=data_counter+1;
                    A5<=A5+1;
                    if(data_counter<(FFT_POINT-2)&&(twid))begin   // To avoid ram overflow they goes before reaching the final limit. &&twid means twid should be 1
                        twiddle<=twiddle+1;
                    end
                end
                else begin
                    dpram1<=~dpram1;
                    data_counter<=0;
                    data_enable<=0;
                    A5<=0;
                    fft<=1;
                    twid<=0;
                end
            end
        end
    end
    always @(posedge fft_clk or posedge rst) begin
    if (rst) begin
        state <= WAIT;
        fft_counter <= 0;
        A1 <= 0; A2 <= 0; A3 <= 0; A4 <= 0;
        twiddle<=0;
        address_hold<=0;
        enable<=0;
        read1<=1;
        read2<=1;
        fft=0;
    end 
    else begin
        case (state)
            WAIT: begin
                read1<=0;
                read2<=0;
                enable<=0;
                if (en) begin
                    if(fft)begin
                        fft_counter <= 0;
                        comp_counter<=1;
                        counter2<=0;
                        address_hold<=2;
                        A1 <= 5'd0; A2 <= 5'd1; A3 <= 5'd0; A4 <= 5'd1;
                        twiddle<=0;
                        state <= S1;
                        fft<=1;
                        address_hold<=0;
                        read1<=0;
                        read2<=1;
                        enable<=1;
                        stage<=0;
                    end
                end
            end
            S1 : begin
               if(fft_counter<FFT_OPPOINT)begin
                   if(fft_counter<FFT_OPPOINT-1)begin
                       if(counter2==comp_counter-1)begin
                            A1<=A2+1;
                            A2<=A2+comp_counter+1;
                            counter2<=0;
                            twiddle<=address_hold;
                       end 
                       else begin
                            A1<=A1+1;
                            A2<=A1+comp_counter+1;
                            counter2<=counter2+1;
                            twiddle<=twiddle+1;
                       end
                   end
                   if(fft_counter>0)begin
                       A3<=A1;
                       A4<=A2;
                   end
                   fft_counter<=fft_counter+1;
               end
               else begin
                    if(stage==(FFT_STAGES-2))begin
                        state<=S2;
                        A1<=0;
                        A2<=0;
                        A3<=0;
                        A4<=0;
                        fft_counter<=0;
                        read1<=~read1;
                        read2<=~read2;
                        stage<=stage+1;
                    end
                    else begin
                        A1<=0;
                        A2<=comp_counter*2;
                        A3<=0;
                        A4<=comp_counter*2;
                        comp_counter<=comp_counter*2;
                        fft_counter<=0;
                        counter2<=0;
                        read1<=~read1;
                        read2<=~read2;
                        enable<=1;
                        twiddle<=twiddle+1;
                        address_hold<=twiddle+1;
                        stage<=stage+1;
                    end
               end
            end
            S2 : begin
                if(fft_counter==FFT_POINT)begin
                    A1<=0;
                    A2<=0;
                    A3<=0;
                    A4<=0;
                    enable<=0;
                    state<=WAIT;
                    fft<=0;
                    fifo_enable<=0;
                 end
                else begin
                     fifo_enable<=1;
                     fft_counter<=fft_counter+1;
                     A1<=A1+1;
                 end
            end
       endcase
    end
    end
    
endmodule