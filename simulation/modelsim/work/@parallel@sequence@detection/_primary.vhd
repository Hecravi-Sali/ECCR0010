library verilog;
use verilog.vl_types.all;
entity ParallelSequenceDetection is
    generic(
        WID_Bitstream   : integer := 0;
        WID_Compair     : integer := 0;
        WID_Compair_count: integer := 0
    );
    port(
        PSD_local_busy  : out    vl_logic;
        PSD_local_position: out    vl_logic_vector;
        PSD_local_count : out    vl_logic_vector;
        local_PSD_clk   : in     vl_logic;
        local_PSD_reset : in     vl_logic;
        local_PSD_newstream: in     vl_logic;
        local_PSD_compair: in     vl_logic_vector;
        local_PSD_bitstream: in     vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of WID_Bitstream : constant is 1;
    attribute mti_svvh_generic_type of WID_Compair : constant is 1;
    attribute mti_svvh_generic_type of WID_Compair_count : constant is 1;
end ParallelSequenceDetection;
