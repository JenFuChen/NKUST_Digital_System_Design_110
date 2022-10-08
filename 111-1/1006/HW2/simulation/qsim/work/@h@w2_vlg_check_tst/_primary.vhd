library verilog;
use verilog.vl_types.all;
entity HW2_vlg_check_tst is
    port(
        c               : in     vl_logic_vector(7 downto 0);
        d               : in     vl_logic_vector(7 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW2_vlg_check_tst;
