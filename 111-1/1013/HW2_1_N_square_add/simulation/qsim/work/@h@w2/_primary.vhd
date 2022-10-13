library verilog;
use verilog.vl_types.all;
entity HW2 is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        EN              : in     vl_logic;
        Valid           : out    vl_logic;
        Order           : in     vl_logic_vector(3 downto 0);
        Sum             : out    vl_logic_vector(10 downto 0);
        temp            : out    vl_logic_vector(10 downto 0)
    );
end HW2;
