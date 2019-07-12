`timescale 1ns/1ns
/*
 * 
 */
module BitCounter_test();
   /*parameter list*/
   parameter WID_CountRange = 8;
   parameter WID_CountResult = 2 ** $clog2(WID_CountRange) == WID_CountRange ?
                               $clog2(WID_CountRange) + 1 :
                               $clog2(WID_CountRange);

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [WID_CountResult-1:0] BC_local_result;  // From inst of BitCounter.v
   // End of automatics
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg [WID_CountRange-1:0] local_BC_bitstream; // To inst of BitCounter.v
   // End of automatics

   BitCounter
     #(/*AUTOINSTPARAM*/
       // Parameters
       .WID_CountRange                  (WID_CountRange),
       .WID_CountResult                 (WID_CountResult))
   inst
     (/*AUTOINST*/
      // Outputs
      .BC_local_result                  (BC_local_result[WID_CountResult-1:0]),
      // Inputs
      .local_BC_bitstream               (local_BC_bitstream[WID_CountRange-1:0]));
   //==== Stimulus ====//
   logic clk;
   logic [WID_CountResult - 1 : 0] resultdelay;
   integer _randseed;

   always @(posedge clk) begin
      if($get_coverage() == 100) begin
         $stop();
      end
   end

   initial begin
      clk = 1;
      local_BC_bitstream = 0;
      forever #5 clk = ~clk;
   end

   always @(posedge clk) begin
      local_BC_bitstream <= $random(_randseed);
      resultdelay <= BC_local_result;
   end

   function bit Check;
      input [WID_CountRange - 1 : 0] bitstream;

      int shiftcount;
      int count;
      shiftcount = bitstream;
      count = 0;
      for(int i = 0; i < WID_CountRange; i++) begin
         if(shiftcount[0]) begin
            count++;
         end
         shiftcount = shiftcount >> 1;
      end
      Check = count == resultdelay;
   endfunction

   ScoreBoard_a : assert property (@(posedge clk) (Check(local_BC_bitstream)));

   covergroup cg @(posedge clk);
      coverpoint local_BC_bitstream {
         option.auto_bin_max = 4096;
      }
   endgroup

   cg cg_inst = new();
endmodule // BitCounter_test

// Local Variables:
// verilog-library-directories:("../../src/BC/")
// End:
