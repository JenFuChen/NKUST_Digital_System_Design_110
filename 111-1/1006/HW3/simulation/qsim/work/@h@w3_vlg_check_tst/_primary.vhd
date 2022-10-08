library verilog;
use verilog.vl_types.all;
entity HW3_vlg_check_tst is
    port(
        Valid           : in     vl_logic;
        \out\           : in     vl_logic_vector(39 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW3_vlg_check_tst;
