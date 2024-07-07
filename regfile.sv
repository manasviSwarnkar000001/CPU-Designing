
module regfile(
    input logic i_clk,
    input logic i_rst,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic rd_write_control,
    input logic [31:0] rd_write_val,
    output logic [31:0] rs1_val,
    output logic [31:0] rs2_val
);

logic [31:0] register [32];

always_comb 
begin 
    rs1_val=register[rs1];
    rs2_val=register[rs2];    
    register[0]=0;
end

always@(posedge i_clk or negedge i_rst)
begin
    if(~i_rst)
    begin
    
        for(int i =1;i<32;i++)
        begin
            register[i]<=0;
        end
    end

    else
    begin
        if((rd_write_control==1'b1)& (rd !=0))
        begin
            register[rd]<=rd_write_val;
        end
    end  
end

endmodule
