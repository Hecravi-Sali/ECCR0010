quit -sim

vlog -sv +cover=sbcet "../PSD/ParallelSequenceDetection_test.sv"
vlog -sv +cover=sbcet "../../src/PSD/ParallelSequenceDetection.sv"

vsim -gui -sva -assertdebug -coverage -novopt -msgmode both  work.ParallelSequenceDetection_test

