library verilog;
use verilog.vl_types.all;
entity ParallelSequenceDetection_test is
    generic(
        WID_Bitstream   : integer := 8;
        WID_Compair     : integer := 6
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WID_Bitstream : constant is 1;
    attribute mti_svvh_generic_type of WID_Compair : constant is 1;
end ParallelSequenceDetection_test;
