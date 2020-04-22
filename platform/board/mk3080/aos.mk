NAME := board_mk3080

JTAG := jlink_swd

$(NAME)_MBINS_TYPE := kernel
$(NAME)_VERSION    := 1.0.2
$(NAME)_SUMMARY    := configuration for board mk3080
MODULE             := AmebaZ
HOST_ARCH          := Cortex-M4
HOST_MCU_FAMILY    := mcu_rtl8710bn
SUPPORT_MBINS      := no
AOS_SDK_2NDBOOT_SUPPORT := yes

ifeq ($(AOS_2NDBOOT_SUPPORT), yes)
$(NAME)_LIBSUFFIX := _2ndboot
GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/board/mk3080/ld/rlx8711B-symbol-v02-img2-2ndboot.ld
else
$(NAME)_COMPONENTS += $(HOST_MCU_FAMILY) kernel_init network
GLOBAL_LDFLAGS += -T $(SOURCE_ROOT)/platform/board/mk3080/ld/rlx8711B-symbol-v02-img2_xip1.ld
$(NAME)_SOURCES := startup/board.c
$(NAME)_SOURCES += config/k_config.c \
                    startup/startup.c
endif

$(NAME)_SOURCES += config/partition_conf.c

GLOBAL_INCLUDES += ./config \

GLOBAL_DEFINES  += STDIO_UART=0 USE_MX1290
GLOBAL_DEFINES += CLI_CONFIG_STACK_SIZE=4096

# Link Security Config
CONFIG_LS_DEBUG      := n
CONFIG_LS_ID2_OTP    := y
CONFIG_LS_KM_SE      := n
CONFIG_LS_KM_TEE     := n

CONFIG_SYSINFO_PRODUCT_MODEL := ALI_AOS_MK3080
CONFIG_SYSINFO_DEVICE_NAME   := MK3080

GLOBAL_CFLAGS += -DSYSINFO_PRODUCT_MODEL=\"$(CONFIG_SYSINFO_PRODUCT_MODEL)\"
GLOBAL_CFLAGS += -DSYSINFO_DEVICE_NAME=\"$(CONFIG_SYSINFO_DEVICE_NAME)\"

GLOBAL_CFLAGS += -L $($(NAME)_LOCATION)

# Extra build target include bootloader, and copy output file to eclipse debug file (copy_output_for_eclipse)
EXTRA_TARGET_MAKEFILES +=  $($(HOST_MCU_FAMILY)_LOCATION)/download.mk

