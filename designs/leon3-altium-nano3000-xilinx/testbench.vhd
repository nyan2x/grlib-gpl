-----------------------------------------------------------------------------
--  LEON3 Demonstration design test bench
------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2013, Aeroflex Gaisler
--  Copyright (C) 2014 Martin Wilson <mrw@trimetix.co.uk>
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library gaisler;
use gaisler.libdcom.all;
use gaisler.sim.all;
use work.debug.all;
library techmap;
use techmap.gencomp.all;
library micron;
use micron.components.all;
library spansion;
use spansion.components.all;

use work.config.all;                    -- configuration

entity testbench is
  generic (
    fabtech   : integer := CFG_FABTECH;
    memtech   : integer := CFG_MEMTECH;
    padtech   : integer := CFG_PADTECH;
    clktech   : integer := CFG_CLKTECH;
    disas     : integer := CFG_DISAS;   -- Enable disassembly to console
    dbguart   : integer := CFG_DUART;   -- Print UART on console
    pclow     : integer := CFG_PCLOW;
    clkperiod : integer := 50;          -- system clock period
    comboard  : integer := 0;           -- Comms. adapter board attached
    romwidth  : integer := 16;
    romdepth  : integer := 24
    );
end;

architecture behav of testbench is

  constant promfile  : string := "prom.srec";   -- rom contents
  constant sramfile  : string := "sram.srec";   -- sram contents
  constant sdramfile : string := "sdram.srec";  -- sdram contents

  component leon3mp is
    generic (
      fabtech : integer := CFG_FABTECH;  --
      memtech : integer := CFG_MEMTECH;  --
      padtech : integer := CFG_PADTECH;  --
      clktech : integer := CFG_CLKTECH;  --
      disas   : integer := CFG_DISAS;    -- 
      dbguart : integer := CFG_DUART;    -- 
      pclow   : integer := CFG_PCLOW
      );
    port (
      resetn  : in  std_logic;
      clk_ref : in  std_logic;
      errorn  : out std_logic;

      -- Ethernet signals
      erx_clk : in    std_ulogic;
      erxd    : in    std_logic_vector(3 downto 0);
      erx_dv  : in    std_ulogic;
      erx_er  : in    std_ulogic;
      erx_col : in    std_ulogic;
      erx_crs : in    std_ulogic;
      emdint  : in    std_ulogic;
      etxd    : out   std_logic_vector(3 downto 0);
      etx_en  : out   std_ulogic;
      emdc    : out   std_ulogic;
      emdio   : inout std_logic;
      erstn   : out   std_ulogic;

      -- Common Bus Memory (Flash, SRAM and SDRAM)
      bus_a              : out   std_logic_vector(24 downto 0);  --
      bus_d              : inout std_logic_vector(31 downto 0);  --
      bus_sdram_clk      : out   std_ulogic;                     --
      bus_sdram_feedback : in    std_ulogic;                     --
      bus_sdram_cke      : out   std_logic;                      --
      bus_sdram_ncs      : out   std_logic;                      --
      bus_nwe            : out   std_logic;                      -- 
      bus_sdram_nras     : out   std_logic;                      -- 
      bus_sdram_ncas     : out   std_logic;                      -- 
      bus_nbe            : out   std_logic_vector(3 downto 0);   -- 
      bus_noe            : out   std_logic;
      bus_flash_nreset   : out   std_logic;                      --
      bus_flash_ncs      : out   std_logic;
      bus_flash_nbusy    : in    std_logic;

      uart_txd : out std_logic;         -- 
      uart_rxd : in  std_logic;         -- 

      dsu_txd : out std_logic;          -- 
      dsu_rxd : in  std_logic;          -- 
      dsubre  : in  std_logic;

      plllock : out std_logic;

      ram_ncs : out std_logic;
      usb_ncs : out std_logic;

      led_romcs    : out std_logic;
      led_rombrdyn : out std_logic

      );

  end component;

  signal   clk     : std_logic := '0';
  signal   clk_rst : std_logic := '1';
  signal   cpurst  : std_logic := '0';
  constant ct      : integer   := clkperiod/2;

  signal xtal : std_logic := '0';

  signal gnd : std_logic := '0';
  signal vcc : std_logic := '1';

  signal sdcke        : std_logic;
  signal sdcsn        : std_logic;
  signal sdwen        : std_logic;                      -- write en
  signal sdrasn       : std_logic;                      -- row addr stb
  signal sdcasn       : std_logic;                      -- col addr stb
  signal sddqm        : std_logic_vector (3 downto 0);  -- data i/o mask
  signal sdclk        : std_logic;
  signal plllock      : std_logic;
  signal dsutx, dsurx : std_logic;
  signal dsuact       : std_logic;

  signal leds     : std_logic_vector(7 downto 0);
  signal switches : std_logic_vector(5 downto 0);

  constant lresp : boolean := false;

  signal sram_oe_l, sram_we_l    : std_logic;
  signal sram_cs_l               : std_logic_vector(1 downto 0);
  signal sram_ben_l              : std_logic_vector(0 to 3);
  signal bus_dq                  : std_logic_vector(31 downto 0) := (others => '0');
  signal sram_dq                 : std_logic_vector(31 downto 0) := (others => '0');
  signal flash_dq                : std_logic_vector(31 downto 0) := (others => '0');
  signal flash_cs_l, flash_rst_l : std_logic;
  signal iosn, usb_csn           : std_logic;

  signal phy_txck    : std_logic;
  signal phy_rxck    : std_logic;
  signal phy_rxd     : std_logic_vector(3 downto 0);
  signal phy_rxdt    : std_logic_vector(7 downto 0);
  signal phy_rxdv    : std_logic;
  signal phy_rxer    : std_logic;
  signal phy_col     : std_logic;
  signal phy_crs     : std_logic;
  signal phy_txd     : std_logic_vector(3 downto 0);
  signal phy_txdt    : std_logic_vector(7 downto 0);
  signal phy_txen    : std_logic;
  signal phy_txer    : std_logic;
  signal phy_mdc     : std_logic;
  signal phy_mdio    : std_logic;
  signal phy_reset_l : std_logic;
  signal phy_gtx_clk : std_logic := '0';

  signal video_clk : std_logic := '0';
  signal comp_sync : std_logic;
  signal blank     : std_logic;
  signal video_out : std_logic_vector(23 downto 0);

  signal msclk      : std_logic;
  signal msdata     : std_logic;
  signal kbclk      : std_logic;
  signal kbdata     : std_logic;
  signal dsurst     : std_logic;
  signal flash_oe_n : std_logic;
  signal flash_we_n : std_logic;


  signal disp_seg1 : std_logic_vector(7 downto 0);
  signal disp_seg2 : std_logic_vector(7 downto 0);

  signal baddr : std_logic_vector(24 downto 0) := (others => '0');

  signal can_txd : std_logic;
  signal can_rxd : std_logic;

  signal uart_txd      : std_logic;
  signal uart_rxd      : std_logic;
  signal errorn        : std_logic;
  signal flash_busyn   : std_logic;
  signal flash_busysig : std_logic;
  signal debug_sig     : std_logic_vector(7 downto 0);
  signal ir_datan      : std_logic;
  signal ir_data       : std_logic;

  type irstate is (idle, waiting, lpb, ls, addr, addrn, cmd, cmdn, eom);

  type ir_reg_type is record
    data    : std_logic;
    state   : irstate;
    timeout : natural range 0 to 4096;
    index   : natural range 0 to 16;
    even    : std_logic;
  end record;

  signal r, rin : ir_reg_type;
  
