/* ------- ------- -------
 * Belons      :
 * Connection  : None
 * Features    : Notestd
 * manual      :
 * --- --- ---
 * BitCounter用来统计固定长度输入bitstream中1出现的次数。
 *
 * @WID_CountRange : 输入bitstream的宽度
 * limit WID_CountRange > 1
 * @WID_CountResult : 输出bitstream中1的次数
 * limit WID_CountResult = $clog2(WID_CountRange)
 *
 * 原理参照JDK源码中Integer类对于Bitcount的实现
 * --- --- ---
 */
module BitCounter(/*AUTOARG*/);
   /* ------- ------- -------
    * parameter list
    */
   parameter WID_CountRange = 0;
   parameter WID_CountResult = 0;

   /* ------- ------- -------
    * localparam list
    */
   localparam CountRangeLayer = $clog2(WID_CountRange);
   localparam FillCountRange = 2 ** CountRangeLayer;

   /* ------- ------- -------
    * in/out port list
    */
   input [WID_CountRange - 1 : 0]   local_BC_bitstream;
   output [WID_CountResult - 1 : 0] BC_local_result;

   /* ------- ------- -------
    * netlist
    */
   logic [FillCountRange - 1 : 0] _temp [CountRangeLayer : 0];

   /* ------- ------- -------
    * assign list
    */
   assign BC_local_result = _temp[CountRangeLayer][WID_CountResult - 1 : 0];

   /*Body*/
   /* ------- ------- -------
    * combinational logic
    */
   generate
      if(FillCountRange != WID_CountRange) begin : G0
         assign _temp[0] = {(FillCountRange - WID_CountRange){1'B0}, local_BC_bitstream};
      end
      else begin : G1
         assign _temp[0] = local_BC_bitstream;
      end
   generate
      genvar i, k;
      for(i = 1; i <= CountRangeLayer + 1; i = i + 1) begin : G2
         for(k = 0; k < 2 ** (CountRangeLayer - i); k = k + 1) begin : G3
            assign _temp[i][k * (i + 1) +: (i + 1)] = _temp[i - 1][k * 2 * i +: i] + _temp[i - 1][(k + 1) *2 * i -: i];
         end
         //  Connect unused lines to GND
         if(i > 1) begin
            assign _temp[i][FillCountRange - 1 : (2 ** (CountRangeLayer - i)) * (i + 1)] = {(FillCountRange - (2 ** (CountRangeLayer - i)) * (i + 1) + 1){1'B0}};
         end
      end
   endgenerate

   /* ------- ------- -------
    * temporal logic
    */

   /* ------- ------- -------
    * assert
    */

endmodule

// Local Variables:
// verilog-library-directories:()
// End:

