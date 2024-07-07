`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_jump_inst(
    input logic [31:0] instruction_code,

    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [20:0] imm,
    output logic [1:0] jump_control
);
logic [6:0] opcode ;
logic [2:0] func3;

always@(*) begin
    rd = instruction_code[11:7];
 
    func3 = instruction_code[14:12];
   
    opcode = instruction_code[6:0];
  
    case(opcode) 
    7'd111 : begin
        imm[20:0] ={instruction_code[31],instruction_code[19:12],instruction_code[20],instruction_code[30:21],1'b0} ;
        jump_control = `JAL; 
        rs1 = 'b0;
    end
    7'd103 :begin
        if(func3 == 'b0) begin
            imm = instruction_code[31:20];
            for(int i = 20 ; i >= 19 ; i = i-1)
            begin
                imm[i] = 1'b0 ;
            end
           rs1 = instruction_code[19:15];

         jump_control = `JALR;
        end
        else begin
            jump_control = `JMP_NOP;
            rs1 = 'b0;
            imm = 'b0;
        end
    end

    default : begin
        jump_control = `JMP_NOP;
        rs1 = 'b0;
        imm = 'b0;
    end
    endcase


end
`ifndef SUBMODULE_DISABLE_WAVES
   initial
     begin
        $dumpfile("./sim_build/decode_jump_inst.vcd");
        $dumpvars(0, decode_jump_inst);
     end
 `endif

endmodule