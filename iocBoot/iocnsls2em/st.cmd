#!../../bin/linux-x86_64/nsls2em

< /epics/common/xf31id1-lab3-ioc1-netsetup.cmd

errlogInit(5000)

< "$(FILE_ENV_PATHS=envPaths)"
< "$(FILE_EPICS_ENV=epicsEnv.cmd)"

epicsEnvSet("PREFIX", "$(SYS){$(DEV)}")
epicsEnvSet("NSLS2EM", "$(TOP)")

## Register all support components
dbLoadDatabase "$(NSLS2EM)/dbd/nsls2em.dbd"
nsls2em_registerRecordDeviceDriver(pdbbase)

# Increase callback queue size to prevent "callbackRequest: cbLow ring buffer full"
callbackSetQueueSize(32768)

## Load record instances
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(NSLS2EM)/db:$(PSCDRV)/db:$(ADCORE)/db:$(EPICS_BASE)/db")


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

# EPID records for X and Y axes
epicsEnvSet("PID_X", "PID_X")
epicsEnvSet("PID_Y", "PID_Y")

epicsEnvSet("FB_ON_CALC","A&&B&&C&&D&&E&&F&&J&&K&&L") 
epicsEnvSet("PID_PERMIT1", "1")
epicsEnvSet("PID_PERMIT2", "1")

epicsEnvSet("PP1", $(PID_PERMIT1=1))
epicsEnvSet("PP2", $(PID_PERMIT2=1))
epicsEnvSet("PP3", $(PID_PERMIT3=1))
epicsEnvSet("PP4", $(PID_PERMIT4=1))
epicsEnvSet("PP5", $(PID_PERMIT5=1))
epicsEnvSet("PP6", $(PID_PERMIT6=1))
dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)}$(PID_X):,IN=$(SYS){$(DEV)}Reg49-I,OUT=,MODE=PID,CALC=$(FB_ON_CALC),PERMIT1=$(PP1),PERMIT2=$(PP2),PERMIT3=$(PP3),PERMIT4=$(PP4),PERMIT5=$(PP5),PERMIT6=$(PP6),PREC=0,EGU=nm,IEGU=nm,OEGU=nm,MTR_OFF=")
dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)}$(PID_Y):,IN=$(SYS){$(DEV)}Reg50-I,OUT=,MODE=PID,CALC=$(FB_ON_CALC),PERMIT1=$(PP1),PERMIT2=$(PP2),PERMIT3=$(PP3),PERMIT4=$(PP4),PERMIT5=$(PP5),PERMIT6=$(PP6),PREC=0,EGU=nm,IEGU=nm,OEGU=nm,MTR_OFF=")

# pscDrv port
epicsThreadSleep 1
var(PSCDebug, 1)
# createPSC("CmdPort_$(DEV)", "$(DEVICE_IP)", 1234, 1234)
# createPSC("CmdPort_$(DEV)", "$(DEVICE_IP)", 7,0)
# setPSCSendBlockSize("CmdPort_$(DEV)", 80, 1400)

## UDP Protocol
# Listen on 0.0.0.0:1234  (pass zero for random port)
# for messages coming from "device" localhost:8765
createPSCUDP("CmdPort_$(DEV)", $(DEVICE_IP), 1234, 1234)

# DMA waveform
createPSC("wfm_rx_$(DEV)",  $(DEVICE_IP), 3000, 20)
createPSC("RxPort_$(DEV)", "$(DEVICE_IP)", 7,10)

epicsThreadSleep 1

< $(NSLS2EM)/iocBoot/iocnsls2em/saveRestore.cmd

save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("$(TOP)/as/save")
set_requestfile_path("$(TOP)/as/req")
set_requestfile_path("$(EPICS_BASE)/req")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

save_restoreSet_status_prefix("$(PREFIX)")

iocInit()

epicsThreadSleep 1

cd $(TOP)/as/req
makeAutosaveFiles()
cd $(TOP)

create_monitor_set("info_settings.req", 30, "")
create_monitor_set("info_positions.req", 10, "")

# Load calibration for the device (based on the serial number)
< $(NSLS2EM)/calibration/$(DEVICE_SN).cmd

epicsThreadSleep 1

# GTX reset
dbpf $(PREFIX)Reg31-Sp 255
epicsThreadSleep 0.2
dbpf $(PREFIX)Reg31-Sp 0

epicsThreadSleep 1

dbpf $(PREFIX)Reg8-Sp 7520

# Link updates to EPID records for X and Y axes
dbpf $(PREFIX)Reg49-I.FLNK $(PREFIX)$(PID_X):Inp-Sts 
dbpf $(PREFIX)Reg50-I.FLNK $(PREFIX)$(PID_Y):Inp-Sts  

dbl > $(TOP)/records.dbl
