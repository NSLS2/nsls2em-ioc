#!../../bin/linux-x86_64/nsls2em

#< /epics/common/xf03idc-ioc2-netsetup.cmd
< /epics/common/xf31id1-ioc1-netsetup.cmd


errlogInit(5000)

< "$(FILE_ENV_PATHS=envPaths.cmd)"
< "$(FILE_EPICS_ENV=epicsEnv.cmd)"

epicsEnvSet("PREFIX", "$(SYS){$(DEV)}")

## Register all support components
dbLoadDatabase "$(NSLS2EM)/dbd/nsls2em.dbd"
nsls2em_registerRecordDeviceDriver pdbbase

## Load record instances
#epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db:$(QUADEM)/db")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")


######################################################
drvAsynIPPortConfigure("IP_$(PORT)", "$(IP)", 0, 0, 0)
asynOctetSetInputEos("IP_$(PORT)",  0, "\r\n")
asynOctetSetOutputEos("IP_$(PORT)", 0, "\r")
# Set both TRACE_IO_ESCAPE (for ASCII command/response) and TRACE_IO_HEX (for binary data)
asynSetTraceIOMask("IP_$(PORT)", 0, 6)
#asynSetTraceFile("IP_$(PORT)", 0, "AHxxx.out")
#asynSetTraceMask("IP_$(PORT)", 0, 9)
asynSetTraceIOTruncateSize("IP_$(PORT)", 0, 4000)
# Load asynRecord record
dbLoadRecords("$(ASYN)/db/asynRecord.db","P=$(PREFIX),R=asyn1,PORT=IP_$(PORT),ADDR=0,OMAX=256,IMAX=256")
asynSetTraceIOMask("IP_$(PORT)",0,2)
# Enable ASYN_TRACE_ERROR and ASYN_TRACE_WARNING
#asynSetTraceMask("$(PORT)",  0, 0x21)

###################################################
## /epics/utils/rhel8-epics-config/BUILD/support/areaDetector/ADCore/ADApp/Db/NDArrayBase.template
##
drvNSLS2_VEMConfigure("$(PORT)", "IP_$(PORT)", $(RING_SIZE))
dbLoadRecords("$(ADCORE)/db/NDArrayBase.template", "P=$(SYS), R="{$(DEV)}", PORT=$(PORT), ADDR=0, TIMEOUT=1")
dbLoadRecords("$(NSLS2EM)/db/quadEM_nsls2em.template",  "P=$(SYS), R="{$(DEV)}", PORT=$(PORT), ADDR=0, TIMEOUT=1")
dbLoadRecords("$(NSLS2EM)/db/nsls2em_RevD.template", "P=$(SYS), R="{$(DEV)}", PORT=$(PORT), ADDR=0, TIMEOUT=1")

### Plugins
< ${NSLS2EM}/iocBoot/iocnsls2em/commonPlugins.cmd
###################################################

######################################################
## Load pscdrv record instances
######################################################
dbLoadRecords("$(NSLS2EM)/db/nsls2em_pscdrv.template", "PriSys=$(SYS),PSC=$(DEV)")

epicsEnvSet("_WORK_DIR", $(PWD))

#Port 7: Command and Status
cd $(NSLS2EM)
dbLoadRecords("$(NSLS2EM)/db/Connection.db", "PriSys=$(SYS),PSC=$(DEV)")
dbLoadRecords("$(NSLS2EM)/db/Misc.db", "PriSys=$(SYS),PSC=$(DEV)")
dbLoadRecords("$(NSLS2EM)/db/DAC_Setpoint.db", "PriSys=$(SYS),PSC=$(DEV)")
dbLoadTemplate ("$(NSLS2EM)/db/CommandReg.substitutions", "PriSys=$(SYS),PSC=$(DEV)")
dbLoadTemplate ("$(NSLS2EM)/db/StatusFloatReg.substitutions", "PriSys=$(SYS),PSC=$(DEV)")
dbLoadTemplate ("$(NSLS2EM)/db/StatusReg.substitutions", "PriSys=$(SYS),PSC=$(DEV)")
dbLoadTemplate ("$(NSLS2EM)/db/RangeGainOffset.substitutions", "PriSys=$(SYS),PSC=$(DEV)")
cd $(_WORK_DIR)

# pscDrv port
epicsThreadSleep 1
var(PSCDebug, 1)
#Port 7 for command and status
#createPSC("CmdPort_$(PORT)", "$(DEVICE_IP)", 7,0)
#setPSCSendBlockSize("CmdPort_$(PORT)", 80, 1400)
createPSC("CmdPort_$(DEV)", "$(DEVICE_IP)", 7,0)
setPSCSendBlockSize("CmdPort_$(DEV)", 80, 1400)
epicsThreadSleep 1

#Port 17 for ADC waveform
#dbLoadRecords("$(NSLS2EM)/db/ADCSingle.db","PriSys=NSLS2:XF00,PSC=EM1,Chan=Chan1,ADC_Single_POINTS=40")
#createPSC("AdcPort_EM1", "$(DEVICE_IP)", 17,0)

# EPID records for X and Y axes

