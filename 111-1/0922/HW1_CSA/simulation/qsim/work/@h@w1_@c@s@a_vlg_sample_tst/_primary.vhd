library verilog;
use verilog.vl_types.all;
entity HW1_CSA_vlg_sample_tst is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        Cin             : in     vl_logic_vector(15 downto 0);
        sampler_tx      : out    vl_logic
    );
end HW1_CSA_vlg_sample_tst;
