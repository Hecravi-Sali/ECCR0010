/* ------- ------- -------
 * Belons     :
 * Connection : None
 * Features   : Stable
 * manual     :
 * --- --- ---
 * 检测字节流中某一特定的序列出现的位置以及次数
 *
 * //  TODO 完善手册
 * --- --- ---
 */
module ParallelSequenceDetection(/*AUTOARG*/
   // Outputs
   PSD_local_busy, PSD_local_position, PSD_local_count,
   // Inputs
   local_PSD_clk, local_PSD_reset, local_PSD_newstream, local_PSD_compair,
   local_PSD_bitstream
   );
   /* ------- ------- -------
    * parameter list
    */
   parameter WID_Bitstream = 0;
   parameter WID_Compair = 0;
   parameter WID_Compair_count = 0;

   /* ------- ------- -------
    * localparam list
    */
   localparam WID_Detection = WID_Compair + WID_Bitstream;
   localparam NUM_Buffer = (WID_Detection / WID_Bitstream) * WID_Bitstream == WID_Detection ?
                           (WID_Detection / WID_Bitstream) :
                           (WID_Detection / WID_Bitstream) + 1;
   localparam WID_Buffer = WID_Bitstream * NUM_Buffer;

   localparam STS_Idle = 2'B00;
   localparam STS_Filling = 2'B01;
   localparam STS_Matching = 2'B10;

   /* ------- ------- -------
    * in/out port list
    */
   input                                    local_PSD_clk;
   input                                    local_PSD_reset;

   input                                    local_PSD_newstream;
   output                                   PSD_local_busy;
   input [WID_Compair - 1 : 0]              local_PSD_compair;
   input [WID_Bitstream - 1 : 0]            local_PSD_bitstream;

   output logic [WID_Bitstream - 1 : 0]     PSD_local_position;
   output logic [WID_Compair_count - 1 : 0] PSD_local_count;

   /* ------- ------- -------
    * netlist
    */
   logic [1 : 0] _status;
   logic [WID_Compair - 1 : 0] _compairstr;
   logic [WID_Buffer - 1 : 0] _matchbuffer;
   logic [$clog2(NUM_Buffer) - 1 : 0] _fillcount;

   logic [WID_Compair - 1 : 0] _compair_temp [WID_Buffer - 1 : 0];
   logic [WID_Bitstream - 1 : 0] _compair_ans;

   logic [WID_Compair_count - 1 : 0] _bitcounter_ans;

   /* ------- ------- -------
    * assign list
    */
   BitCounter
     #(.WID_CountRange(WID_Bitstream),
       .WID_CountResult(WID_Compair_count))
   BitCounter_inst
     (.local_BC_bitstream(_compair_ans),
      .BC_local_result(_bitcounter_ans));

   /*Body*/
   /* ------- ------- -------
    * combinational logic
    */
   assign PSD_local_busy = ~(_status == STS_Idle);

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
         _status <= STS_Idle;
         _compairstr <= {WID_Compair{1'B0}};
         _matchbuffer <= {WID_Buffer{1'B0}};
         _fillcount <= {$clog2(NUM_Buffer){1'B0}};
         PSD_local_position <= {WID_Bitstream{1'B0}};
         PSD_local_count <= {WID_Compair_count{1'B0}};
      end
      else begin
         _matchbuffer <= {_matchbuffer[WID_Buffer - WID_Bitstream - 1 : 0], local_PSD_bitstream};

         if(local_PSD_newstream) begin
            _status <= STS_Filling;
            _fillcount <= NUM_Buffer - 1;
            _compairstr <= local_PSD_compair;
            PSD_local_position <= {WID_Bitstream{1'B0}};
            PSD_local_count <= {WID_Compair_count{1'B0}};
         end
         else begin
            case(_status)
              STS_Idle : begin
                 ;
              end

              STS_Filling : begin
                 _fillcount <= _fillcount - 1;
                 if(_fillcount == 1'B1) begin
                    _status <= STS_Matching;
                 end
              end

              STS_Matching : begin
                 PSD_local_position <= _compair_ans;
                 PSD_local_count <= _bitcounter_ans;
              end

              default : begin
                 _status <= STS_Idle;
              end
            endcase
         end
      end
   end

   /* ------- ------- -------
    * assert
    */

endmodule

// Local Variables:
// verilog-library-directories:(../BC/)
// End:

