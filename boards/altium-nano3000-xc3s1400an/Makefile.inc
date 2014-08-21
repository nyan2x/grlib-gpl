TECHNOLOGY="Spartan3A and Spartan3AN"
NETLISTTECH=Spartan3
PART=xc3s1400an
PACKAGE=fgg676
SPEED=-4
SYNFREQ=75
PROMGENPAR=-x xcf04s xcf01s -u 0 $(TOP).bit -p mcs -w -o avnet-xc3v1500
MANUFACTURER=Xilinx
MGCPART=3s1400an(PACKAGE)
MGCTECHNOLOGY=$(TECHNOLOGY)
MGCPACKAGE=$(PACKAGE)

# Set PlanAhead Synthesis Flow and Strategy used for build
PLANAHEAD_SYNTH_FLOW="XST 13"
PLANAHEAD_SYNTH_STRATEGY="TimingWithIOBPacking"
# Set PlanAhead Implementation strategy
PLANAHEAD_IMPL_STRATEGY="MapLogicOptParHighExtra"
