library verilog;
use verilog.vl_types.all;
entity HW2_vlg_sample_tst is
    port(
        CLK             : in     vl_logic;
        EN              : in     vl_logic;
        Order           : in     vl_logic_vector(3 downto 0);
        RST             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end HW2_vlg_sample_tst;
