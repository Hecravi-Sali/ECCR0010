`timescale 1ns/1ns
/*
 * 
 */
module ParallelSequenceDetection_test();
   /*parameter list*/
   parameter WID_Bitstream = 8;
   parameter WID_Compair = 6;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 PSD_local_busy;         // From inst of ParallelSequenceDetection.v
   wire [WID_Bitstream-1:0] PSD_local_position; // From inst of ParallelSequenceDetection.v
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
       .WID_Compair                     (WID_Compair))
   inst
     (/*AUTOINST*/
      // Outputs
      .PSD_local_busy                   (PSD_local_busy),
      .PSD_local_position               (PSD_local_position[WID_Bitstream-1:0]),
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
      local_PSD_newstream = 0;
      #20 local_PSD_reset = 0;

      forever #5 local_PSD_clk = ~local_PSD_clk;
   end

   always @(posedge local_PSD_clk or posedge local_PSD_reset) begin
      if(local_PSD_reset) begin
         local_PSD_compair <= 0;
         local_PSD_bitstream <= 0;
      end
      else begin

      end
   end

   function [WID_Bitstream - 1 : 0] reference;

      
   endfunction

endmodule

// Local Variables:
// verilog-library-directories:("../../src/PSD/")
// End:
