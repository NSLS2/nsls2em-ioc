

# Macro
#epicsEnvSet("SYS",    "XF:31ID-BI:")
#epicsEnvSet("DEV",    "TetrAMM:")
#epicsEnvSet("PORT",      "TetrAMM")
#epicsEnvSet("TEMPLATE",  "TetrAMM")
##epicsEnvSet("MODEL",     "TetrAMM")
#epicsEnvSet("QSIZE",     "20")
#epicsEnvSet("RING_SIZE", "10000")
#epicsEnvSet("TSPOINTS",  "1000")

#
epicsEnvSet("T1",  "Current1")
epicsEnvSet("T2",  "Current2")
epicsEnvSet("T3",  "Current3")
epicsEnvSet("T4",  "Current4")
epicsEnvSet("T5",  "SumX")
epicsEnvSet("T6",  "SumY")
epicsEnvSet("T7",  "SumAll")
epicsEnvSet("T8",  "DiffX")
epicsEnvSet("T9",  "DiffY")
epicsEnvSet("T10", "PosX")
epicsEnvSet("T11", "PosY")
epicsEnvSet("T12", "EVR")
epicsEnvSet("T13", "GPIO")
epicsEnvSet("T14", "COUNT")

# Create 14 statistics plugins

NDStatsConfigure("$(PORT)_STATS1", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T1):, PORT=$(PORT)_STATS1, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=0, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1,")
NDTimeSeriesConfigure("$(PORT)_STATS1_TS", $(QSIZE), 0, "$(PORT)_STATS1", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T1):TS:, PORT=$(PORT)_STATS1_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS1,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS2", $(QSIZE), 0, "$(PORT)", 1, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T2):, PORT=$(PORT)_STATS2, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=1, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS2_TS", $(QSIZE), 0, "$(PORT)_STATS2", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T2):TS:, PORT=$(PORT)_STATS2_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS2,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS3", $(QSIZE), 0, "$(PORT)", 2, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T3):, PORT=$(PORT)_STATS3, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=2, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS3_TS", $(QSIZE), 0, "$(PORT)_STATS3", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T3):TS:, PORT=$(PORT)_STATS3_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS3,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS4", $(QSIZE), 0, "$(PORT)", 3, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T4):, PORT=$(PORT)_STATS4, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=3, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS4_TS", $(QSIZE), 0, "$(PORT)_STATS4", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T4):TS:, PORT=$(PORT)_STATS4_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS4,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS5", $(QSIZE), 0, "$(PORT)", 4, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T5):, PORT=$(PORT)_STATS5, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=4, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS5_TS", $(QSIZE), 0, "$(PORT)_STATS5", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T5):TS:, PORT=$(PORT)_STATS5_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS5,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS6", $(QSIZE), 0, "$(PORT)", 5, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T6):, PORT=$(PORT)_STATS6, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=5, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS6_TS", $(QSIZE), 0, "$(PORT)_STATS6", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T6):TS:, PORT=$(PORT)_STATS6_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS6,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS7", $(QSIZE), 0, "$(PORT)", 6, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T7):, PORT=$(PORT)_STATS7, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=6, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS7_TS", $(QSIZE), 0, "$(PORT)_STATS7", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T7):TS:, PORT=$(PORT)_STATS7_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS7,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS8", $(QSIZE), 0, "$(PORT)", 7, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T8):, PORT=$(PORT)_STATS8, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=7, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS8_TS", $(QSIZE), 0, "$(PORT)_STATS8", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T8):TS:, PORT=$(PORT)_STATS8_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS8,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS9", $(QSIZE), 0, "$(PORT)", 8, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T9):, PORT=$(PORT)_STATS9, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=8, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS9_TS", $(QSIZE), 0, "$(PORT)_STATS9", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T9):TS:, PORT=$(PORT)_STATS9_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS9,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS10",$(QSIZE), 0, "$(PORT)", 9, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T10):,PORT=$(PORT)_STATS10,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=9, HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS10_TS", $(QSIZE), 0, "$(PORT)_STATS10", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T10):TS:, PORT=$(PORT)_STATS10_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS10,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
#
NDStatsConfigure("$(PORT)_STATS11",$(QSIZE), 0, "$(PORT)", 10, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T11):,PORT=$(PORT)_STATS11,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=10,HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS11_TS", $(QSIZE), 0, "$(PORT)_STATS11", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T11):TS:, PORT=$(PORT)_STATS11_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS11,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")


