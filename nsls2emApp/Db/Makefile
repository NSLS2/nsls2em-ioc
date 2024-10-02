TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS BELOW HERE

# Install databases, templates & substitutions like this
DB += nsls2emVersion.db
DB += quadEM.template
DB += TetrAMM.template
#
DB += nsls2em_RevD.template
DB += quadEM_nsls2em.template

### Pscdrv
DB += nsls2em_pscdrv.template
DB += Connection.db
DB += ADCWaveform.db
DB += Misc.db
DB += DAC_Setpoint.db
DB += CommandReg.template CommandReg.substitutions
DB += StatusDoubleReg.template StatusDoubleReg.substitutions
DB += StatusFloatReg.template StatusFloatReg.substitutions
DB += StatusReg.template StatusReg.substitutions
DB += RangeGainOffset.template RangeGainOffset.substitutions

# If <anyname>.db template is not named <anyname>*.template add
# <anyname>_TEMPLATE = <templatename>

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD EXTRA GNUMAKE RULES BELOW HERE

