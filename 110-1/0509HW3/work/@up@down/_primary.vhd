library verilog;
use verilog.vl_types.all;
entity UpDown is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        up_down         : in     vl_logic;
        count           : out    vl_logic_vector(3 downto 0)
    );
end UpDown;
