quit -sim

vlog -sv +cover=sbcet "../PSD/ParallelSequenceDetection_test.sv"
vlog -sv +cover=sbcet "../../src/PSD/ParallelSequenceDetection.sv"
vlog -sv +cover=sbcet "../../src/BC/BitCounter.sv"

vsim -gui -sva -assertdebug -coverage -novopt -msgmode both  work.ParallelSequenceDetection_test

coverage exclude -du ParallelSequenceDetection -togglenode local_PSD_reset 
coverage exclude -du ParallelSequenceDetection_test -togglenode local_PSD_reset
coverage exclude -du ParallelSequenceDetection_test -togglenode PSD_local_busy

coverage exclude -src ../../src/PSD/ParallelSequenceDetection.sv -line 131 -code s
coverage exclude -src ../../src/PSD/ParallelSequenceDetection.sv -line 130 -code b
