`timescale 1ns / 1ps

module rom(
    input   [31:0]  addr,
    output  [31:0]  inst
    );
    
    reg [31:0]rom[15:0];
    
    assign inst = rom[addr[3:0]];
    
    initial begin 
        rom[0] = 32'h0380000c;
        rom[1] = 32'h0380040d;
        rom[2] = 32'h03800017;
        rom[3] = 32'h03800418;
        rom[4] = 32'h2a100004;
        rom[5] = 32'h0010358e;
        rom[6] = 32'h038001ac;
        rom[7] = 32'h038001cd;
        rom[8] = 32'h001062f7;
        rom[9] = 32'h5ffff2e4;
        rom[10] = 32'h2910040e;
        rom[11] = 32'h5c000300;
        rom[12] = 32'h0;
        rom[13] = 32'h0;
        rom[14] = 32'h0;
        rom[15] = 32'h0;
    end 
    
endmodule
