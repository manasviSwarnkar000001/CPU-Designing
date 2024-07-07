`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_branch_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [12:0] imm,
    output logic [2:0] branch_control
);

logic [2:0] func3;

always_comb
begin
    rs1= instruction_code[19:15];
    rs2 =instruction_code[24:20];
    func3=instruction_code[14:12];
    imm={instruction_code[31],instruction_code[7],instruction_code[30:25],instruction_code[11:8],1'b0};



    case(func3)
    
    3'h0 : branch_control=`BEQ;
    3'h1 : branch_control=`BNE;
    3'h4 : branch_control=`BLT;
    3'h5 : branch_control=`BGE;
    3'h6 : branch_control=`BLTU;
    3'h7 : branch_control=`BGEU;
    default: branch_control = `BR_NOP;    
    endcase

end

endmodule
