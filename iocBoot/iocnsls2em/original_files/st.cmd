#!../../bin/linux-x86_64/nsls2em


errlogInit(5000)
epicsEnvSet("QUADEM",   "/epics/iocs/quadEM")

< envPaths

epicsEnvSet("PREFIX",    "XF:31ID-BI:")
epicsEnvSet("RECORD",    "NSLS2_EM:")
epicsEnvSet("PORT",      "NSLS2_EM")
epicsEnvSet("TEMPLATE",  "NSLS2_EM")
##epicsEnvSet("MODEL",     "NSLS2_EM")
epicsEnvSet("QSIZE",     "20")
epicsEnvSet("RING_SIZE", "10000")
epicsEnvSet("TSPOINTS",  "1000")
epicsEnvSet("IP",        "10.69.58.70:17")
#epicsEnvSet("QUAD_DET",        "TetrAMM.cmd")
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", "1000000")


#cd "${TOP}"
cd "/epics/iocs/nsls2em"

## Register all support components
dbLoadDatabase "dbd/nsls2em.dbd"
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
#asynSetTraceFile("IP_$(PORT)",   0, "AHxxx.out")
#asynSetTraceMask("IP_$(PORT)",   0,  9)
asynSetTraceIOTruncateSize("IP_$(PORT)", 0, 4000)
# Load asynRecord record
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(PREFIX), R=asyn1,PORT=IP_$(PORT),ADDR=0,OMAX=256,IMAX=256")
asynSetTraceIOMask("$(PORT)",0,2)
# Enable ASYN_TRACE_ERROR and ASYN_TRACE_WARNING
#asynSetTraceMask("$(PORT)",  0, 0x21)

###################################################
## /epics/utils/rhel8-epics-config/BUILD/support/areaDetector/ADCore/ADApp/Db/NDArrayBase.template
##
drvNSLS2_VEMConfigure("$(PORT)", "IP_$(PORT)", $(RING_SIZE))
dbLoadRecords("$(ADCORE)/db/NDArrayBase.template", "P=$(PREFIX), R=$(RECORD), PORT=$(PORT), ADDR=0, TIMEOUT=1")
dbLoadRecords("db/quadEM_nsls2em.template",  "P=$(PREFIX), R=$(RECORD), PORT=$(PORT), ADDR=0, TIMEOUT=1")
dbLoadRecords("db/nsls2em_RevD.template", "P=$(PREFIX), R=$(RECORD), PORT=$(PORT), ADDR=0, TIMEOUT=1")
### Plugins
< ${TOP}/iocBoot/${IOC}/commonPlugins.cmd
###################################################

######################################################
## Load pscdrv record instances
######################################################
dbLoadRecords("db/nsls2em_pscdrv.template", "PriSys=$(PREFIX),PSC=$(RECORD)")

#Port 7: Command and Status
dbLoadRecords("db/Connection.db",    "PriSys=$(PREFIX),PSC=$(RECORD)")
dbLoadRecords("db/Misc.db",          "PriSys=$(PREFIX),PSC=$(RECORD)")
dbLoadTemplate ("db/CommandReg.substitutions", "PriSys=$(PREFIX),PSC=$(RECORD)")
dbLoadTemplate ("db/StatusFloatReg.substitutions", "PriSys=$(PREFIX),PSC=$(RECORD)")
dbLoadTemplate ("db/StatusReg.substitutions", "PriSys=$(PREFIX),PSC=$(RECORD)")


# pscDrv port
epicsThreadSleep 1
var(PSCDebug, 1)
#Port 7 for command and status
createPSC("CmdPort_$(RECORD)", "10.69.58.70", 7,0)
setPSCSendBlockSize("CmdPort_$(RECORD)", 80, 1400)
epicsThreadSleep 1

#Port 17 for ADC waveform
#dbLoadRecords("./db/ADCSingle.db","PriSys=NSLS2:XF00,PSC=EM1,Chan=Chan1,ADC_Single_POINTS=40")
#createPSC("AdcPort_EM1", "10.69.58.70", 17,0)


######################################################
set_savefile_path("$(PWD)/as","/save/")
set_requestfile_path("$(PWD)/as","/req/")
system "install -m 744 -d $(PWD)/as/save"
system "install -m 744 -d $(PWD)/as/req"

set_pass0_restoreFile("settings.sav")
######################################################


######################################################
#< ${TOP}/iocBoot/${IOC}/saveRestore.cmd
######################################################

cd "${TOP}/iocBoot/${IOC}"

iocInit()

###########
set_savefile_path("$(PWD)/as","/save/")
set_requestfile_path("$(PWD)/as","/req/")
system "install -m 744 -d $(PWD)/as/save"
system "install -m 744 -d $(PWD)/as/req"

set_pass0_restoreFile("settings.sav")
############


#default calibration parameters
# 1: for pscDrv  0 for quadEM
dbpf $(PREFIX){$(RECORD)}Reg200-Sp 0

dbpf $(PREFIX){$(RECORD)}Reg140-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg141-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg142-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg143-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg144-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg145-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg146-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg147-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg148-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg149-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg150-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg151-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg152-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg153-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg154-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg155-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg156-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg157-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg158-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg159-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg160-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg161-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg162-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg163-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg164-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg165-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg166-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg167-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg168-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg169-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg170-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg171-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg172-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg173-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg174-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg175-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg176-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg177-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg178-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg179-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg180-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg181-Sp 100
dbpf $(PREFIX){$(RECORD)}Reg182-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg183-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg184-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg185-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg186-Sp 510000
dbpf $(PREFIX){$(RECORD)}Reg187-Sp 510000

dbpf $(PREFIX){$(RECORD)}Reg8-Sp 32000
dbpf $(PREFIX){$(RECORD)}Reg24-Sp 32000
dbpf $(PREFIX){$(RECORD)}Reg25-Sp 32000
dbpf $(PREFIX){$(RECORD)}Reg26-Sp 32000
dbpf $(PREFIX){$(RECORD)}Reg27-Sp 32000

dbpf $(PREFIX){$(RECORD)}Reg17-Sp 10000000
dbpf $(PREFIX){$(RECORD)}Reg18-Sp 10000000
