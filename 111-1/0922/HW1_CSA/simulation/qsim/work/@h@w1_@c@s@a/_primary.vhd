library verilog;
use verilog.vl_types.all;
entity HW1_CSA is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        Cin             : in     vl_logic_vector(15 downto 0);
        Cout            : out    vl_logic;
        SUM             : out    vl_logic_vector(16 downto 0)
    );
end HW1_CSA;
