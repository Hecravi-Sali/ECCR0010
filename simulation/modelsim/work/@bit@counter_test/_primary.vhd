library verilog;
use verilog.vl_types.all;
entity BitCounter_test is
    generic(
        WID_CountRange  : integer := 8;
        WID_CountResult : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WID_CountRange : constant is 1;
    attribute mti_svvh_generic_type of WID_CountResult : constant is 3;
end BitCounter_test;