### 3/14/25 added address 11 for EVR timestamp
NDStatsConfigure("$(PORT)_STATS12",$(QSIZE), 0, "$(PORT)", 11, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T12):,PORT=$(PORT)_STATS12,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=11,HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS12_TS", $(QSIZE), 0, "$(PORT)_STATS12", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T12):TS:, PORT=$(PORT)_STATS12_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS12,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")

# 7/22/25 GPIO
NDStatsConfigure("$(PORT)_STATS13",$(QSIZE), 0, "$(PORT)", 12, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T13):,PORT=$(PORT)_STATS13,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=12,HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS13_TS", $(QSIZE), 0, "$(PORT)_STATS13", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T13):TS:, PORT=$(PORT)_STATS13_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS13,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")
# 7/22/25 COUNT
NDStatsConfigure("$(PORT)_STATS14",$(QSIZE), 0, "$(PORT)", 13, 0, 0)
dbLoadRecords("$(ADCORE)/db/NDStats.template",     "P=$(SYS),R={$(DEV)}$(T14):,PORT=$(PORT)_STATS14,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=13,HIST_SIZE=256,XSIZE=$(RING_SIZE),YSIZE=0,NCHANS=$(TSPOINTS),ENABLED=1")
NDTimeSeriesConfigure("$(PORT)_STATS14_TS", $(QSIZE), 0, "$(PORT)_STATS14", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}$(T14):TS:, PORT=$(PORT)_STATS14_TS,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_STATS14,NDARRAY_ADDR=1,NCHANS=$(TSPOINTS),ENABLED=1")



# Create a netCDF file saving plugin.
NDFileNetCDFConfigure("$(PORT)_FileNetCDF1", $(QSIZE), 0, "$(PORT)", 14)
dbLoadRecords("$(ADCORE)/db/NDFileNetCDF.template","P=$(SYS),R={$(DEV)}netCDF1:,PORT=$(PORT)_FileNetCDF1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=14,ENABLED=0")

# Create an HDF5 file saving plugin
NDFileHDF5Configure("$(PORT)_FileHDF1", $(QSIZE), 0, "$(PORT)", 14)
dbLoadRecords("$(ADCORE)/db/NDFileHDF5.template",  "P=$(SYS),R={$(DEV)}HDF1:,PORT=$(PORT)_FileHDF1,ADDR=0,TIMEOUT=1,XMLSIZE=2048,NDARRAY_PORT=$(PORT)")

# This creates a waveform large enough for 11x10000 arrays.
NDStdArraysConfigure("$(PORT)_Image1", $(QSIZE), 0, "$(PORT)", 14)
dbLoadRecords("$(ADCORE)/db/NDStdArrays.template", "P=$(SYS),R={$(DEV)}image1:,PORT=$(PORT)_Image1,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=14,TYPE=Float64,FTVL=DOUBLE,NELEMENTS=110000,ENABLED=0")


