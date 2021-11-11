`timescale 1ns / 1ps

module alu(
    input   [31:0]  operand_a,
    input   [31:0]  operand_b,
    input   [ 1:0]  operation,
    output  [31:0]  result
    );
    
    reg [31:0] result;
    
    always @(*) begin 
        case(operation)
            2'b00:  result = 0;
            2'b01:  result = operand_a + operand_b;
            2'b10:  result = operand_a | operand_b;
            2'b11:  result = 0;
        endcase
    end
    
endmodule
