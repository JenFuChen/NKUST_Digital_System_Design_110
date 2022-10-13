library verilog;
use verilog.vl_types.all;
entity HW1_vlg_check_tst is
    port(
        Valid           : in     vl_logic;
        outcome         : in     vl_logic_vector(10 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW1_vlg_check_tst;
