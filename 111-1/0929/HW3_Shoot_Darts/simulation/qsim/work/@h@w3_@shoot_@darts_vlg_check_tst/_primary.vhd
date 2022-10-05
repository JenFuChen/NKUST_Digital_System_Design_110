library verilog;
use verilog.vl_types.all;
entity HW3_Shoot_Darts_vlg_check_tst is
    port(
        A               : in     vl_logic_vector(2 downto 0);
        B               : in     vl_logic_vector(2 downto 0);
        C               : in     vl_logic_vector(2 downto 0);
        D               : in     vl_logic_vector(2 downto 0);
        Max             : in     vl_logic_vector(2 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW3_Shoot_Darts_vlg_check_tst;
