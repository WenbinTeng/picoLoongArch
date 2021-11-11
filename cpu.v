`timescale 1ns / 1ps

module cpu(
    input           clk,
    input           rst,
    input   [7:0]   num,
    output  [7:0]   led
    );
    
    wire [31:0] addr;
    wire [31:0] inst;
    
    wire        bpu_take;
    
    wire [31:0] alu_data;
    wire [31:0] ram_data;
    
    wire [31:0] qa;
    wire [31:0] qb;
    
    wire [31:0] operand_a;
    wire [31:0] operand_b;
    
    wire [ 1:0] alu_op;
    wire        bpu_op;
    wire        ram_re;
    wire        ram_we;
    
    reg [7:0] led;
    
    always @(posedge clk) begin
        if (ram_we) begin
            led <= qa;
        end
    end
    
    pc u_pc (
        .clk            (clk),
        .rst            (rst),
        .refill_flag    (bpu_take),
        .refill_addr    (alu_data),
        .addr           (addr)
    );
    
    rom u_rom (
        .addr           (addr),
        .inst           (inst)
    );
    
    ram u_ram (
        .clk            (clk),
        .rst            (rst),
        .num            (num),
        .re             (ram_re),
        .we             (ram_we),
        .di             (qa),
        .addr           (alu_data),
        .data           (ram_data)
    );
    
    decoder u_decoder (
        .clk            (clk),
        .rst            (rst),
        .inst           (inst),
        .addr           (addr),
        .alu_data       (alu_data),
        .ram_data       (ram_data),
        .qa             (qa),
        .qb             (qb),
        .operand_a      (operand_a),
        .operand_b      (operand_b),
        .alu_op         (alu_op),
        .bpu_op         (bpu_op),
        .ram_re         (ram_re),
        .ram_we         (ram_we)
    );
    
    alu u_alu (
        .operand_a      (operand_a),
        .operand_b      (operand_b),
        .operation      (alu_op),
        .result         (alu_data)
    );
    
    bpu u_bpu (
        .op             (bpu_op),
        .qa             (qa),
        .qb             (qb),
        .take           (bpu_take)
    );
    
endmodule
