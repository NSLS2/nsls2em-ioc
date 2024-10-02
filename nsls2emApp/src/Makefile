TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Use typed rset structure (see 3.16.1 release notes)
USR_CPPFLAGS += -DUSE_TYPED_RSET


# Auto-generate a header file containing a version string.
# Version comes from the VCS if available, else date+time.
GENVERSION = nsls2emVersion.h
# Macro name
GENVERSIONMACRO = nsls2emVERSION

# Build the IOC application
PROD_IOC = nsls2em

# nsls2em.dbd will be created and installed
DBD += nsls2em.dbd

# nsls2em.dbd will include these files:
nsls2em_DBD += base.dbd
#
nsls2em_DBD += pscCore.dbd
nsls2em_DBD += asSupport.dbd
nsls2em_DBD += drvTetrAMM.dbd
nsls2em_DBD += drvNSLS2_VEM.dbd
nsls2em_DBD += drvNSLS2_EM.dbd
nsls2em_DBD += asyn.dbd
nsls2em_DBD += drvAsynIPPort.dbd
nsls2em_DBD += ADSupport.dbd
nsls2em_DBD += NDPluginSupport.dbd
nsls2em_DBD += busySupport.dbd
nsls2em_DBD += calcSupport.dbd
#
nsls2em_SRCS += drvTetrAMM.cpp
nsls2em_SRCS += subCalcAlarm.c
nsls2em_SRCS += drvQuadEM.cpp
nsls2em_SRCS += drvNSLS2_VEM.cpp
nsls2em_SRCS += drvNSLS2_EM.cpp
#nsls2em_SRCS += subCalcAlarm.c

#
nsls2em_LIBS += pscCore
nsls2em_LIBS += autosave
nsls2em_LIBS += devIocStats
nsls2em_LIBS += caPutLog

# asyn and adcore
nsls2em_LIBS += asyn
nsls2em_LIBS += NDPlugin
nsls2em_LIBS += ADBase
nsls2em_LIBS += busy
nsls2em_LIBS += calc



# nsls2em_registerRecordDeviceDriver.cpp derives from nsls2em.dbd
nsls2em_SRCS += nsls2em_registerRecordDeviceDriver.cpp

# Build the main IOC entry point where needed
nsls2em_SRCS_DEFAULT += nsls2emMain.cpp
nsls2em_SRCS_vxWorks += -nil-

# Link in the code from our support library
# nsls2em_LIBS += nsls2emSupport

# To build SNL programs, SNCSEQ must be defined
# in the <top>/configure/RELEASE file
ifneq ($(SNCSEQ),)
    # Build sncExample into nsls2emSupport
    sncExample_SNCFLAGS += +r
    nsls2em_DBD += sncExample.dbd
    # A .stt sequence program is *not* pre-processed:
    nsls2emSupport_SRCS += sncExample.stt
    nsls2emSupport_LIBS += seq pv
    nsls2em_LIBS += seq pv

    # Build sncProgram as a standalone program
    PROD_HOST += sncProgram
    sncProgram_SNCFLAGS += +m
    # A .st sequence program *is* pre-processed:
    sncProgram_SRCS += sncProgram.st
    sncProgram_LIBS += seq pv
    sncProgram_LIBS += $(EPICS_BASE_HOST_LIBS)
endif

# Link QSRV (pvAccess Server) if available
ifdef EPICS_QSRV_MAJOR_VERSION
    nsls2em_LIBS += qsrv
    nsls2em_LIBS += $(EPICS_BASE_PVA_CORE_LIBS)
    nsls2em_DBD += PVAServerRegister.dbd
    nsls2em_DBD += qsrv.dbd
endif

# Finally link IOC to the EPICS Base libraries
nsls2em_LIBS += $(EPICS_BASE_IOC_LIBS)
nsls2em_SYS_LIBS += event_core event_extra
nsls2em_SYS_LIBS_DEFAULT = event_pthreads

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devnsls2emVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
