`timescale 1ns / 1ps

module pc(
    input           clk,
    input           rst,
    input           refill_flag,
    input   [31:0]  refill_addr,
    output  [31:0]  addr
    );
    
    reg [31:0]pcr;
    
    assign addr = !rst ? 0 : pcr;
    
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin
            pcr <= 32'hffffffff;
        end
        else if (refill_flag) begin 
            pcr <= refill_addr;
        end
        else begin
            pcr <= pcr + 32'h1;
        end
    end
    
endmodule
