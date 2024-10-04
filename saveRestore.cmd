#
set_requestfile_path("./")
set_requestfile_path("$(QUADEM)/quadEMApp/Db")
set_requestfile_path("$(ADCORE)/ADApp/Db")
set_requestfile_path("$(CALC)/calcApp/Db")
set_requestfile_path("$(SSCAN)/sscanApp/Db")
#set_savefile_path("./autosave") #already assigned from st.cmd
set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")
save_restoreSet_status_prefix("$(PREFIX)")
dbLoadRecords("$(AUTOSAVE)/asApp/Db/save_restoreStatus.db", "P=$(PREFIX)")
