library verilog;
use verilog.vl_types.all;
entity GCC is
    port(
        \READY_\        : out    vl_logic;
        Xc              : out    vl_logic_vector(7 downto 0);
        Yc              : out    vl_logic_vector(7 downto 0);
        Xi              : in     vl_logic_vector(7 downto 0);
        Yi              : in     vl_logic_vector(7 downto 0);
        Wi              : in     vl_logic_vector(3 downto 0);
        \RESET_\        : in     vl_logic;
        CLK             : in     vl_logic
    );
end GCC;
