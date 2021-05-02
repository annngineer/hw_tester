import json


class grlib:
    indent = " "*4
    port_indent = indent*2
    def __init__(self, arg = None):
        self.ahbm = []
        self.ahbs = []
        self.apbs = []
        with open(arg) as f:
            lst = json.load(f)
        for f in lst:
            self.add(f)
        self._assign_bus_generics()

    def add(self, feature):
        d = device_factory.create_device(feature)
        d.add_to_system(self)

    def add_device(self, d):
        if isinstance(d, ahbm):
            self.ahbm.append(d)
        if isinstance(d, ahbs):
            self.ahbs.append(d)
        if isinstance(d, apbs):
            self.apbs.append(d)

    def print(self):
        print('ahbm', self.ahbm)
        print('ahbs', self.ahbs)
        print('apbs', self.apbs)

    def dump(self, f = None):
        return '\n'.join([
            self._dump_imports(),
            "\n",
            self._dump_entity(),
            "\n",
            self._dump_architecture(),
        ])

    def devices(self):
        return [*self.ahbm, *self.ahbs, *self.apbs]

    def _assign_bus_generics(self):
        for i in range(len(self.ahbm)):
            self.ahbm[i].hindex = i
        for i in range(len(self.ahbs)):
            self.ahbs[i].hindex = i
        for i in range(len(self.apbs)):
            self.apbs[i].pindex = i
            self.apbs[i].paddr = i

    def _dump_imports(self):
        return "\n".join([
            "library ieee;", 
            "use ieee.std_logic_1164.all;", 
            "library grlib;", 
            "use grlib.amba.all;", 
            "use grlib.config.all;", 
            "library gaisler;", 
            "\n".join([x.dump_imports() for x in self.devices()])
        ])

    def _dump_entity(self):
        return "\n".join([
            "entity grlib_system is",
            "    port (",
            "        iClk: in std_logic;",
            "        iReset: in std_logic;",
            self._dump_ports(),
            "    );",
            "end grlib_system;"
        ])

    def _dump_ports(self):
        ports = [x.dump_ports() for x in self.devices()]
        ports = [inner for outer in ports for inner in outer]
        ip = '\n' + self.port_indent + ('\n' + self.port_indent).join(ports)
        return ip[:-1]

    def _dump_architecture(self):
        return "\n".join([
            "architecture v1 of grlib_system is",
            self._dump_arch_dec(),
            "begin",
            self._dump_arch_exec(),
            "end v1;"
        ])

    def _dump_arch_dec(self):
        return '\n'.join([x.dump_signals() for x in self.devices()]) + '\n' + '\n'.join([
            "    signal sAHBmi: ahb_mst_in_type;",
            "    signal sAHBmo: ahb_mst_out_vector := (others => ahbm_none);",
            "    signal sAHBsi: ahb_slv_in_type;",
            "    signal sAHBso: ahb_slv_out_vector := (others => ahbs_none);",
            "    signal sAPBi: apb_slv_in_type;",
            "    signal sAPBo: apb_slv_out_vector := (others => apb_none);",
        ]) + '\n'

    def _dump_arch_exec(self):
        return self._dump_assigns() + self._dump_insts()

    def _dump_assigns(self):
        return '\n'.join([x.dump_assigns() for x in self.devices()]) + '\n'

    def _dump_insts(self):
        insts = '\n'.join([x.dump_inst() for x in self.devices()]) + '\n' + '\n'.join([
            "    ahb_ctrl: ahbctrl",
            "        generic map (",
            "            defmast=> 0,",
            "            nahbm => " + str(len(self.ahbm)) + ",",
            "            nahbs => " + str(len(self.ahbs)+1) + ",",
            "            ioen => 0",
            "        )",
            "        port map (",
            "            rst => iReset,",
            "            clk => iClk,",
            "            msti => sAHBmi,",
            "            msto => sAHBmo,",
            "            slvi => sAHBsi,",
            "            slvo => sAHBso",
            "        );",
            "    apb_ctrl: apbctrl",
            "        generic map (",
            "            hindex => " + str(len(self.ahbs)) + ",",
            "            haddr => 16#FFF#,",
            "            hmask => 16#FFF#",
            "        )",
            "        port map (",
            "            rst => iReset,",
            "            clk => iClk,",
            "            ahbi => sAHBsi,",
            "            ahbo => sAHBso(" + str(len(self.ahbs)) + "),",
            "            apbi => sAPBi,",
            "            apbo => sAPBo",
            "        );",
        ])
        return insts

