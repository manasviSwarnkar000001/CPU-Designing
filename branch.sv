`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif


module branch(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] pc,
    input logic [31:0] imm,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [2:0] branch_control,
    output logic pc_update_control,
    output logic [31:0] pc_update_val,
    output logic ignore_curr_inst
);

logic state;
logic nextstate;
logic k;

always_comb begin 
    if (state==0) begin
        if (branch_control!=`BR_NOP) begin
            ignore_curr_inst = 0;
            case (branch_control)
                `BEQ : k = (rs1_val == rs2_val);
                `BNE : k = (rs1_val != rs2_val);
                `BLT:  k = (rs1_val < rs2_val);
                `BGE: k = (rs1_val >= rs2_val);
                `BLTU: k = ({1'b0, rs1_val} < {1'b0, rs2_val});
                `BGEU:  k = ({1'b0, rs1_val} >= {1'b0, rs2_val}); 
                default: k=0;
        
            endcase
            if (k==1) begin
                pc_update_val = pc + imm;
                pc_update_control = 1;
                nextstate =1;
            end else begin 
                pc_update_val = 0;
                pc_update_control = 0;
                nextstate =0;
            end

        end else begin
            nextstate =0;
            pc_update_control = 0;
            pc_update_val = 0;
            ignore_curr_inst = 0;
        end
    end if (state ==1) begin
        nextstate = 0;
        pc_update_control = 0;
        pc_update_val = 0;
        ignore_curr_inst = 1;
    end
    
end

always_ff @( posedge i_clk or negedge i_rst ) begin 

if (~i_rst) begin
    state <= 0;
end else begin
    state<=nextstate;
end
    
end

endmodule