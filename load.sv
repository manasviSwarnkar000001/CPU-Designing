`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module load(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] imm,
    input logic [31:0] mem_data,
    input logic [4:0] rd_in,
    input logic [2:0] load_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic rd_write_control,
    output logic [4:0] rd_out,
    output logic [31:0] rd_write_val,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr
);
    parameter RESET_STATE = 0;
    parameter READ_MEM=1;
    logic state;
    logic next_state;
    logic [2:0] load_control_s;
    logic [4:0] rd_s;
    logic [31:0]mem_addr_s;

    assign mem_rw_mode =1'b1;

    always@(posedge i_clk or negedge i_rst) begin

        if(~i_rst) begin
            state <= 'b0;
            load_control_s<= 'b0;
            rd_s <= 'b0;
            mem_addr_s<='b0;
        end
        else begin
            load_control_s<= load_control;
            rd_s <= rd_in;
            state <= next_state; 
            mem_addr_s<= mem_addr;
        end

    end

    always@(*) begin
            case(state) 
            RESET_STATE: begin
                ignore_curr_inst='b0;
                rd_write_control='b0;
                rd_write_val='b0;
                rd_out='b0;
                if(|load_control) begin
                    mem_addr= imm+ rs1_val;
                    stall_pc='b1; 
                    next_state = READ_MEM;
                    end
                else begin
                next_state = RESET_STATE;
                stall_pc='b0;
                mem_addr='b0;
                ignore_curr_inst='b0;
                rd_write_control='b0;
                rd_write_val='b0;
                end
            end
            

            READ_MEM: begin
                case(load_control_s)

                `LD_NOP: begin 
                    rd_write_control='b0;
                    rd_write_val='b0; end

                `LB: begin
                    rd_write_control=1'b1;
                    if(mem_addr_s[1:0]==2'b00)
                    rd_write_val= {{24{mem_data[7]}},mem_data[7:0]};
                    else if(mem_addr_s[1:0]==2'b01)
                    rd_write_val= {{24{mem_data[15]}},mem_data[15:8]};
                    else if(mem_addr_s[1:0]==2'b10)
                    rd_write_val= {{24{mem_data[23]}},mem_data[23:16]};
                    else
                    rd_write_val= {{24{mem_data[31]}},mem_data[31:24]};
                     end

                `LH:begin
                    rd_write_control='b1;
                    if(mem_addr_s[1]==0)
                    rd_write_val= {{16{mem_data[15]}},mem_data[15:0]};
                    else 
                    rd_write_val= {{16{mem_data[31]}},mem_data[31:16]};
                    end

                `LW:begin
                    rd_write_val = mem_data;
                    rd_write_control=1'b1;
                    end
                    
                `LBU:begin
                    rd_write_control=1'b1;
                    if(mem_addr_s[1:0]==2'b00)
                    rd_write_val= {24'b0,mem_data[7:0]};
                    else if(mem_addr_s[1:0]==2'b01)
                    rd_write_val= {24'b0,mem_data[15:8]};
                    else if(mem_addr_s[1:0]==2'b10)
                    rd_write_val= {24'b0,mem_data[23:16]};
                    else
                    rd_write_val= {24'b0,mem_data[31:24]};
                     end
                `LHU:begin
                    rd_write_control=1'b1;
                    if(mem_addr_s[1]==0)
                    rd_write_val= {16'b0,mem_data[15:0]};
                    else 
                    rd_write_val= {16'b0,mem_data[31:16]};
                     end
                endcase

                stall_pc=1'b0;
                ignore_curr_inst='b1;
                rd_out= rd_s;
                next_state = RESET_STATE;
                mem_addr='b0;
            end

            endcase
    end

`ifndef SUBMODULE_DISABLE_WAVES
   initial
     begin
        $dumpfile("./sim_build/load.vcd");
        $dumpvars(0, load);
     end
 `endif

endmodule