
module fft (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [3:0] twiddle_in,

    input  wire data_clk,
    input  wire fft_clk,
    input  wire en,
    input  wire rst,

    output wire [3:0] bout1,
    output wire [3:0] bout2,

    output wire read,
    output wire dpram_clk
);

    reg address_enable1;

    wire dp1;
    wire twid;

    wire fft_ram_enable;
    wire data_enable;

    wire read1, read2;
    wire start;

    wire fifo_write_enable;
    wire fifo_read_enable;

    wire [3:0] A1, A2, A3, A4, A5;
    wire [3:0] twiddle;

    wire [3:0] bmuin1, bmuin2;
    wire [3:0] bmuout1, bmuout2;

    // Direct input connections
    assign bmuin1 = a;
    assign bmuin2 = b;
    assign twiddle = twiddle_in;

    // Output connections
    assign bout1 = bmuout1;
    assign bout2 = bmuout2;

    assign read = read1;
    assign dpram_clk = dp1;

    // Address and control generator
    temp_address a1 (
        address_enable1,
        data_clk,
        fft_clk,
        rst,
        A1,
        A2,
        A3,
        A4,
        A5,
        twiddle,
        data_enable,
        fft_ram_enable,
        read1,
        read2,
        dp1,
        twid,
        fifo_write_enable,
        fifo_read_enable
    );

    // Butterfly unit
    bmu_4bit b1 (
        data_clk,
        rst,
        bmuin1,
        bmuin2,
        twiddle,
        bmuout1,
        bmuout2
    );

    // Initial control
    initial begin
        address_enable1 = 1'b1;
    end

endmodule
