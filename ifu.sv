
module ifu(
    input logic i_clk,
    input logic i_rst,
    input logic stall_pc,
    input logic pc_update_control,
    input logic [31:0] pc_update_val,
    output logic [31:0] pc,
    output logic [31:0] prev_pc
);

always@ (posedge i_clk or negedge i_rst)
begin
   if(~ i_rst)
   begin
      pc <=0;
      prev_pc <=0;
   end
   else   
   case(stall_pc)
      1'b1: pc<= pc;
      1'b0: case(pc_update_control)
               1'b1: pc <= pc_update_val;
               1'b0: pc <= pc+4;
            endcase
   endcase
end

`ifndef SUBMODULE_DISABLE_WAVES
   initial
     begin
        $dumpfile("./sim_build/ifu.vcd");
        $dumpvars(0, ifu);
     end
`endif

endmodule