# Time series plugin
NDTimeSeriesConfigure("$(PORT)_TS1", $(QSIZE), 0, "$(PORT)", 14, 14)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template",  "P=$(SYS),R={$(DEV)}TS:,       PORT=$(PORT)_TS1,ADDR=0, TIMEOUT=1,NDARRAY_PORT=$(PORT),NDARRAY_ADDR=13,NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}SampleTime_RBV CP MS,ENABLED=1")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T1):, PORT=$(PORT)_TS1,ADDR=0, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T1)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T2):, PORT=$(PORT)_TS1,ADDR=1, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T2)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T3):, PORT=$(PORT)_TS1,ADDR=2, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T3)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T4):, PORT=$(PORT)_TS1,ADDR=3, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T4)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T5):, PORT=$(PORT)_TS1,ADDR=4, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T5)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T6):, PORT=$(PORT)_TS1,ADDR=5, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T6)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T7):, PORT=$(PORT)_TS1,ADDR=6, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T7)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T8):, PORT=$(PORT)_TS1,ADDR=7, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T8)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T9):, PORT=$(PORT)_TS1,ADDR=8 ,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T9)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T10):,PORT=$(PORT)_TS1,ADDR=9, TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T10)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T11):,PORT=$(PORT)_TS1,ADDR=10,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T11)")
#
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T12):,PORT=$(PORT)_TS1,ADDR=11,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T12)")
dbLoadRecords("$(ADCORE)/db/NDTimeSeriesN.template", "P=$(SYS),R={$(DEV)}TS:$(T13):,PORT=$(PORT)_TS1,ADDR=12,TIMEOUT=1,NCHANS=$(TSPOINTS),NAME=$(T13)")



# FFT plugins
NDFFTConfigure("$(PORT)_FFT1", $(QSIZE), 0, "$(PORT)_TS1", 0)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T1):, PORT=$(PORT)_FFT1, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=0, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T1)")
NDFFTConfigure("$(PORT)_FFT2", $(QSIZE), 0, "$(PORT)_TS1", 1)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T2):, PORT=$(PORT)_FFT2, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=1, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T2)")
NDFFTConfigure("$(PORT)_FFT3", $(QSIZE), 0, "$(PORT)_TS1", 2
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T3):, PORT=$(PORT)_FFT3, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=2, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T3)")
NDFFTConfigure("$(PORT)_FFT4", $(QSIZE), 0, "$(PORT)_TS1", 3)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T4):, PORT=$(PORT)_FFT4, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=3, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T4)")
NDFFTConfigure("$(PORT)_FFT5", $(QSIZE), 0, "$(PORT)_TS1", 4)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T5):, PORT=$(PORT)_FFT5, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=4, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T5)")
NDFFTConfigure("$(PORT)_FFT6", $(QSIZE), 0, "$(PORT)_TS1", 5)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T6):, PORT=$(PORT)_FFT6, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=5, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T6)")
NDFFTConfigure("$(PORT)_FFT7", $(QSIZE), 0, "$(PORT)_TS1", 6)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T7):, PORT=$(PORT)_FFT7, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=6, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T7)")
NDFFTConfigure("$(PORT)_FFT8", $(QSIZE), 0, "$(PORT)_TS1", 7)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T8):, PORT=$(PORT)_FFT8, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=7, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T8)")
NDFFTConfigure("$(PORT)_FFT9", $(QSIZE), 0, "$(PORT)_TS1", 8)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T9):, PORT=$(PORT)_FFT9, ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=8, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T9)")
NDFFTConfigure("$(PORT)_FFT10", $(QSIZE), 0, "$(PORT)_TS1", 9)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T10):,PORT=$(PORT)_FFT10,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=9, NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T10)")
NDFFTConfigure("$(PORT)_FFT11", $(QSIZE), 0, "$(PORT)_TS1", 10)
dbLoadRecords("$(ADCORE)/db/NDFFT.template","P=$(SYS),R={$(DEV)}FFT:$(T11):,PORT=$(PORT)_FFT11,ADDR=0,TIMEOUT=1,NDARRAY_PORT=$(PORT)_TS1,NDARRAY_ADDR=10,NCHANS=$(TSPOINTS),TIME_LINK=$(SYS){$(DEV)}TS:TSAveragingTime_RBV CP MS,ENABLED=1,NAME=$(T11)")

