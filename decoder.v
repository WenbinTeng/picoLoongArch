`timescale 1ns / 1ps

module decoder(
    input           clk,
    input           rst,
    input   [31:0]  inst,
    input   [31:0]  addr,
    input   [31:0]  alu_data,
    input   [31:0]  ram_data,
    output  [31:0]  qa,
    output  [31:0]  qb,
    output  [31:0]  operand_a,
    output  [31:0]  operand_b,
    output  [ 1:0]  alu_op,
    output          bpu_op,
    output          ram_re,
    output          ram_we
    );
    
    wire i_bne = inst[31:26] == 6'b010111;
    wire i_add = inst[31:15] == 17'b00000000000100000;
    wire i_ori = inst[31:22] == 10'b000001110;
    wire i_ld = inst[31:22] == 10'b0010101000;
    wire i_st = inst[31:22] == 10'b0010100100;
    
    assign alu_op = (i_bne | i_add | i_ld | i_st) ? 2'b01 : i_ori ? 2'b10 : 2'b00;
    assign bpu_op = i_bne;
    assign ram_re = i_ld;
    assign ram_we = i_st;
    
    wire [ 4:0] ra = (i_bne | i_st) ? inst[4:0] : i_add ? inst[14:10] : 0;
    wire [ 4:0] rb = inst[9:5];
    wire [ 4:0] rd = inst[4:0];
    wire        we = i_add | i_ori | i_ld;
    wire [31:0] qa;
    wire [31:0] qb;
    wire [31:0] di = ram_re ? ram_data : alu_data;
    
    assign operand_a = i_bne ? {{16{inst[25]}}, inst[25:10]} : i_ori ? {20'b0, inst[21:10]} : (i_ld | i_st) ? {{20{inst[21]}}, inst[21:10]} : i_add ? qa : 0;
    assign operand_b = i_bne ? addr : (i_add | i_ori | i_ld | i_st) ? qb : 0;
    
    regfile u_regfile (
        .clk    (clk),
        .rst    (rst),
        .we     (we),
        .ra     (ra),
        .rb     (rb),
        .rd     (rd),
        .di     (di),
        .qa     (qa),
        .qb     (qb)
    );
    
endmodule
