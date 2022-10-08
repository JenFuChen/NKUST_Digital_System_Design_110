library verilog;
use verilog.vl_types.all;
entity HW3 is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        En              : in     vl_logic;
        Valid           : out    vl_logic;
        num             : in     vl_logic_vector(3 downto 0);
        \out\           : out    vl_logic_vector(39 downto 0)
    );
end HW3;
