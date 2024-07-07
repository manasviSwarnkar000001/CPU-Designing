import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock

@cocotb.coroutine
async def reset_dut(dut):
    """ Reset the DUT """
    dut.i_rst.value = 0
    for _ in range(2):
        await RisingEdge(dut.i_clk)
    dut.i_rst.value = 1
    await RisingEdge(dut.i_clk)

async def load_hex(dut):
    hex_file_path = f"./firmware/work/firmware_wish_riscv_full.hex"
    with open(hex_file_path, 'r') as f:
        hex_file = f.read().splitlines()
    for ii in range(1024):
        dut.inst_mem.memory_reg[ii].value = int(hex_file[ii], 16)
    cocotb.log.info("loaded hexfile into Memory")


@cocotb.test()
async def test_core_from_hexfile(dut):
    """ Test the complete RV32I instruction set of the RV32I CPU module """

    # Create a clock signal
    cocotb.start_soon(Clock(dut.i_clk, 10, units="ns").start())

    # Reset the DUT
    await load_hex(dut=dut)
    await reset_dut(dut=dut)

    await Timer(1600, "ns")
    # while(int(dut.instruction_code.value) != 32871):
    # for i in range(1024):
    #     await RisingEdge(dut.i_clk)

    # await RisingEdge(dut.i_clk)


