#!../../bin/linux-x86_64/nsls2em

< /epics/common/xf31id1-ioc1-netsetup.cmd

errlogInit(5000)

< "$(FILE_ENV_PATHS=envPaths.cmd)"
< "$(FILE_EPICS_ENV=epicsEnv.cmd)"

epicsEnvSet("PREFIX", "$(SYS){$(DEV)}")

## Register all support components
dbLoadDatabase "$(NSLS2EM)/dbd/nsls2em.dbd"
nsls2em_registerRecordDeviceDriver pdbbase

## Load record instances
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
createPSC("CmdPort_$(DEV)", "$(DEVICE_IP)", 7,0)
setPSCSendBlockSize("CmdPort_$(DEV)", 80, 1400)
epicsThreadSleep 1

# EPID records for X and Y axes
epicsEnvSet("PID_X", "PID_X")
epicsEnvSet("PID_Y", "PID_Y")
#dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)},PID=$(PID_X),CV=Reg49-I,MODE=PID,OEGU=nm")
#dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)},PID=$(PID_Y),CV=Reg50-I,MODE=PID,OEGU=nm")

epicsEnvSet("FB_ON_CALC","A&&B&&C&&D&&E&&F&&J&&K&&L") 
epicsEnvSet("PID_PERMIT1", "1")
epicsEnvSet("PID_PERMIT2", "1")
dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)}$(PID_X):,IN=$(SYS){$(DEV)}Reg49-I,OUT=,MODE=PID,CALC=$(FB_ON_CALC),PERMIT1=$(PID_PERMIT1=1),PERMIT2=$(PID_PERMIT2=1),PERMIT3=$(PID_PERMIT3=1),PERMIT4=$(PID_PERMIT4=1),PERMIT5=$(PID_PERMIT5=1),PERMIT6=$(PID_PERMIT6=1),PREC=0,EGU=nm,IEGU=nm,OEGU=nm,MTR_OFF=")
dbLoadRecords("$(NSLS2EM)/db/fb_epid.db", "Sys=$(SYS),Dev={$(DEV)}$(PID_Y):,IN=$(SYS){$(DEV)}Reg50-I,OUT=,MODE=PID,CALC=$(FB_ON_CALC),PERMIT1=$(PID_PERMIT1=1),PERMIT2=$(PID_PERMIT2=1),PERMIT3=$(PID_PERMIT3=1),PERMIT4=$(PID_PERMIT4=1),PERMIT5=$(PID_PERMIT5=1),PERMIT6=$(PID_PERMIT6=1),PREC=0,EGU=nm,IEGU=nm,OEGU=nm,MTR_OFF=")


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
dbpf $(PREFIX)Reg49-I.FLNK $(PREFIX)$(PID_X):Inp-Sts 
dbpf $(PREFIX)Reg50-I.FLNK $(PREFIX)$(PID_Y):Inp-Sts  

dbl > $(TOP)/records.dbl
