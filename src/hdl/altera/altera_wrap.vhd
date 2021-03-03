-- Wrapper for Altera DE0-Nano board
-- Generate 20MHz clock to logic_top
-- iReset is considered as a button with active '1'

library ieee;
use ieee.std_logic_1164.all;

entity altera_wrap is
    port (
        iClk_board: in std_logic;
        iReset: in std_logic;

        oLed0: out std_logic;
        oLed1: out std_logic;
        oLed2: out std_logic;

        -- UART
        iRs: in std_logic;
        oRs: out std_logic;

         --SPI
        iSck: in std_logic;
        iCsn: in std_logic;
        iMosi: in std_logic;
        oMiso: out std_logic;

        -- Debug UART
        iRs_dbg: in std_logic;
        oRs_dbg: out std_logic;

        iGPIO: in std_logic_vector (8 downto 0);
        oGPIO: out std_logic
    );
end altera_wrap;

architecture altera_wrap_arc of altera_wrap is

    component logic_top
        port (
            iClk: in std_logic;
            iReset: in std_logic;

            -- UART
            iRs: in std_logic;
            oRs: out std_logic;

             --SPI
            iSck: in std_logic;
            iCsn: in std_logic;
            iMosi: in std_logic;
            oMiso: out std_logic;

            -- Debug UART
            iRs_dbg: in std_logic;
            oRs_dbg: out std_logic;

            iGPIO: in std_logic_vector (8 downto 0);
            oGPIO: out std_logic
        );
    end component;

    component clk_pll
        port (
            areset: in std_logic;
            inclk0: in std_logic;
            c0: out std_logic;
            locked: out std_logic
        );
    end component;

    signal sClk: std_logic;
    signal sMmmcm_locked: std_logic;
    signal sReset: std_logic;
    signal sButtonn: std_logic;

begin

    oLed0 <= sReset;
    oLed1 <= '0';
    oLed2 <= '1';
    sButtonn <= not iReset;

    clock_gen: clk_pll
        port map (
            areset => sButtonn,
            inclk0 => iClk_board,
            c0 => sClk,
            locked => sReset
        );

    top: logic_top
        port map (
            iClk => sClk,
            iReset => sReset,

            iRs => iRs,
            oRs => oRs,

            iSck => iSck,
            iCsn => iCsn,
            iMosi => iMosi,
            oMiso => oMiso,

            iRs_dbg => iRs_dbg,
            oRs_dbg => oRs_dbg,

            iGPIO => iGPIO,
            oGPIO => oGPIO
        );

end altera_wrap_arc;
