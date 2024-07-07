
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_reg_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [4:0] alu_control
);

logic [31:25] func7;
logic [14:12] func3;





always_comb
begin
 func3=instruction_code[14:12];
 func7=instruction_code[31:25];
 rd=instruction_code[11:7];
 rs1= instruction_code[19:15];
 rs2 = instruction_code[24:20];

    if(func3==3'h0)
    begin
        if(func7==7'h00)
        begin
            alu_control= `ADD;
        end
        else
        begin
            alu_control= `SUB;
        end
    end

    else if(func3==3'h1)
    begin
        alu_control= `SLL;
    end

    else if(func3==3'h2)
    begin
        alu_control= `SLT;
    end

    else if(func3==3'h3)
    begin
        alu_control= `SLTU;
    end

    else if(func3==3'h4)
    begin
        alu_control= `XOR;
    end

    else if(func3==3'h5)
    begin
        if(func7==7'h00)
        begin
            alu_control= `SRL;
        end
        else
        begin
            alu_control= `SRA;
        end
    end

    else if(func3==3'h6)
    begin
        alu_control= `OR;
    end

    else if(func3==3'h7)
    begin
        alu_control= `AND;
    end  

    

end

`ifndef SUBMODULE_DISABLE_WAVES
   initial
     begin
        $dumpfile("./sim_build/decode_reg_inst.vcd");
        $dumpvars(0, decode_reg_inst);
     end
 `endif

endmodule
