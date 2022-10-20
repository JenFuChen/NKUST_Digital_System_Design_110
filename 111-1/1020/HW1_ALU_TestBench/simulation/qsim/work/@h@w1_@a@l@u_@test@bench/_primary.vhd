library verilog;
use verilog.vl_types.all;
entity HW1_ALU_TestBench is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        C               : in     vl_logic_vector(4 downto 0);
        Sel             : in     vl_logic_vector(1 downto 0);
        Alu             : out    vl_logic_vector(8 downto 0)
    );
end HW1_ALU_TestBench;
