vlog -sv +cover=sbcet "../BC/BitCounter_test.sv"
vlog -sv +cover=sbcet "../../src/BC/BitCounter.sv"

vsim -gui -sva -assertdebug -coverage -novopt -msgmode both  work.BitCounter_test