epicsEnvSet("PID_X", "PID_X")
epicsEnvSet("PID_Y", "PID_Y")
dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)},PID=$(PID_X),CV=Reg49-I,MODE=PID,OEGU=nm")
dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)},PID=$(PID_Y),CV=Reg50-I,MODE=PID,OEGU=nm")

< $(NSLS2EM)/iocBoot/iocnsls2em/saveRestore.cmd

iocInit()

makeAutosaveFileFromDbInfo("$(TOP)/as/req/info_settings.req", "autosaveFields")
makeAutosaveFileFromDbInfo("$(TOP)/as/req/info_positions.req", "autosaveFields_pass0")
create_monitor_set("info_settings.req",30)
create_monitor_set("info_positions.req",10)

epicsThreadSleep 1

# Load calibration for the device (based on the serial number)
< $(NSLS2EM)/calibration/$(DEVICE_SN).cmd

epicsThreadSleep 1

# Set the update rate (50 Hz)
dbpf $(PREFIX)regsend.SCAN ".02 second"
dbpf $(PREFIX)Reg8-Sp 7520

# Link updates to EPID records for X and Y axes
dbpf $(PREFIX)Reg49-I.FLNK $(PREFIX)$(PID_X) 
dbpf $(PREFIX)Reg50-I.FLNK $(PREFIX)$(PID_Y) 

#default calibration parameters
# 1: for pscDrv  0 for quadEM
#dbpf $(PREFIX)Reg200-Sp 0
#
#dbpf $(PREFIX)ChanA-Range-Sp 0
#epicsThreadSleep 1
#dbpf $(PREFIX)ChanA-Range-Sp 1
#epicsThreadSleep 1
#dbpf $(PREFIX)ChanA-Range-Sp 0
#
#dbpf $(PREFIX)Reg140-Sp 100
#dbpf $(PREFIX)Reg141-Sp 100
#dbpf $(PREFIX)Reg142-Sp 100
#dbpf $(PREFIX)Reg143-Sp 100
#dbpf $(PREFIX)Reg144-Sp 100
#dbpf $(PREFIX)Reg145-Sp 100
#dbpf $(PREFIX)Reg146-Sp 510000
#dbpf $(PREFIX)Reg147-Sp 510000
#dbpf $(PREFIX)Reg148-Sp 510000
#dbpf $(PREFIX)Reg149-Sp 510000
#dbpf $(PREFIX)Reg150-Sp 510000
#dbpf $(PREFIX)Reg151-Sp 510000
#dbpf $(PREFIX)Reg152-Sp 100
#dbpf $(PREFIX)Reg153-Sp 100
#dbpf $(PREFIX)Reg154-Sp 100
#dbpf $(PREFIX)Reg155-Sp 100
#dbpf $(PREFIX)Reg156-Sp 100
#dbpf $(PREFIX)Reg157-Sp 100
#dbpf $(PREFIX)Reg158-Sp 510000
#dbpf $(PREFIX)Reg159-Sp 510000
#dbpf $(PREFIX)Reg160-Sp 510000
#dbpf $(PREFIX)Reg161-Sp 510000
#dbpf $(PREFIX)Reg162-Sp 510000
#dbpf $(PREFIX)Reg163-Sp 510000
#dbpf $(PREFIX)Reg164-Sp 100
#dbpf $(PREFIX)Reg165-Sp 100
#dbpf $(PREFIX)Reg166-Sp 100
#dbpf $(PREFIX)Reg167-Sp 100
#dbpf $(PREFIX)Reg168-Sp 100
#dbpf $(PREFIX)Reg169-Sp 100
#dbpf $(PREFIX)Reg170-Sp 510000
#dbpf $(PREFIX)Reg171-Sp 510000
#dbpf $(PREFIX)Reg172-Sp 510000
#dbpf $(PREFIX)Reg173-Sp 510000
#dbpf $(PREFIX)Reg174-Sp 510000
#dbpf $(PREFIX)Reg175-Sp 510000
#dbpf $(PREFIX)Reg176-Sp 100
#dbpf $(PREFIX)Reg177-Sp 100
#dbpf $(PREFIX)Reg178-Sp 100
#dbpf $(PREFIX)Reg179-Sp 100
#dbpf $(PREFIX)Reg180-Sp 100
#dbpf $(PREFIX)Reg181-Sp 100
#dbpf $(PREFIX)Reg182-Sp 510000
#dbpf $(PREFIX)Reg183-Sp 510000
#dbpf $(PREFIX)Reg184-Sp 510000
#dbpf $(PREFIX)Reg185-Sp 510000
#dbpf $(PREFIX)Reg186-Sp 510000
#dbpf $(PREFIX)Reg187-Sp 510000

#dbpf $(PREFIX)Reg8-Sp 32000
#dbpf $(PREFIX)Reg24-Sp 32000
#dbpf $(PREFIX)Reg25-Sp 32000
#dbpf $(PREFIX)Reg26-Sp 32000
#dbpf $(PREFIX)Reg27-Sp 32000

#dbpf $(PREFIX)Reg17-Sp 10000000
#dbpf $(PREFIX)Reg18-Sp 10000000

dbl > $(TOP)/records.dbl
