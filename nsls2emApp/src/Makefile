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
PROD_NAME = nsls2em
PROD_IOC_WIN32 += $(PROD_NAME)
PROD_IOC_Linux += $(PROD_NAME)

# nsls2em.dbd will be created and installed
DBD += $(PROD_NAME).dbd

$(PROD_NAME)_DBD += base.dbd
$(PROD_NAME)_DBD += pscCore.dbd
$(PROD_NAME)_DBD += drvNSLS2_VEM.dbd
$(PROD_NAME)_DBD += epidRecord.dbd

$(PROD_NAME)_LIBS += std
$(PROD_NAME)_LIBS += pscCore

$(PROD_NAME)_SRCS += subCalcAlarm.c
$(PROD_NAME)_SRCS += drvQuadEM.cpp
$(PROD_NAME)_SRCS += drvNSLS2_VEM.cpp

# nsls2em_registerRecordDeviceDriver.cpp derives from nsls2em.dbd
nsls2em_SRCS += $(PROD_NAME)_registerRecordDeviceDriver.cpp $(PROD_NAME)Main.cpp

include $(ADCORE)/ADApp/commonDriverMakefile

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

# Explicit dependency needed for generated header file
devnsls2emVersion$(DEP): $(COMMON_DIR)/$(GENVERSION)
