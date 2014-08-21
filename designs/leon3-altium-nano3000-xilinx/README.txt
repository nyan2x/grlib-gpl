
This leon3 design is tailored to the Alitum Nano3000 board
---------------------------------------------------------------------

Design specifics:

* System reset is mapped to the SW1 Pushbutton

* The console UART (UART 1) is connected to the User Header A as is a TTL output

* The LEON3 processor can run up to 40 MHz on the board
  in the typical configuration.

* Sample output from GRMON info sys is:

  GRMON2 LEON debug monitor v2.0.53 eval version
  
  Copyright (C) 2014 Aeroflex Gaisler - All rights reserved.
  For latest updates, go to http://www.gaisler.com/
  Comments or bug-reports to support@gaisler.com
  
  This eval version will expire on 03/12/2014

Xilusb: Cable type/rev : 0x3 
 JTAG chain (1): xc3s1400an 
 
  Device ID:           0x302
  GRLIB build version: 4144
  Detected frequency:  40 MHz
  
  Component                            Vendor
  LEON3 SPARC V8 Processor             Aeroflex Gaisler
  JTAG Debug Link                      Aeroflex Gaisler
  GR Ethernet MAC                      Aeroflex Gaisler
  AHB/APB Bridge                       Aeroflex Gaisler
  LEON3 Debug Support Unit             Aeroflex Gaisler
  LEON2 Memory Controller              European Space Agency
  Generic UART                         Aeroflex Gaisler
  Multi-processor Interrupt Ctrl.      Aeroflex Gaisler
  Modular Timer Unit                   Aeroflex Gaisler
  
  Use command 'info sys' to print a detailed report of attached cores

grmon2> info sys
  cpu0      Aeroflex Gaisler  LEON3 SPARC V8 Processor    
            AHB Master 0
  ahbjtag0  Aeroflex Gaisler  JTAG Debug Link    
            AHB Master 1
  greth0    Aeroflex Gaisler  GR Ethernet MAC    
            AHB Master 2
            APB: 80000400 - 80000500
            IRQ: 4
            edcl ip 192.168.0.51, buffer 1 kbyte
  apbmst0   Aeroflex Gaisler  AHB/APB Bridge    
            AHB: 80000000 - 80100000
  dsu0      Aeroflex Gaisler  LEON3 Debug Support Unit    
            AHB: 90000000 - A0000000
            CPU0:  win 8, hwbp 2, V8 mul/div, srmmu, lddel 1
                   stack pointer 0x43fffff0
                   icache 2 * 2 kB, 32 B/line lru
                   dcache 1 * 4 kB, 16 B/line 
  mctrl0    European Space Agency  LEON2 Memory Controller    
            AHB: 00000000 - 20000000
            AHB: 20000000 - 40000000
            AHB: 40000000 - 80000000
            APB: 80000000 - 80000100
            16-bit prom @ 0x00000000
            32-bit sdram: 1 * 64 Mbyte @ 0x40000000
            col 9, cas 2, ref 7.8 us
  uart0     Aeroflex Gaisler  Generic UART    
            APB: 80000100 - 80000200
            IRQ: 2
            Baudrate 0
  irqmp0    Aeroflex Gaisler  Multi-processor Interrupt Ctrl.    
            APB: 80000200 - 80000300
  gptimer0  Aeroflex Gaisler  Modular Timer Unit    
            APB: 80000300 - 80000400
            IRQ: 8
            8-bit scalar, 2 * 32-bit timers, divisor 40


  AMD-style 16-bit flash

  Manuf.        : AMD               
  Device        : MX29LV128MB       
  
  1 x 16 Mbytes = 16 Mbytes total @ 0x00000000
  
  CFI information
  Flash family  : 2
  Flash size    : 128 Mbit
  Erase regions : 1
  Erase blocks  : 128
  Write buffer  : 64 bytes (limited to 64)
  Lock-down     : Not supported
  Region  0     : 128 blocks of 128 kbytes
  
The system is able to run the latest linux kernel...


PROMLIB: Sun Boot Prom Version 0 Revision 0
Linux version 3.16.1-mrw (opencores@lnx-dev) (gcc version 4.4.7 (Buildroot 2014.08-git-g7a88dbf) ) #2 Wed Aug 20 09:32:57 BST 2014
bootconsole [earlyprom0] enabled
ARCH: LEON
TYPE: Leon3 System-on-a-Chip
Ethernet address: 00:00:7c:cc:01:45
CACHE: direct mapped cache, set size 4k
CACHE: not flushing on every context switch
OF stdout device is: /a::a
PROM: Built device tree with 13370 bytes of memory.
Booting Linux...
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 14971
Kernel command line: console=ttyS0,115200 init=/sbin/init 
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Sorting __ex_table...
Memory: 57572K/60396K available (2824K kernel code, 139K rwdata, 584K rodata, 1396K init, 136K bss, 2824K reserved, 0K highmem)
NR_IRQS:64
Console: colour dummy device 80x25
console [ttyS0] enabled
bootconsole [earlyprom0] disabled
bootconsole [earlyprom0] disabled
Calibrating delay loop... 37.76 BogoMIPS (lpj=75520)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
devtmpfs: initialized
NET: Registered protocol family 16
vgaarb: loaded
SCSI subsystem initialized
Switched to clocksource timer_cs
NET: Registered protocol family 2
TCP established hash table entries: 1024 (order: 0, 4096 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP: reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
futex hash table entries: 256 (order: -1, 3072 bytes)
msgmni has been set to 112
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
ffd0de1c: ttyS0 at MMIO 0x80000100 (irq = 3, base_baud = 2500000) is a GRLIB/APBUART
grlib-apbuart at 0x80000100, irq 3
brd: module loaded
mousedev: PS/2 mouse device common for all mice
i2c /dev entries driver
TCP: cubic registered
NET: Registered protocol family 17
leon: power management initialized
Freeing unused kernel memory: 1396K (f037f000 - f04dc000)
Starting logging: OK
Initializing random number generator... random: dd urandom read with 1 bits of entropy available
done.
Starting network...
libphy: greth-mdio: probed
udhcpc (v1.22.1) started
Sending discover...
Sending discover...
Sending select for 10.42.0.93...
Lease of 10.42.0.93 obtained, lease time 3600
deleting routers
route: SIOCDELRT: No such process
adding dns 10.42.0.1
Initializing time... ntpd: setting time to 2014-08-21 10:42:54.290625 (offset +1408614151.523540s)
done
Starting dropbear sshd: OK


Nano3000 login: 


