.main clear

cd $env(Path_Project)/simulation/modelsim

vlib  work
vmap work work

set SimulationList {
   BitCounter
   ParallelSequenceDetection
}

set TestInstNum 0

puts [lindex $SimulationList $TestInstNum]

switch [lindex $SimulationList $TestInstNum] {
   BitCounter {
      do ../BC/sim.do
   }

   ParallelSequenceDetection {
      do ../PSD/sim.do
   }
   default {
      puts "--- No Find Test Instance ---"
   }
}