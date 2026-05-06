#!/bin/csh -f
setenv CDSHOME /home/install/IC618
setenv PATH ${CDSHOME}/bin:${CDSHOME}/tools.lnx86/bin:${PATH}
if ($?LD_LIBRARY_PATH) then
    setenv LD_LIBRARY_PATH ${CDSHOME}/tools/lib:${LD_LIBRARY_PATH}
else
    setenv LD_LIBRARY_PATH ${CDSHOME}/tools/lib
endif

setenv KIT_DIR /home/install/SCL180/SCLPDK_V3.0_KIT/scl180/pdk/cdns/sclpdk_v3/
setenv RDS_ROOT $KIT_DIR/HOTCODE
setenv MGC_CALIBRE_CUSTOMIZATION_FILE \
    $RDS_ROOT/techs/generic/calibre/calibre_ts_drc.custom
setenv PERL5 /usr/bin/perl

source $RDS_ROOT/etc/RDS.cshrc
source $RDS_ROOT/etc/cdsDesKit.cshrc
source $RDS_ROOT/etc/cdsSystem.cshrc

setenv RDS_CDSLIBS /home/install/SCL180/SCLPDK_V3.0_KIT/scl180/pdk/cdns/sclpdk_v3/HOTCODE/amslibs/cds_default/cdslibs
setenv CDS_LIC_FILE 5280@10.3.32.9
setenv PROJ_ROOT /home/cmos/projects

# Set these AFTER sourcing PDK scripts so they override PDK defaults
setenv CDS_LIC_FILE 5280@10.3.32.9
setenv PROJ_ROOT /home/cmos/projects
setenv PATH /home/install/SPECTRE211/tools.lnx86/spectre/bin/64bit:${PATH}

setenv LD_LIBRARY_PATH /home/install/SPECTRE211/tools.lnx86/mdl/lib/64bit:${LD_LIBRARY_PATH}
setenv LD_LIBRARY_PATH /home/install/SPECTRE211/tools.lnx86/fmc/lib/64bit:${LD_LIBRARY_PATH}
setenv LD_LIBRARY_PATH /home/install/SPECTRE211/tools.lnx86/inca/lib/64bit:${LD_LIBRARY_PATH}
setenv LD_LIBRARY_PATH /home/install/SPECTRE211/tools.lnx86/lib/64bit:${LD_LIBRARY_PATH}
