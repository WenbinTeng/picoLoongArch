`timescale 1ns / 1ps

module regfile(
    input           clk,
    input           rst,
    input           we,
    input   [ 4:0]  ra,
    input   [ 4:0]  rb,
    input   [ 4:0]  rd,
    input   [31:0]  di,
    output  [31:0]  qa,
    output  [31:0]  qb
    );
    
    reg [31:0]regfile[31:0];
    
    assign qa = regfile[ra];
    assign qb = regfile[rb];
    
    integer i;
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            for (i = 0; i < 32; i = i + 1) regfile[i] <= 0;
        end
        else begin
            if (we & rd != 5'b0) regfile[rd] <= di;
        end
    end 
    
endmodule
