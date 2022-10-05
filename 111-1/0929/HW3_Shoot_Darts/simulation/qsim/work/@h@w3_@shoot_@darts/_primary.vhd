library verilog;
use verilog.vl_types.all;
entity HW3_Shoot_Darts is
    port(
        x1              : in     vl_logic_vector(3 downto 0);
        x2              : in     vl_logic_vector(3 downto 0);
        x3              : in     vl_logic_vector(3 downto 0);
        x4              : in     vl_logic_vector(3 downto 0);
        y1              : in     vl_logic_vector(3 downto 0);
        y2              : in     vl_logic_vector(3 downto 0);
        y3              : in     vl_logic_vector(3 downto 0);
        y4              : in     vl_logic_vector(3 downto 0);
        A               : out    vl_logic_vector(2 downto 0);
        B               : out    vl_logic_vector(2 downto 0);
        C               : out    vl_logic_vector(2 downto 0);
        D               : out    vl_logic_vector(2 downto 0);
        Max             : out    vl_logic_vector(2 downto 0)
    );
end HW3_Shoot_Darts;
