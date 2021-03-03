Hardware tester based on GRLIB library and GDB debug concept. This is co-project to perform hardware testing through UART debug interface for those project who doesn't have debug interface by themselves.

# IP cores & AHB addresses
* ahbuart0  Cobham Gaisler  AHB Debug UART
    * AHB Master 0
    * APB: 80000300 - 80000400
    * Baudrate 115200, AHB frequency 20,00 MHz
* spi2ahb0  Cobham Gaisler  SPI to AHB Bridge
    * AHB Master 1
* apbmst0   Cobham Gaisler  AHB/APB Bridge
    * AHB: 80000000 - 90000000
* gpio0     Cobham Gaisler  General Purpose I/O port
    * APB: 80000000 - 80000100
* uart0     Cobham Gaisler  Generic UART
    * APB: 80000100 - 80000200
    * IRQ: 1
    * Baudrate 38461, FIFO debug mode available
* irqmp0    Cobham Gaisler  Multi-processor Interrupt Ctrl.
    * APB: 80000200 - 80000300
More info about IP-cores above in [grip.pdf](https://www.gaisler.com/products/grlib/grip.pdf)

# Synthesis
Design was checked via DE0-nano board, because repo's author has it. To perform synthesis
```
cd altera
./start_make_prj.bash
```
To do things above Quartus/Intel FPGA software is needed

# How to use
This project has the same interfaces as target project (the one you want to test) + debug UART. Just connect projects inside one wrap through interfaces one to another. Non-interface pins of you target project could be read/configured using GPIO pins (you can read/write those GPIO pins through APB address space).

To connect via debug UART one can use GRMON2/GRMON3. More info about those [GRMON2 & GRMON3](https://www.gaisler.com/index.php/products/debug-tools)
