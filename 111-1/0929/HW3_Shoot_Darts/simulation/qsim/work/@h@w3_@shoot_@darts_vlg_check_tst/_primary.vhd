library verilog;
use verilog.vl_types.all;
entity HW3_Shoot_Darts_vlg_check_tst is
    port(
        A_s             : in     vl_logic_vector(2 downto 0);
        B_s             : in     vl_logic_vector(2 downto 0);
        C_s             : in     vl_logic_vector(2 downto 0);
        D_s             : in     vl_logic_vector(2 downto 0);
        Maxs            : in     vl_logic_vector(2 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW3_Shoot_Darts_vlg_check_tst;
