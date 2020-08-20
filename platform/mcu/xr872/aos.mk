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

GLOBAL_INCLUDES += drivers/project/common/board/xr872_evb_ai

#make helloworld and kernel can compile, to check
GLOBAL_INCLUDES += ../../../middleware/uagent/ota/hal

$(NAME)_INCLUDES += os_api/inc
GLOBAL_INCLUDES +=	os_api/freertos_aos
GLOBAL_INCLUDES +=	os_api/include

ifeq ($(__CONFIG_XPLAYER), y)
GLOBAL_INCLUDES += drivers/include/cedarx
GLOBAL_INCLUDES += drivers/include/cedarx/libcore/record/include
GLOBAL_INCLUDES += drivers/include/cedarx/libcore/base/include
GLOBAL_INCLUDES += drivers/include/cedarx/libcore/playback/include
GLOBAL_INCLUDES += drivers/include/cedarx/Cdx2.0Plugin/include
GLOBAL_INCLUDES += drivers/include/cedarx/xrecoder/include
GLOBAL_INCLUDES += drivers/include/cedarx/os_glue
GLOBAL_INCLUDES += drivers/include/cedarx/os_glue/include
endif

include $(SOURCE_ROOT)/platform/mcu/xr872/os_api/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/hal/source.mk

# drivers project files
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/project/source.mk

# drivers src files
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/audio/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/console/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/driver/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/efpg/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/image/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/net/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/ota/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/pm/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/sys/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/libc/source.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/kernel/os/FreeRTOS/source.mk
ifeq ($(__CONFIG_ROM), y)
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/src/rom/source.mk
endif

$(NAME)_PREBUILT_LIBRARY := drivers/lib/libxz/libxz.a

ifeq ($(__CONFIG_XPLAYER), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/cedarx/libaac.a
$(NAME)_PREBUILT_LIBRARY += drivers/lib/cedarx/libamr.a
$(NAME)_PREBUILT_LIBRARY += drivers/lib/cedarx/libamren.a
$(NAME)_PREBUILT_LIBRARY += drivers/lib/cedarx/libmp3.a
$(NAME)_PREBUILT_LIBRARY += drivers/lib/cedarx/libwav.a
$(NAME)_PREBUILT_LIBRARY += drivers/lib/cedarx/libcedarx.a
$(NAME)_PREBUILT_LIBRARY += drivers/lib/libreverb.a
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBSC_ASSISTANT), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/wlan/libsc_assistant.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBWPA), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/wlan/libwpa.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBWPAS), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/wlan/libwpas.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBWLAN), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/wlan/libwlan.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBXRWIRELESS), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/wlan/libxrwireless.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBNET80211), y)
$(NAME)_PREBUILT_LIBRARY += drivers/lib/wlan/libnet80211.a
else
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/config.mk
include $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/source.mk
endif							

$(NAME)_SOURCES += $(XR_SOURCE_FILES)

$(NAME)_CFLAGS += -include platform/mcu/xr872/drivers/project/common/prj_conf_opt.h
$(NAME)_CFLAGS += -include platform/mcu/xr872/drivers/project/main/prj_config.h

#GLOBAL_CFLAGS  += -D__CONFIG_OS_USE_YUNOS
GLOBAL_CFLAGS  += -D__CONFIG_OS_FREERTOS_TO_AOS
GLOBAL_CFLAGS  += -D__CONFIG_CPU_CM4F
GLOBAL_CFLAGS  += -D__CONFIG_ARCH_APP_CORE
GLOBAL_CFLAGS  += -D__CONFIG_LIBC_REDEFINE_GCC_INT32_TYPE
GLOBAL_DEFINES  += __CONFIG_MBUF_IMPL_MODE=0
GLOBAL_CFLAGS  += -D__CONFIG_WLAN
GLOBAL_CFLAGS  += -D__CONFIG_WLAN_STA
GLOBAL_CFLAGS  += -D__CONFIG_WLAN_MONITOR
GLOBAL_CFLAGS  += -D__CONFIG_PM

GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_XIP
GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_NONXIP
GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_SRAM

ifeq ($(__CONFIG_PSRAM), y)
GLOBAL_CFLAGS  += -D__CONFIG_PSRAM
GLOBAL_CFLAGS  += -D__CONFIG_PSRAM_CHIP_OPI32
GLOBAL_CFLAGS  += -D__CONFIG_SECTION_ATTRIBUTE_PSRAM
GLOBAL_CFLAGS  += -D__CONFIG_PSRAM_ALL_CACHEABLE
GLOBAL_DEFINES  += __CONFIG_DMAHEAP_PSRAM_SIZE=256
GLOBAL_DEFINES  += __CONFIG_CACHE_POLICY=0x41
else
GLOBAL_DEFINES  += __CONFIG_DMAHEAP_PSRAM_SIZE=0
GLOBAL_DEFINES  += __CONFIG_CACHE_POLICY=0x02
endif

ifeq ($(__CONFIG_PSRAM), y)
GLOBAL_DEFINES  += __CONFIG_MBUF_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_MBEDTLS_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_HTTPC_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_MQTT_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_NOPOLL_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_WPA_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_UMAC_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_LMAC_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_CEDARX_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_AUDIO_HEAP_MODE=1
GLOBAL_DEFINES  += __CONFIG_CODEC_HEAP_MODE=1
else
GLOBAL_DEFINES  += __CONFIG_MBUF_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_MBEDTLS_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_HTTPC_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_MQTT_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_NOPOLL_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_WPA_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_UMAC_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_LMAC_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_CEDARX_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_AUDIO_HEAP_MODE=0
GLOBAL_DEFINES  += __CONFIG_CODEC_HEAP_MODE=0
endif

ifeq ($(__CONFIG_ROM), y)
GLOBAL_CFLAGS  += -D__CONFIG_ROM
endif
ifeq ($(__CONFIG_XIP), y)
GLOBAL_CFLAGS  += -D__CONFIG_XIP
endif

ifeq ($(__CONFIG_OTA), y)
GLOBAL_CFLAGS   += -D__CONFIG_OTA
GLOBAL_DEFINES  += __CONFIG_OTA_POLICY=0
endif

ifeq ($(__CONFIG_XPLAYER), y)
GLOBAL_CFLAGS   += -D__CONFIG_XPLAYER
endif

GLOBAL_CFLAGS  += -D__CONFIG_CHIP_XR872

GLOBAL_DEFINES += __CONFIG_CHIP_ARCH_VER=2
GLOBAL_DEFINES += __CONFIG_HOSC_TYPE=40
GLOBAL_DEFINES += __CONFIG_CACHE_POLICY=0x02
GLOBAL_DEFINES += __CONFIG_SYSTEM_HEAP_MODE=0x01

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
GLOBAL_LDFLAGS += -Wl,--wrap,memcpy
GLOBAL_LDFLAGS += -Wl,--wrap,memset
GLOBAL_LDFLAGS += -Wl,--wrap,memmove
GLOBAL_LDFLAGS += -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys

ifeq ($(__CONFIG_ROM), y)
GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/lib/xradio_v2/rom_symbol_port.ld
endif
ifeq ($(__CONFIG_XIP), y)
    ifeq ($(__CONFIG_PSRAM), y)
    GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/project/linker_script/gcc/appos_xip_psram.ld
    else
    GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/project/linker_script/gcc/appos_xip.ld
    endif
else
    ifeq ($(__CONFIG_PSRAM), y)
    GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/project/linker_script/gcc/appos_psram.ld
    else
    GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/mcu/xr872/drivers/project/linker_script/gcc/appos.ld
    endif
endif

EXTRA_TARGET_MAKEFILES +=  $(SOURCE_ROOT)/platform/mcu/$(HOST_MCU_NAME)/mkimage.mk