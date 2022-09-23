library verilog;
use verilog.vl_types.all;
entity alu_tb is
    generic(
        PAT_NUM         : integer := 2048
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of PAT_NUM : constant is 1;
end alu_tb;
