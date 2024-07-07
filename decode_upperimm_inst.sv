`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_upperimm_inst(
    input logic [31:0] instruction_code,
    output logic [4:0] rd,
    output logic [31:0] imm,
    output logic [4:0] alu_control
);

logic [6:0] opcode;

always_comb
begin
    rd=instruction_code[11:7];
    imm[31:12]=instruction_code[31:12];
    opcode=instruction_code[6:0];

    for(int i =11;i>=0;i=i-1)
    begin
        imm[i]=1'b0;
    end

    case(opcode)
        7'd55 : alu_control= `LUI;
        7'd23 : alu_control= `AUIPC;
        
        default : alu_control= `ALU_NOP;
    endcase

end

endmodule
