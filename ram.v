`timescale 1ns / 1ps

module ram(
    input           clk,
    input           rst,
    input   [ 7:0]  num,
    input           re,
    input           we,
    input   [31:0]  di,
    input   [31:0]  addr,
    output  [31:0]  data
    );
    
    reg [7:0]ram[1:0];
    
    assign data = re ? {24'b0, ram[addr[1:0]]} : 0;
    
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            ram[0] <= num;
            ram[1] <= 0;
        end 
        else begin 
            if (we) ram[addr[1:0]] <= di[7:0];
        end 
    end 
endmodule
