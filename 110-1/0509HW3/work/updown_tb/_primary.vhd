library verilog;
use verilog.vl_types.all;
entity updown_tb is
    generic(
        up              : integer := 1;
        down            : integer := 0
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of up : constant is 1;
    attribute mti_svvh_generic_type of down : constant is 1;
end updown_tb;
