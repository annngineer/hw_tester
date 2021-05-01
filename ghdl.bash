ghdl -i --work=grlib ./grlib/lib/grlib/stdlib/config_types.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/stdlib/config.vhd
ghdl -i --work=techmap ./grlib/lib/techmap/gencomp/gencomp.vhd

ghdl -i --work=grlib ./grlib/lib/grlib/stdlib/version.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/stdlib/stdlib.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/stdlib/stdio.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/stdlib/testlib.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/amba/amba.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/amba/devices.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/amba/ahbctrl.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/amba/ahbmst.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/amba/apbctrl.vhd
ghdl -i --work=grlib ./grlib/lib/grlib/amba/apbctrlx.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/misc/misc.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/misc/rstgen.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/misc/grgpio.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/uart/uart.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/uart/libdcom.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/uart/dcom.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/uart/dcom_uart.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/uart/ahbuart.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/uart/apbuart.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/spi/spi.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/spi/spictrlx.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/spi/spictrl.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/leon3/leon3.vhd
ghdl -i --work=gaisler ./grlib/lib/gaisler/irqmp/irqmp.vhd
ghdl -i --work=techmap ./grlib/lib/techmap/gencomp/netcomp.vhd
ghdl -i --work=techmap ./grlib/lib/techmap/inferred/memory_inferred.vhd
ghdl -i --work=techmap ./grlib/lib/techmap/alltech/allmem.vhd
ghdl -i --work=techmap ./grlib/lib/techmap/maps/memrwcol.vhd
ghdl -i --work=techmap ./grlib/lib/techmap/maps/syncram_2p.vhd
ghdl -i grlib_system.vhd
ghdl -m grlib_system
