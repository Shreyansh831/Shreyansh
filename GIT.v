module synchronous_ram #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input wire clk,
    input wire we,               
    input wire re,               
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;           
        if (re)
            dout <= mem[addr];          
    end

endmodule

`timescale 1ns / 1ps

module tb_synchronous_ram;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg clk;
    reg we, re;
    reg [ADDR_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;

    // Instantiate RAM
    synchronous_ram #(DATA_WIDTH, ADDR_WIDTH) uut (
        .clk(clk),
        .we(we),
        .re(re),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Time\tWE RE ADDR DIN DOUT");

        // Initial values
        clk = 0;
        we = 0;
        re = 0;
        addr = 0;
        din = 0;

        // Write values into RAM
        #10; we = 1; addr = 4'b0001; din = 8'hAA; // Write AA to address 1
        #10; we = 1; addr = 4'b0010; din = 8'h55; // Write 55 to address 2
        #10; we = 0;

        // Read values from RAM
        #10; re = 1; addr = 4'b0001;             // Read from address 1
        #10; addr = 4'b0010;                     // Read from address 2
        #10; re = 0;

        // End simulation
        #20;
        $finish;
    end

    always @(posedge clk) begin
        $display("%0t\t%b  %b  %h   %h  %h", $time, we, re, addr, din, dout);
    end

endmodule
