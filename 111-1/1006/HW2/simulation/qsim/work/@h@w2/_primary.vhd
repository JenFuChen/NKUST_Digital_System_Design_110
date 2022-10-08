library verilog;
use verilog.vl_types.all;
entity HW2 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        a               : in     vl_logic_vector(7 downto 0);
        b               : in     vl_logic_vector(7 downto 0);
        c               : out    vl_logic_vector(7 downto 0);
        d               : out    vl_logic_vector(7 downto 0)
    );
end HW2;
