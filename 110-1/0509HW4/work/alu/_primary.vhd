library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        op              : in     vl_logic_vector(2 downto 0);
        c               : out    vl_logic_vector(7 downto 0)
    );
end alu;