class grlib_device:
    def __init__(self, cfg):
        self.cfg = cfg
        self.pindex = -1
        self.paddr = -1
        self.hindex = -1
        self.haddr = -1
        self.hmask = -1

    def add_to_system(self, s):
        self.system = s
        s.add_device(self)

    def dump_imports(self):
        return ""

    def ports(self):
        return []

    def dump_ports(self):
        return [self._signal(x) for x in self.ports()]

    def dump_inst(self):
        return ''

    def dump_signals(self):
        return ''

    def dump_assigns(self):
        return ''

    def _signal(self, n, d = None, w = None):
        if isinstance(n, list):
            if len(n) > 2:
                w = n[2]
            if len(n) > 1:
                d = n[1]
            n = n[0]

        if not isinstance(d, str):
            w = d
            if n[0] == 'i':
                d = 'in'
            elif n[0] == 'o':
                d = 'out'
            elif n[0] == 'io':
                d = 'inout'
        if d == None:
            return 'signal ' + n + ': ' + self._slv(w)
        else:
            return n + ': ' + d + ' ' + self._slv(w)

    def _slv(self, w = None):
        if w == None:
            return 'std_logic;'
        else:
            return 'std_logic_vector (' + str(w) + '-1 downto 0);'

class ahbm(grlib_device):
    pass

class ahbs(grlib_device):
    pass

class apbs(grlib_device):
    pass

class ahbuart(ahbm):
    def ports(self):
        return [['iUart'], ['oUart']]
    def dump_imports(self):
        return "use gaisler.uart.all;\n"
    def dump_inst(self):
        return '\n'.join([
            "    ahbuart_inst: ahbuart",
            "        generic map (",
            "            hindex => " + str(self.hindex),
#            "            pindex => " + str(self.hindex) + ",",
#            "            paddr => " + str(self.hindex),
            "        )",
            "        port map (",
            "            rst => iReset,",
            "            clk => iClk,",
            "            uarti => sUARTi,",
            "            uarto => sUARTo,",
            "            apbi => sAPBi,",
#            "            apbo => sAPBo(cINDEX_APB_UART_DBG),",
            "            ahbi => sAHBmi,",
            "            ahbo => sAHBmo(" + str(self.hindex) + ")",
            "        );",
        ])

    def dump_signals(self):
        return '\n'.join([
            "    signal sUARTi: uart_in_type;",
            "    signal sUARTo: uart_out_type;",
        ])

    def dump_assigns(self):
        return '\n'.join([
            "    sUARTi.rxd <= iUart;",
            "    oUart <= sUARTo.txd;",
        ])

class grgpio(apbs):
    def ports(self):
        return [['iGpio', self.cfg['nbits']], ['oGpio', self.cfg['nbits']]]
    def dump_imports(self):
        return "use gaisler.misc.all;\n"

    def dump_inst(self):
        return '\n'.join([
            "    grgpio_inst: grgpio",
            "        generic map (",
            "            pindex => " + str(self.pindex) + ",",
            "            paddr => " + str(self.paddr) + ",",
            "            nbits => " + str(self.cfg['nbits']),
            "        )",
            "        port map (",
            "            rst => iReset,",
            "            clk => iClk,",
            "            apbi => sAPBi,",
            "            apbo => sAPBo(" + str(self.pindex) + "),",
            "            gpioi => sGpioi,",
            "            gpioo => sGpioo",
            "        );",
        ])

    def dump_signals(self):
        return '\n'.join([
            "    signal sGPIOi: gpio_in_type;",
            "    signal sGPIOo: gpio_out_type;",
        ])
    def dump_assigns(self):
        return '\n'.join([
            "    sGPIOi.din(" + str(self.cfg['nbits']) + "-1 downto 0) <= iGPIO;",
            "    oGPIO <= sGPIOo.dout(" + str(self.cfg['nbits']) + "-1 downto 0);",
        ])

#    def dump_ports(self):
#        return "iUart: in std_logic_vector (" + str(self.cfg['nbits']) + ;\noUart: out std_logic;\n"

class device_factory:
    def create_device(feature):
        try:
            return globals()[feature['name']](feature['cfg'])
        except:
            print('failed to create an instance of', feature['name'])

g = grlib('cfg.json')
with open('grlib_system.vhd', 'w') as f:
    f.write(g.dump())

