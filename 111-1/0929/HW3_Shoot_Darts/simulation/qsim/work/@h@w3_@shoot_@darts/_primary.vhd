library verilog;
use verilog.vl_types.all;
entity HW3_Shoot_Darts is
    port(
        a_x             : in     vl_logic_vector(3 downto 0);
        a_y             : in     vl_logic_vector(3 downto 0);
        b_x             : in     vl_logic_vector(3 downto 0);
        b_y             : in     vl_logic_vector(3 downto 0);
        c_x             : in     vl_logic_vector(3 downto 0);
        c_y             : in     vl_logic_vector(3 downto 0);
        d_x             : in     vl_logic_vector(3 downto 0);
        d_y             : in     vl_logic_vector(3 downto 0);
        A_s             : out    vl_logic_vector(2 downto 0);
        B_s             : out    vl_logic_vector(2 downto 0);
        C_s             : out    vl_logic_vector(2 downto 0);
        D_s             : out    vl_logic_vector(2 downto 0);
        Maxs            : out    vl_logic_vector(2 downto 0)
    );
end HW3_Shoot_Darts;
