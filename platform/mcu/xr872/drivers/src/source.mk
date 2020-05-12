include $(SOURCE_ROOT)/platform/mcu/xr872/config.mk

include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/audio/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/console/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/driver/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/efpg/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/image/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/net/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/ota/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/pm/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/sys/source.mk
#include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/libc/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/kernel/os/FreeRTOS/source.mk

ifeq ($(__CONFIG_ROM), y)
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/rom/source.mk
endif
