library verilog;
use verilog.vl_types.all;
entity HW3_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        En              : in     vl_logic;
        RST             : in     vl_logic;
        num             : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end HW3_vlg_sample_tst;
