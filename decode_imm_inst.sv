`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_imm_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rd,
    output logic [11:0] imm,
    output logic [4:0] alu_control
);

logic [2:0] func3;
logic [6:0] func7;

always_comb
begin
    rd=instruction_code[11:7];
    rs1= instruction_code[19:15];
    imm =instruction_code[31:20];
    func3=instruction_code[14:12];
    func7=imm[11:5];


    case(func3)
    
    3'h0 : alu_control=`ADDI;
    3'h1 : 
    if(func7==0)
    begin
    alu_control=`SLLI;
    end
    
    3'h2 : alu_control=`SLTI;
    3'h3 : alu_control=`SLTIU;
    3'h4 : alu_control=`XORI;
    3'h5 : 
    if(func7==0)
    begin
                alu_control=`SRLI;
    end
    else if(func7==7'h20)
    begin
    alu_control =`SRAI;
    end
    else
    begin
    alu_control =`ALU_NOP;
    end
    3'h6 : alu_control=`ORI;
    3'h7 : alu_control=`ANDI;
    default: alu_control = `ALU_NOP;    
    endcase

end


endmodule