begin

-- clock and reset

  clk    <= not clk after ct * 1 ns;    -- Master clock
  cpurst <= dsurst;                     -- Reset

  cpu : leon3mp
    generic map (fabtech, memtech, padtech, clktech,
                 disas, dbguart, pclow)
    port map (resetn  => cpurst,
              clk_ref => clk,
              errorn  => errorn,

              bus_a              => baddr,
              bus_d              => sram_dq,
              bus_sdram_clk      => sdclk,
              bus_sdram_cke      => sdcke,
              bus_sdram_ncs      => sdcsn,
              bus_nwe            => sram_we_l,
              bus_nbe            => sddqm,
              bus_sdram_nras     => sdrasn,
              bus_sdram_ncas     => sdcasn,
              bus_sdram_feedback => sdclk,
              bus_noe            => sram_oe_l,
              bus_flash_nreset   => flash_rst_l,
              bus_flash_ncs      => flash_cs_l,
              bus_flash_nbusy    => flash_busysig,

              uart_txd => uart_txd,
              uart_rxd => uart_rxd,

              dsu_txd => dsutx,
              dsu_rxd => dsurx,
              dsubre  => dsurst,

              plllock => plllock,

              erx_clk => '0',
              erxd    => "0000",
              erx_dv  => '0',
              erx_er  => '0',
              erx_col => '0',
              erx_crs => '0',
              emdint  => '0',

              ram_ncs => sram_cs_l(1),
              usb_ncs => usb_csn
              );

  phy_mdio <= 'H';
  phy_rxd  <= phy_rxdt(3 downto 0);
  phy_txdt <= "0000" & phy_txd;

  flash_oe_n <= (sram_oe_l or flash_cs_l);
  flash_we_n <= (sram_we_l or flash_cs_l);

  p0 : phy
    generic map(base1000_t_fd => 0, base1000_t_hd => 0)
    port map(dsurst, phy_mdio, phy_txck, phy_rxck, phy_rxdt, phy_rxdv,
             phy_rxer, phy_col, phy_crs, phy_txdt, phy_txen, phy_txer, phy_mdc, phy_gtx_clk);

  -- 16 bit prom - We have to byte-swap the DQ lines
  prom0 : S29GL128P
    generic map(UserPreload => true, mem_file_name => promfile)
    port map(A0    => baddr(1), A1 => baddr(2) , A2 => baddr(3) , A3 => baddr(4) , A4 => baddr(5) , A5 => baddr(6) , A6 => baddr(7) , A7 => baddr(8) ,
             A8    => baddr(9) , A9 => baddr(10) , A10 => baddr(11), A11 => baddr(12) , A12 => baddr(13) , A13 => baddr(14), A14 => baddr(15), A15 => baddr(16),
             A16   => baddr(17) , A17 => baddr(18) , A18 => baddr(19), A19 => baddr(20), A20 => baddr(21), A21 => baddr(22), A22 => baddr(23),
             DQ0   => sram_dq(0) , DQ1 => sram_dq(1), DQ2 => sram_dq(2) , DQ3 => sram_dq(3) , DQ4 => sram_dq(4) , DQ5 => sram_dq(5) , DQ6 => sram_dq(6) , DQ7 => sram_dq(7) ,
             DQ8   => sram_dq(8) , DQ9 => sram_dq(9) , DQ10 => sram_dq(10) , DQ11 => sram_dq(11), DQ12 => sram_dq(12) , DQ13 => sram_dq(13) , DQ14 => sram_dq(14) , DQ15 => sram_dq(15) ,
             CENeg => flash_cs_l, OENeg => flash_oe_n, WENeg => flash_we_n, RESETNeg => flash_rst_l , WPNeg => vcc, BYTENeg => vcc, RY => flash_busyn);

  u0 : mt48lc16m16a2 generic map (addr_bits => 13, col_bits => 9, index => 0, fname => sdramfile)
    port map(
      Dq   => sram_dq(31 downto 16), Addr => baddr(14 downto 2),
      Ba   => baddr(16 downto 15), Clk => sdclk, Cke => sdcke,
      Cs_n => sdcsn, Ras_n => sdrasn, Cas_n => sdcasn, We_n => sram_we_l,
      Dqm  => sddqm(3 downto 2));
  u1 : mt48lc16m16a2 generic map (addr_bits => 13, col_bits => 9, index => 16, fname => sdramfile)
    port map(
      Dq   => sram_dq(15 downto 0), Addr => baddr(14 downto 2),
      Ba   => baddr(16 downto 15), Clk => sdclk, Cke => sdcke,
      Cs_n => sdcsn, Ras_n => sdrasn, Cas_n => sdcasn, We_n => sram_we_l,
      Dqm  => sddqm(1 downto 0));

  errorn      <= 'H';
  flash_busyn <= 'H';

  flash_busysig <= to_x01(flash_busyn);

  iuerr : process
  begin
    wait for 2500 ns;
    if to_x01(errorn) = '1' then wait on errorn; end if;
    assert (to_x01(errorn) = '1')
      report "*** IU in error mode, simulation halted ***"
      severity failure;
  end process;

  dsucom : process
    procedure dsucfg(signal dsurx : in std_logic; signal dsutx : out std_logic) is
      variable w32 : std_logic_vector(31 downto 0);
      variable c8  : std_logic_vector(7 downto 0);
      constant txp : time := 160 * 1 ns;
    begin
      dsutx  <= '1';
      dsurst <= '0';                    --reset low
      wait for 500 ns;
      dsurst <= '1';                    --reset high
      wait;
      wait for 5000 ns;
      txc(dsutx, 16#55#, txp);


      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#2f#, txp);
      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#91#, 16#00#, 16#00#, 16#00#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#6f#, txp);
      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#11#, 16#00#, 16#00#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#00#, txp);
      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#40#, 16#00#, 16#04#, txp);
      txa(dsutx, 16#00#, 16#02#, 16#20#, 16#01#, txp);
      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#02#, txp);

      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#0f#, txp);

      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#40#, 16#00#, 16#43#, 16#10#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#0f#, txp);

      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#91#, 16#40#, 16#00#, 16#24#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#24#, txp);
      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#91#, 16#70#, 16#00#, 16#00#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#03#, txp);


      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#00#, 16#00#, 16#20#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#ff#, 16#ff#, txp);

      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#40#, 16#00#, 16#48#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#00#, 16#12#, txp);

      txc(dsutx, 16#c0#, txp);
      txa(dsutx, 16#90#, 16#40#, 16#00#, 16#60#, txp);
      txa(dsutx, 16#00#, 16#00#, 16#12#, 16#10#, txp);

      txc(dsutx, 16#80#, txp);
      txa(dsutx, 16#90#, 16#00#, 16#00#, 16#00#, txp);
      rxi(dsurx, w32, txp, lresp);

      txc(dsutx, 16#a0#, txp);
      txa(dsutx, 16#40#, 16#00#, 16#00#, 16#00#, txp);
      rxi(dsurx, w32, txp, lresp);

    end;

  begin

    dsucfg(dsutx, dsurx);

    wait;
  end process;
end;

