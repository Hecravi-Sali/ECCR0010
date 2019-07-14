library verilog;
use verilog.vl_types.all;
entity ParallelSequenceDetection_test is
    generic(
        WID_Bitstream   : integer := 3;
        WID_Compair     : integer := 11;
        WID_Compair_count: vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WID_Bitstream : constant is 1;
    attribute mti_svvh_generic_type of WID_Compair : constant is 1;
    attribute mti_svvh_generic_type of WID_Compair_count : constant is 3;
end ParallelSequenceDetection_test;
