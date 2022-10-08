library verilog;
use verilog.vl_types.all;
entity HW3_Shoot_Darts_vlg_sample_tst is
    port(
        a_x             : in     vl_logic_vector(3 downto 0);
        a_y             : in     vl_logic_vector(3 downto 0);
        b_x             : in     vl_logic_vector(3 downto 0);
        b_y             : in     vl_logic_vector(3 downto 0);
        c_x             : in     vl_logic_vector(3 downto 0);
        c_y             : in     vl_logic_vector(3 downto 0);
        d_x             : in     vl_logic_vector(3 downto 0);
        d_y             : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end HW3_Shoot_Darts_vlg_sample_tst;
