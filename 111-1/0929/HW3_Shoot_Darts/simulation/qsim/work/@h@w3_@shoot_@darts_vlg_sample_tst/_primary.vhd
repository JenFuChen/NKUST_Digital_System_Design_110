library verilog;
use verilog.vl_types.all;
entity HW3_Shoot_Darts_vlg_sample_tst is
    port(
        x1              : in     vl_logic_vector(3 downto 0);
        x2              : in     vl_logic_vector(3 downto 0);
        x3              : in     vl_logic_vector(3 downto 0);
        x4              : in     vl_logic_vector(3 downto 0);
        y1              : in     vl_logic_vector(3 downto 0);
        y2              : in     vl_logic_vector(3 downto 0);
        y3              : in     vl_logic_vector(3 downto 0);
        y4              : in     vl_logic_vector(3 downto 0);
        sampler_tx      : out    vl_logic
    );
end HW3_Shoot_Darts_vlg_sample_tst;
