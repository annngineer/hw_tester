set prjName hw_tester
set familyName "Cyclone IV E"
set deviceName EP4CE22F17C6
set topName altera_wrap

project_new -family $familyName -part $deviceName $prjName -overwrite

set GRLIB_SET {
    ../../grlib/lib/grlib/stdlib/version.vhd
    ../../grlib/lib/grlib/stdlib/stdlib.vhd
    ../../grlib/lib/grlib/stdlib/config_types.vhd
    ../../grlib/lib/grlib/stdlib/config.vhd
    ../../grlib/lib/grlib/stdlib/stdio.vhd
    ../../grlib/lib/grlib/stdlib/testlib.vhd
    ../../grlib/lib/grlib/amba/amba.vhd
    ../../grlib/lib/grlib/amba/devices.vhd
    ../../grlib/lib/grlib/amba/ahbctrl.vhd
    ../../grlib/lib/grlib/amba/ahbmst.vhd
    ../../grlib/lib/grlib/amba/apbctrl.vhd
    ../../grlib/lib/grlib/amba/apbctrlx.vhd
}
set GAISLER_SET {
    ../../grlib/lib/gaisler/misc/misc.vhd
    ../../grlib/lib/gaisler/misc/rstgen.vhd
    ../../grlib/lib/gaisler/misc/grgpio.vhd
    ../../grlib/lib/gaisler/uart/uart.vhd
    ../../grlib/lib/gaisler/uart/libdcom.vhd
    ../../grlib/lib/gaisler/uart/dcom.vhd
    ../../grlib/lib/gaisler/uart/dcom_uart.vhd
    ../../grlib/lib/gaisler/uart/ahbuart.vhd
    ../../grlib/lib/gaisler/uart/apbuart.vhd
    ../../grlib/lib/gaisler/spi/spi.vhd
    ../../grlib/lib/gaisler/spi/spi2ahb.vhd
    ../../grlib/lib/gaisler/spi/spi2ahbx.vhd
    ../../grlib/lib/gaisler/leon3/leon3.vhd
    ../../grlib/lib/gaisler/irqmp/irqmp.vhd
}

set TECHMAP_SET {
    ../../grlib/lib/techmap/gencomp/gencomp.vhd
}

foreach vhdl_file $GRLIB_SET {
set_global_assignment -name VHDL_FILE -library grlib $vhdl_file
}

foreach vhdl_file $TECHMAP_SET {
set_global_assignment -name VHDL_FILE -library techmap $vhdl_file
}

foreach vhdl_file $GAISLER_SET {
set_global_assignment -name VHDL_FILE -library gaisler $vhdl_file
}

foreach vhdl_file [ glob ../../src/hdl/wraps/*.vhd ] {
set_global_assignment -name VHDL_FILE -library work $vhdl_file
}

foreach vhdl_file [ glob ../../src/hdl/altera/*.vhd ] {
set_global_assignment -name VHDL_FILE -library work $vhdl_file
}

foreach verilog_file [ glob ../../src/hdl/altera/*.v ] {
set_global_assignment -name VERILOG_FILE $verilog_file
}

set_global_assignment -name TOP_LEVEL_ENTITY $topName

set_location_assignment PIN_R8 -to iClk_board
set_location_assignment PIN_J15 -to iReset
set_location_assignment PIN_D3 -to iRs_dbg
set_location_assignment PIN_C3 -to oRs_dbg

set_location_assignment PIN_A15 -to oLed0
set_location_assignment PIN_A13 -to oLed1
set_location_assignment PIN_B13 -to oLed2

set_location_assignment PIN_A2 -to iRs
set_location_assignment PIN_A3 -to oRs

set_location_assignment PIN_B3 -to iSck
set_location_assignment PIN_B4 -to iCsn
set_location_assignment PIN_A4 -to iMosi
set_location_assignment PIN_B5 -to oMiso

set_location_assignment PIN_A5 -to iGPIO[8]
set_location_assignment PIN_D5 -to iGPIO[7]
set_location_assignment PIN_B6 -to iGPIO[6]
set_location_assignment PIN_A6 -to iGPIO[5]
set_location_assignment PIN_B7 -to iGPIO[4]
set_location_assignment PIN_D6 -to iGPIO[3]
set_location_assignment PIN_A7 -to iGPIO[2]
set_location_assignment PIN_C6 -to iGPIO[1]
set_location_assignment PIN_C8 -to iGPIO[0]

set_location_assignment PIN_A11 -to oGPIO
