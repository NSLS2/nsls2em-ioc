#
# Load additional records standard for each IOC
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db", "IOC=$(PREFIX)")
dbLoadRecords("$(AUTOSAVE)/db/save_restoreStatus.db", "P=$(PREFIX)")

save_restoreSet_Debug(0)
save_restoreSet_IncompleteSetsOk(1)
save_restoreSet_DatedBackupFiles(1)

set_savefile_path("$(TOP)/as","/save/")
set_requestfile_path("./")
set_requestfile_path("$(TOP)/as","/req/")
set_requestfile_path("$(QUADEM)/quadEMApp/Db")
set_requestfile_path("$(ADCORE)/ADApp/Db")
set_requestfile_path("$(CALC)/calcApp/Db")
set_requestfile_path("$(SSCAN)/sscanApp/Db")

set_pass0_restoreFile("info_positions.sav")
set_pass0_restoreFile("info_settings.sav")
set_pass1_restoreFile("info_settings.sav")

#save_restoreSet_status_prefix("$(PREFIX)}")
