`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module store(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [31:0] imm,
    input logic [2:0] store_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_write_data,
    output logic [3:0] mem_byte_en
);

logic state;
logic nextstate;

always_comb 
begin

   if (state == 0) begin
    if (store_control != `STR_NOP) begin
            nextstate =1;
            ignore_curr_inst = 0;
            mem_addr = rs1_val + imm; // cycle 0
            stall_pc = 1;
            mem_rw_mode = 1'b0;
            case (store_control)

            3'd1 : begin
                case (mem_addr[1:0])
                    2'b00 : begin
                        mem_byte_en = 4'b0001;
                        mem_write_data =  {{24{1'b0}}, rs2_val[7:0]};
                    end
                    2'b01 :begin
                         mem_byte_en = 4'b0010;
                         mem_write_data =  {{16{1'b0}}, rs2_val[7:0], {8{1'b0}}};
                    end
                    2'b10 : begin
                         mem_byte_en = 4'b0100;
                         mem_write_data = {{8{1'b0}}, rs2_val[7:0], {16{1'b0}}};
                    end
                    2'b11 : begin
                        mem_byte_en = 4'b1000;
                        mem_write_data = {rs2_val[7:0], {24{1'b0}}};
                    end
                endcase
            end

            3'd2 : begin
                case (mem_addr[1])
                1'b0 : begin
                    mem_byte_en = 4'b0011;
                    mem_write_data = {{16{1'b0}}, rs2_val[15:0]};
                end
                1'b1 : begin
                     mem_byte_en = 4'b1100;
                     mem_write_data = {rs2_val[15:0],{16{1'b0}}};
                end
                endcase
            end

            3'd3 : begin
                mem_write_data = rs2_val;
                mem_byte_en = 4'b1111;
            end

            endcase
     end else begin
            nextstate = 0;
            mem_rw_mode = 1;
            stall_pc = 0;
            mem_addr = 0;
            ignore_curr_inst = 0;
            mem_write_data = 0;
            mem_byte_en = 0;
    end 
   end if (state == 1) begin
            nextstate = 0;
            ignore_curr_inst = 1;
            mem_addr = 0; 
            stall_pc = 0;
            mem_rw_mode = 1'b1;
            mem_write_data = 0;
            mem_byte_en = 0;
   end
end

always_ff @(posedge i_clk or negedge i_rst) begin 
    if (~i_rst) begin
        state <= 0; 
    end else begin
        state <= nextstate;
    end
    
end


endmodule