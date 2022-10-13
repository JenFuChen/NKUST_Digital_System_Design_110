library verilog;
use verilog.vl_types.all;
entity HW2_vlg_check_tst is
    port(
        Sum             : in     vl_logic_vector(10 downto 0);
        Valid           : in     vl_logic;
        temp            : in     vl_logic_vector(10 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW2_vlg_check_tst;
