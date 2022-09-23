library verilog;
use verilog.vl_types.all;
entity Average is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        data            : in     vl_logic_vector(7 downto 0);
        valid           : out    vl_logic;
        \out\           : out    vl_logic_vector(7 downto 0)
    );
end Average;
