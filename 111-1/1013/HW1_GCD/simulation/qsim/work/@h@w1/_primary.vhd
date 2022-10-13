library verilog;
use verilog.vl_types.all;
entity HW1 is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        EN              : in     vl_logic;
        Valid           : out    vl_logic;
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        outcome         : out    vl_logic_vector(10 downto 0)
    );
end HW1;
