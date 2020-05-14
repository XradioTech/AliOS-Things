NAME := mcu_xr872
HOST_OPENOCD := xr872

$(NAME)_MBINS_TYPE := kernel
$(NAME)_VERSION    := 1.0.2
$(NAME)_SUMMARY    := driver & sdk for platform/mcu xr872

$(NAME)_COMPONENTS += arch_armv7m rhino

include $(SOURCE_ROOT)/platform/mcu/xr872/config.mk

$(NAME)_INCLUDES += ./drivers

GLOBAL_INCLUDES += drivers/include \
                   drivers/include/net/lwip \
                   drivers/include/driver/cmsis \
                   drivers/include/sys \
                   drivers/project \
                   drivers/project/main \
                   drivers/project/common/framework

#ifeq ($(AOS_BOARD_XR872), 1)
GLOBAL_INCLUDES += drivers/project/common/board/xr872_evb_ai
#endif

#make helloworld and kernel can compile, to check
GLOBAL_INCLUDES += ../../../middleware/uagent/ota/hal

$(NAME)_INCLUDES += os_api/inc
GLOBAL_INCLUDES +=	os_api/freertos_aos
GLOBAL_INCLUDES +=	os_api/include

include $(SOURCE_ROOT)/platform/mcu/xr872/os_api/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/hal/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/source.mk

$(NAME)_PREBUILT_LIBRARY := drivers/lib/libxz/libxz.a

ifeq ($(__CONFIG_USE_PREBUILT_LIBSC_ASSISTANT), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libsc_assistant.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBWPA), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libwpa.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBWPAS), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libwpas.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBWLAN), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libwlan.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBXRWIRELESS), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libxrwireless.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBNET80211), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libnet80211.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif							

$(NAME)_SOURCES += $(XR872_SOURCE_FILES)

$(NAME)_CFLAGS += -include platform/mcu/xr872/drivers/project/common/prj_conf_opt.h
$(NAME)_CFLAGS += -include platform/mcu/xr872/drivers/project/main/prj_config.h

#GLOBAL_CFLAGS  += -D__CONFIG_OS_USE_YUNOS
GLOBAL_CFLAGS   += -D__CONFIG_OS_FREERTOS_TO_AOS
GLOBAL_CFLAGS  += -D__CONFIG_CPU_CM4F
GLOBAL_CFLAGS  += -D__CONFIG_ARCH_APP_CORE
GLOBAL_CFLAGS  += -D__CONFIG_LIBC_REDEFINE_GCC_INT32_TYPE
GLOBAL_CFLAGS  += -D__CONFIG_MBUF_IMPL_MODE=0
GLOBAL_CFLAGS  += -D__CONFIG_WLAN
GLOBAL_CFLAGS  += -D__CONFIG_WLAN_STA
GLOBAL_CFLAGS  += -D__CONFIG_WLAN_MONITOR
GLOBAL_CFLAGS  += -D__CONFIG_PM

GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_XIP
GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_NONXIP
GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_SRAM

ifeq ($(__CONFIG_ROM), y)
GLOBAL_CFLAGS  += -D__CONFIG_ROM
endif
ifeq ($(__CONFIG_XIP), y)
GLOBAL_CFLAGS  += -D__CONFIG_XIP
endif

#ifeq ($(AOS_BOARD_XR872), 1)
GLOBAL_CFLAGS  += -D__CONFIG_CHIP_XR872
#endif

GLOBAL_DEFINES += __CONFIG_CHIP_ARCH_VER=2
GLOBAL_DEFINES += __CONFIG_HOSC_TYPE=40
GLOBAL_DEFINES += __CONFIG_CACHE_POLICY=0x02
GLOBAL_DEFINES  += __CONFIG_SYSTEM_HEAP_MODE=0x01

GLOBAL_CFLAGS += -mcpu=cortex-m4     \
                 -mthumb             \
                 -mfpu=fpv4-sp-d16  \
                 -mfloat-abi=softfp \
                 -w \
                 -fno-common \
                 -fmessage-length=0 \
                 -fno-exceptions \
                 -ffunction-sections \
                 -fdata-sections \
                 -fomit-frame-pointer \
                 -Wall \
                 -Werror \
                 -Wno-error=unused-function \
                 -MMD -MP \
                 -Os -DNDEBUG

#.S,.s file need
ifeq ($(__CONFIG_ROM), y)
GLOBAL_ASMFLAGS += -D__CONFIG_ROM
endif
GLOBAL_ASMFLAGS += -D__CONFIG_CPU_CM4F
GLOBAL_ASMFLAGS += -c -x assembler-with-cpp

GLOBAL_LDFLAGS += -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=softfp
GLOBAL_LDFLAGS += -Wl,--gc-sections --specs=nano.specs -u _printf_float
#GLOBAL_LDFLAGS += -Wl,--wrap,main
GLOBAL_LDFLAGS += -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys

#ifeq ($(AOS_BOARD_XR872), 1)
ifeq ($(__CONFIG_ROM), y)
GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/xradio_v2/rom_symbol_xr872.ld
endif
GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/project/linker_script/gcc/project-xip-rom-xr872.ld
#endif

EXTRA_TARGET_MAKEFILES +=  $(SOURCE_ROOT)/platform/mcu/$(HOST_MCU_NAME)/mkimage.mk