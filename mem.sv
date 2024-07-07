
module mem(
    input logic i_clk,
    input logic i_rst,
    input logic [9:0] in_mem_addr,
    input logic in_mem_re_web,
    input logic [31:0] in_mem_write_data,
    input logic [3:0] in_mem_byte_en,
    output logic [31:0] out_mem_data
);

endmodule
