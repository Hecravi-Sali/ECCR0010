library verilog;
use verilog.vl_types.all;
entity BitCounter is
    generic(
        WID_CountRange  : integer := 0;
        WID_CountResult : integer := 0
    );
    port(
        BC_local_result : out    vl_logic_vector;
        local_BC_bitstream: in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WID_CountRange : constant is 1;
    attribute mti_svvh_generic_type of WID_CountResult : constant is 1;
end BitCounter;
