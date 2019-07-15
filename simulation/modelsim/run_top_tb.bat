@echo off
set Path_Modelsim=F:\Modelsim\win32
set Path_Project=F:\Projects\ECCR0010
set path=%Path_Modelsim%

vsim -do %Path_Project%\simulation\modelsim\top_tb.do