GRLIB=../..
TOP=leon3mp
BOARD=altium-nano3000-xc3s1400an
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=std
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=config.vhd leon3mp.vhd
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
SDCFILE=$(GRLIB)/boards/$(BOARD)/default.sdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = unisim
LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix cypress ihp usbhc spw
DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan leon3ft ddr meiko mfpc \
	grusbhc pci i2c dps6 cy7c67300 spi spacewire usb leon4 leon4v0 l2cache \
	slink ascs pwm gr1553b iommu
FILESKIP = grcan.vhd

include $(GRLIB)/software/leon3/Makefile

include $(GRLIB)/bin/Makefile


##################  project specific targets ##########################

