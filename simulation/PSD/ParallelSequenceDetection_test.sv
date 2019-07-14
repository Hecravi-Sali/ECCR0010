`timescale 1ns/1ns
/*
 * 
 */
module ParallelSequenceDetection_test();
   /*parameter list*/
   parameter WID_Bitstream = 3;
   parameter WID_Compair = 11;
   parameter WID_Compair_count = $clog2(WID_Bitstream);

   localparam WID_Detection = WID_Compair + WID_Bitstream;
   localparam NUM_Buffer = (WID_Detection / WID_Bitstream) * WID_Bitstream == WID_Detection ?
                           (WID_Detection / WID_Bitstream) :
                           (WID_Detection / WID_Bitstream) + 1;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 PSD_local_busy;         // From inst of ParallelSequenceDetection.v
   logic [WID_Compair_count-1:0] PSD_local_count;// From inst of ParallelSequenceDetection.v
   logic [WID_Bitstream-1:0] PSD_local_position;// From inst of ParallelSequenceDetection.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [WID_Bitstream-1:0] local_PSD_bitstream; // To inst of ParallelSequenceDetection.v
   reg                  local_PSD_clk;          // To inst of ParallelSequenceDetection.v
   reg [WID_Compair-1:0] local_PSD_compair;     // To inst of ParallelSequenceDetection.v
   reg                  local_PSD_newstream;    // To inst of ParallelSequenceDetection.v
   reg                  local_PSD_reset;        // To inst of ParallelSequenceDetection.v
   // End of automatics

   ParallelSequenceDetection
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WID_Bitstream                   (WID_Bitstream),
       .WID_Compair                     (WID_Compair),
       .WID_Compair_count               (WID_Compair_count))
   inst
     (/*AUTOINST*/
      // Outputs
      .PSD_local_busy                   (PSD_local_busy),
      .PSD_local_position               (PSD_local_position[WID_Bitstream-1:0]),
      .PSD_local_count                  (PSD_local_count[WID_Compair_count-1:0]),
      // Inputs
      .local_PSD_clk                    (local_PSD_clk),
      .local_PSD_reset                  (local_PSD_reset),
      .local_PSD_newstream              (local_PSD_newstream),
      .local_PSD_compair                (local_PSD_compair[WID_Compair-1:0]),
      .local_PSD_bitstream              (local_PSD_bitstream[WID_Bitstream-1:0]));
   //==== Stimulus ====//
   integer _randseed;

   always @(posedge local_PSD_clk) begin
      if($get_coverage() == 100) begin
         $stop();
      end
   end

   initial begin
      local_PSD_clk = 1;
      local_PSD_reset = 1;
      #20 local_PSD_reset = 0;

      forever #5 local_PSD_clk = ~local_PSD_clk;
   end

   function bit [WID_Bitstream - 1 : 0] referencemode;
      static bit _isstarted = 0;
      static bit [WID_Bitstream * NUM_Buffer - 1 : 0] _buffer;
      static int _count;
      static bit [WID_Compair - 1 : 0] _compairstr;

      if(local_PSD_newstream) begin
         _isstarted = 1;
         _compairstr = local_PSD_compair;
         _count = NUM_Buffer - 1;
         _buffer = 0;
         _buffer[WID_Bitstream - 1 : 0] = local_PSD_bitstream;
         referencemode = 0;
      end
      else begin
         if(_isstarted) begin
            _buffer = {_buffer[WID_Bitstream * (NUM_Buffer - 1) - 1 : 0], local_PSD_bitstream};
            if(_count != 1) begin
               _count = _count - 1;
            end
            else begin
               for(int i = 0; i < WID_Bitstream; i++) begin
                  referencemode[i] = (_buffer[i +: WID_Compair]  == _compairstr);
               end
            end
         end
      end

   endfunction

   logic repeatcontrol;
   logic [WID_Compair - 1 : 0] repeatdata;
   always @(posedge local_PSD_clk or posedge local_PSD_reset) begin
      if(local_PSD_reset) begin
         repeatcontrol <= 0;
         repeatdata <= 0;
         local_PSD_newstream <= 0;
         local_PSD_compair <= 0;
         local_PSD_bitstream <= 0;
      end
      else begin
         local_PSD_newstream <= ({$random(_randseed)} % 100 > 98) ? 1'B1 : 1'B0;
         if(repeatcontrol) begin
            local_PSD_bitstream <= repeatdata;
         end
         else begin
            local_PSD_bitstream <= $random(_randseed);
         end
         local_PSD_compair <= $random(_randseed);

         if(local_PSD_newstream) begin
            repeatcontrol <= ({$random(_randseed)} % 100 > 49) ? 1'B1 : 1'B0;
            repeatdata <= local_PSD_compair;
         end
      end
   end

   logic [WID_Bitstream * 2 - 1 : 0] _compairx;
   always @(posedge local_PSD_clk or posedge local_PSD_reset) begin
      if(local_PSD_reset) begin
         _compairx <= {WID_Bitstream * 2{1'B0}};
      end
      else begin
         if(local_PSD_newstream) begin
            _compairx <= {{WID_Bitstream{1'B0}}, referencemode()};
         end
         else begin
            _compairx <= {_compairx[0 +: WID_Bitstream], referencemode()};
         end
      end
   end

   Scoreboard_a : assert property(@(posedge local_PSD_clk) disable iff(local_PSD_reset)
                                  (PSD_local_busy) |-> (_compairx[WID_Bitstream * 2 - 1 -: WID_Bitstream] == PSD_local_position));

   covergroup cg @(posedge local_PSD_clk);
      option.per_instance = 1;
      option.goal = 100;
      cg_PSD_local_position : coverpoint PSD_local_position{
         option.weight = 50;
      }
      cg_local_PSD_compair : coverpoint local_PSD_compair {
         option.weight = 50;
         option.auto_bin_max = 2 ** 16;
      }
      cross cg_PSD_local_position, cg_local_PSD_compair{
                                                        option.weight = 0;
                                                        }
   endgroup

   cg cg_inst = new();

endmodule

// Local Variables:
// verilog-library-directories:("../../src/PSD/")
// End:
