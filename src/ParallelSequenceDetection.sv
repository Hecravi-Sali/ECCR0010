/* ------- ------- -------
 * Belons      :
 * Connection  :
 * Features    :
 * Precautions :
 */
module ParallelSequenceDetection(/*AUTOARG*/);
   /* ------- ------- -------
    * parameter list
    */
   parameter WID_Bitstream = 0;
   parameter WID_Compair = 0;

   /* ------- ------- -------
    * localparam list
    */
   localparam WID_Buffer = WID_Bitstream * 2;

   localparam STS_Filling = 1'B0;
   localparam STS_Matching = 1'B1;

   /* ------- ------- -------
    * in/out port list
    */
   input                          local_PSD_clk;
   input                          local_PSD_reset;

   input                          local_PSD_newstream;
   output                         PSD_local_busy;
   input [WID_Compair - 1 : 0]    local_PSD_compair;
   input [WID_Bitstream - 1 : 0]  local_PSD_bitstream;

   output [WID_Bitstream - 1 : 0] PSD_local_position;

   /* ------- ------- -------
    * netlist
    */
   local _status;
   local [WID_Compair - 1 : 0] _compairstr;
   local [WID_Buffer - 1 : 0] _matchbuffer;

   local [WID_Compair - 1 : 0] _compair_temp [WID_Buffer - 1 : 0];
   local [WID_Bitstream - 1 : 0] _compair_ans;

   /* ------- ------- -------
    * assign list
    */

   /*Body*/
   /* ------- ------- -------
    * combinational logic
    */
   assign PSD_local_busy = ~(_status == STS_initial);

   generate
      genvar i;
      for(i = 0; i < WID_Bitstream; i = i + 1) begin : G1
         assign _compair_temp[i] = _matchbuffer[i + WID_Compair - 1 : i] ^ _compairstr;
         assign _compair_ans[i] = ~(|_compair_temp[i]);
      end
   endgenerate

   /* ------- ------- -------
    * temporal logic
    */
   always @(posedge local_PSD_clk or posedge local_PSD_reset) begin
      if(local_PSD_reset) begin
         _newstream <= 1'B1;
         _compairstr <= {WID_Compair{1'B0}};
         _matchbuffer <= {WID_Buffer{1'B0}};
         PSD_local_position <= {WID_Bitstream{1'B0}};
      end
      else begin
         _matchbuffer <= {_matchbuffer[WID_Buffer - 1 : WID_Bitstream], local_PSD_bitstream};

         if(local_PSD_newstream) begin
            _status <= STS_Filling;
            _compairstr <= local_PSD_compair;
            PSD_local_position <= {WID_Bitstream{1'B0}};
         end

         case(_status)
           STS_Filling : begin
              _status <= STS_Matching;
           end

           STS_Matching : begin
              PSD_local_position <= _compair_ans;
           end
         endcase
      end
   end

   /* ------- ------- -------
    * assert
    */

endmodule

// Local Variables:
// verilog-library-directories:()
// End:

