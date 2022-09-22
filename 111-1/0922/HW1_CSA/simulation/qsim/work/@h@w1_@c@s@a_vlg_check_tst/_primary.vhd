library verilog;
use verilog.vl_types.all;
entity HW1_CSA_vlg_check_tst is
    port(
        Cout            : in     vl_logic;
        SUM             : in     vl_logic_vector(16 downto 0);
        sampler_rx      : in     vl_logic
    );
end HW1_CSA_vlg_check_tst;
