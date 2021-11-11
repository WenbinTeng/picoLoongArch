`timescale 1ns / 1ps

module bpu(
    input           op,
    input   [31:0]  qa,
    input   [31:0]  qb,
    output          take
    );
    
    assign take = op & (qa != qb);
    
endmodule
