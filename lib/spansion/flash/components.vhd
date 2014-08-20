
-- pragma translate_off
LIBRARY IEEE;
    USE IEEE.std_logic_1164.ALL;
    USE IEEE.VITAL_timing.ALL;
    USE IEEE.VITAL_primitives.ALL;

    USE STD.textio.ALL;

LIBRARY FMF;
    USE FMF.gen_utils.all;
    USE FMF.conversions.all;

package components is

component S29GL128P IS
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_A0             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A1             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A2             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A3             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A4             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A5             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A6             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A7             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A8             : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A9             : VitalDelayType01 := VitalZeroDelay01; --address
        tipd_A10            : VitalDelayType01 := VitalZeroDelay01; --lines
        tipd_A11            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A12            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A13            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A14            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A15            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A16            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A17            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A18            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A19            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A20            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A21            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_A22            : VitalDelayType01 := VitalZeroDelay01; --

        tipd_DQ0            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ1            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ2            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ3            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ4            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ5            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ6            : VitalDelayType01 := VitalZeroDelay01; -- data
        tipd_DQ7            : VitalDelayType01 := VitalZeroDelay01; -- lines
        tipd_DQ8            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ9            : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ10           : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ11           : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ12           : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ13           : VitalDelayType01 := VitalZeroDelay01; --
        tipd_DQ14           : VitalDelayType01 := VitalZeroDelay01; --

        tipd_DQ15           : VitalDelayType01 := VitalZeroDelay01; -- DQ15/A-1

        tipd_CENeg          : VitalDelayType01 := VitalZeroDelay01;
        tipd_OENeg          : VitalDelayType01 := VitalZeroDelay01;
        tipd_WENeg          : VitalDelayType01 := VitalZeroDelay01;
        tipd_RESETNeg       : VitalDelayType01 := VitalZeroDelay01;
        tipd_WPNeg          : VitalDelayType01 := VitalZeroDelay01; --WP#/ACC
        tipd_BYTENeg        : VitalDelayType01 := VitalZeroDelay01;

        -- tpd delays
        tpd_A0_DQ0          : VitalDelayType01 := UnitDelay01;--tACC
        tpd_A0_DQ1          : VitalDelayType01 := UnitDelay01;--tPACC
        tpd_CENeg_DQ0       : VitalDelayType01Z := UnitDelay01Z;
        --(tCE,tCE,tDF,-,tDF,-)
        tpd_OENeg_DQ0       : VitalDelayType01Z := UnitDelay01Z;
        --(tOE,tOE,tDF,-,tDF,-)
        tpd_RESETNeg_DQ0    : VitalDelayType01Z := UnitDelay01Z;
        --(-,-,0,-,0,-)
        tpd_CENeg_RY        : VitalDelayType01 := UnitDelay01; --tBUSY
        tpd_WENeg_RY        : VitalDelayType01 := UnitDelay01; --tBUSY

        --tsetup values
        tsetup_A0_CENeg     : VitalDelayType := UnitDelay;  --tAS edge \
        tsetup_A0_OENeg     : VitalDelayType := UnitDelay;  --tASO edge \
        tsetup_DQ0_CENeg    : VitalDelayType := UnitDelay;  --tDS edge /

        --thold values
        thold_CENeg_RESETNeg: VitalDelayType := UnitDelay;   --tRH  edge /
        thold_OENeg_WENeg_RY_EQ_1_noedge_posedge
                            : VitalDelayType := UnitDelay;   --tOEH edge /
        thold_OENeg_WENeg_RY_EQ_0_noedge_posedge
                            : VitalDelayType := UnitDelay;   --tOEH edge /
        thold_A0_CENeg      : VitalDelayType := UnitDelay;   --tAH  edge \
        thold_A0_OENeg      : VitalDelayType := UnitDelay;   --tAHT edge \
        thold_DQ0_CENeg     : VitalDelayType := UnitDelay;   --tDH edge /
        thold_WENeg_OENeg   : VitalDelayType := UnitDelay;   --tGHWL edge /
        thold_CENeg_WENeg   : VitalDelayType := UnitDelay;   --tCEH edge /

        --tpw values: pulse width
        tpw_RESETNeg_negedge: VitalDelayType := UnitDelay; --tRP
        tpw_OENeg_posedge   : VitalDelayType := UnitDelay; --tOEPH
        tpw_WENeg_negedge   : VitalDelayType := UnitDelay; --tWP
        tpw_WENeg_posedge   : VitalDelayType := UnitDelay; --tWPH
        tpw_CENeg_negedge   : VitalDelayType := UnitDelay; --tCP
        tpw_CENeg_RY_EQ_1_posedge   : VitalDelayType := UnitDelay; --tCPH
        tpw_CENeg_RY_EQ_0_posedge   : VitalDelayType := UnitDelay; --tCEPH
        tpw_A0_negedge      : VitalDelayType := UnitDelay; --tWC tRC

        -- tdevice values: values for internal delays
            --Effective Write Buffer Program Operation  tWHWH1
        tdevice_WBPB        : VitalDelayType    := 7500 ns; -- 15 us per word
            --Program Operation
        tdevice_POW         : VitalDelayType    := 60 us;-- per word
            --Sector Erase Operation    tWHWH2
            --reduced 1000 times due to simulate with customer ISIM tool
            --real time for tdevice_SEO is 500 ms
        tdevice_SEO         : VitalDelayType    := 500 us;
            --Timing Limit Exceeded
        tdevice_HANG        : VitalDelayType    := 400 us;
            --program/erase suspend timeout
        tdevice_START_T1    : VitalDelayType    := 5 us;
            --sector erase command sequence timeout
        tdevice_CTMOUT      : VitalDelayType    := 50 us;
            --device ready after Hardware reset(during embeded algorithm)
        tdevice_READY       : VitalDelayType    := 35 us;
        -- Password Unlock
        tdevice_UNLOCK      : VitalDelayType    := 2 us;
        -- configuring the PPB Lock bit to the freeze state
        tdevice_PPBLOCK     : VitalDelayType    := 100 ns;
        -- generic control parameters
        InstancePath        : STRING    := DefaultInstancePath;
        TimingChecksOn      : BOOLEAN   := DefaultTimingChecks;
        MsgOn               : BOOLEAN   := DefaultMsgOn;
        XOn                 : BOOLEAN   := DefaultXon;
        -- memory file to be loaded
        mem_file_name       : STRING    := "none";--"s29gl128p.mem";
        prot_file_name      : STRING    := "none";--"s29gl128p_prot.mem";
        secsi_file_name     : STRING    := "none";--"s29gl128p_secsi.mem";

        UserPreload         : BOOLEAN   := FALSE;
        LongTimming         : BOOLEAN   := TRUE;

        -- For FMF SDF technology file usage
        TimingModel         : STRING   := "S29GL128P11FFI010"
    );
    PORT (
        A22             : IN    std_ulogic := 'U'; --
        A21             : IN    std_ulogic := 'U'; --
        A20             : IN    std_ulogic := 'U'; --
        A19             : IN    std_ulogic := 'U'; --
        A18             : IN    std_ulogic := 'U'; --
        A17             : IN    std_ulogic := 'U'; --
        A16             : IN    std_ulogic := 'U'; --
        A15             : IN    std_ulogic := 'U'; --
        A14             : IN    std_ulogic := 'U'; --
        A13             : IN    std_ulogic := 'U'; --address
        A12             : IN    std_ulogic := 'U'; --lines
        A11             : IN    std_ulogic := 'U'; --
        A10             : IN    std_ulogic := 'U'; --
        A9              : IN    std_ulogic := 'U'; --
        A8              : IN    std_ulogic := 'U'; --
        A7              : IN    std_ulogic := 'U'; --
        A6              : IN    std_ulogic := 'U'; --
        A5              : IN    std_ulogic := 'U'; --
        A4              : IN    std_ulogic := 'U'; --
        A3              : IN    std_ulogic := 'U'; --
        A2              : IN    std_ulogic := 'U'; --
        A1              : IN    std_ulogic := 'U'; --
        A0              : IN    std_ulogic := 'U'; --

        DQ15            : INOUT std_ulogic := 'U'; -- DQ15/A-1
        DQ14            : INOUT std_ulogic := 'U'; --
        DQ13            : INOUT std_ulogic := 'U'; --
        DQ12            : INOUT std_ulogic := 'U'; --
        DQ11            : INOUT std_ulogic := 'U'; --
        DQ10            : INOUT std_ulogic := 'U'; --
        DQ9             : INOUT std_ulogic := 'U'; -- data
        DQ8             : INOUT std_ulogic := 'U'; -- lines
        DQ7             : INOUT std_ulogic := 'U'; --
        DQ6             : INOUT std_ulogic := 'U'; --
        DQ5             : INOUT std_ulogic := 'U'; --
        DQ4             : INOUT std_ulogic := 'U'; --
        DQ3             : INOUT std_ulogic := 'U'; --
        DQ2             : INOUT std_ulogic := 'U'; --
        DQ1             : INOUT std_ulogic := 'U'; --
        DQ0             : INOUT std_ulogic := 'U'; --

        CENeg           : IN    std_ulogic := 'U';
        OENeg           : IN    std_ulogic := 'U';
        WENeg           : IN    std_ulogic := 'U';
        RESETNeg        : IN    std_ulogic := 'U';
        WPNeg           : IN    std_ulogic := 'U'; --WP#/ACC
        BYTENeg         : IN    std_ulogic := 'U';
        RY              : OUT   std_ulogic := 'U'  --RY/BY#
    );
  end component;
end;

-- pragma translate_on
