
# drivers/src/driver/chip
XR872_CHIP_PATH  := drivers/src/driver/chip
XR872_CHIP_FILES := \
                   $(XR872_CHIP_PATH)/flashchip/flash_chip.c     \
                   $(XR872_CHIP_PATH)/flashchip/flash_chip_cfg.c  \
                   $(XR872_CHIP_PATH)/hal_icache.c \
                   $(XR872_CHIP_PATH)/hal_dcache.c  \
                   $(XR872_CHIP_PATH)/hal_adc.c                  \
                   $(XR872_CHIP_PATH)/hal_board.c                \
                   $(XR872_CHIP_PATH)/hal_ccm.c                  \
                   $(XR872_CHIP_PATH)/hal_crypto.c               \
                   $(XR872_CHIP_PATH)/hal_dma.c                  \
                   $(XR872_CHIP_PATH)/hal_dmic.c                 \
                   $(XR872_CHIP_PATH)/hal_efuse.c                \
                   $(XR872_CHIP_PATH)/hal_flash.c                \
                   $(XR872_CHIP_PATH)/hal_flashctrl.c            \
                   $(XR872_CHIP_PATH)/hal_global.c               \
                   $(XR872_CHIP_PATH)/hal_gpio.c                 \
                   $(XR872_CHIP_PATH)/hal_i2c.c                  \
                   $(XR872_CHIP_PATH)/hal_i2s.c                  \
                   $(XR872_CHIP_PATH)/hal_irrx.c                 \
                   $(XR872_CHIP_PATH)/hal_irtx.c                 \
                   $(XR872_CHIP_PATH)/hal_nvic.c                 \
                   $(XR872_CHIP_PATH)/hal_prcm.c                 \
                   $(XR872_CHIP_PATH)/hal_pwm.c                  \
                   $(XR872_CHIP_PATH)/hal_rtc.c                  \
                   $(XR872_CHIP_PATH)/hal_spi.c                  \
                   $(XR872_CHIP_PATH)/hal_spinlock.c             \
                   $(XR872_CHIP_PATH)/hal_timer.c                \
                   $(XR872_CHIP_PATH)/hal_uart.c                 \
                   $(XR872_CHIP_PATH)/hal_util.c                 \
                   $(XR872_CHIP_PATH)/hal_wakeup.c               \
                   $(XR872_CHIP_PATH)/hal_wdg.c                  \
                   $(XR872_CHIP_PATH)/hal_xip.c                  \
                   $(XR872_CHIP_PATH)/hal_swd.c                  \
                   $(XR872_CHIP_PATH)/sdmmc/core.c               \
                   $(XR872_CHIP_PATH)/sdmmc/hal_sdhost.c         \
                   $(XR872_CHIP_PATH)/sdmmc/sd.c                 \
                   $(XR872_CHIP_PATH)/sdmmc/mmc.c               \
                   $(XR872_CHIP_PATH)/sdmmc/quirks.c         \
                   $(XR872_CHIP_PATH)/sdmmc/sdio.c         \
                   $(XR872_CHIP_PATH)/system_chip.c

# drivers/src/image
XR872_IMAGE_PATH  := drivers/src/image
XR872_IMAGE_FILES := $(XR872_IMAGE_PATH)/fdcm.c \
                     $(XR872_IMAGE_PATH)/flash.c \
                     $(XR872_IMAGE_PATH)/image.c


# drivers/src/net/ethernetif
XR872_ETHERNETIF_PATH  := drivers/src/net/ethernetif
XR872_ETHERNETIF_FILES := $(XR872_ETHERNETIF_PATH)/ethernetif.c

# drivers/src/ota
XR872_OTA_PATH  := drivers/src/ota
XR872_OTA_FILES := $(XR872_OTA_PATH)/ota.c \
                   $(XR872_OTA_PATH)/ota_file.c

# drivers/src/pm 
XR872_PM_PATH  := drivers/src/pm
XR872_PM_FILES := $(XR872_PM_PATH)/pm.c \
                  $(XR872_PM_PATH)/port.c \
                  $(XR872_PM_PATH)/cpu.s

# drivers/src/efpg
XR872_EFPG_PATH  := drivers/src/efpg
XR872_EFPG_FILES := $(XR872_EFPG_PATH)/efpg_efuse.c \
                    $(XR872_EFPG_PATH)/efpg.c

# drivers/src/sys
XR872_SYS_PATH  := drivers/src/sys
XR872_SYS_FILES :=  $(XR872_SYS_PATH)/mbuf/mbuf_0.c \
		$(XR872_SYS_PATH)/mbuf/mbuf_0_mem.c

# drivers/src/net/lwip
XR872_LWIP_PATH  := drivers/src/net/lwip
XR872_LWIP_FILES := $(XR872_LWIP_PATH)/memcpy.c \
                    $(XR872_LWIP_PATH)/checksum.c

# drivers/src/console
XR872_CONSOLE_PATH  := drivers/src/console
XR872_CONSOLE_FILES := $(XR872_CONSOLE_PATH)/console.c

# drivers/src/project
XR872_PROJECT_PATH  := drivers/project
XR872_PROJECT_FILES := $(XR872_PROJECT_PATH)/common/framework/sys_ctrl/container.c \
                       $(XR872_PROJECT_PATH)/common/framework/sys_ctrl/event_queue.c \
                       $(XR872_PROJECT_PATH)/common/framework/sys_ctrl/observer.c \
                       $(XR872_PROJECT_PATH)/common/framework/sys_ctrl/publisher.c \
                       $(XR872_PROJECT_PATH)/common/framework/sys_ctrl/sys_ctrl.c \
                       $(XR872_PROJECT_PATH)/common/framework/sys_ctrl/looper.c \
                       $(XR872_PROJECT_PATH)/common/framework/net_ctrl.c \
                       $(XR872_PROJECT_PATH)/common/framework/net_sys.c \
                       $(XR872_PROJECT_PATH)/common/framework/sc_assistant_port.c \
                       $(XR872_PROJECT_PATH)/common/framework/platform_init.c \
                       $(XR872_PROJECT_PATH)/common/framework/sysinfo.c \
                       $(XR872_PROJECT_PATH)/common/cmd/cmd_util.c \
                       $(XR872_PROJECT_PATH)/common/cmd/cmd_upgrade.c \
                       $(XR872_PROJECT_PATH)/common/cmd/cmd_mem.c \
                       $(XR872_PROJECT_PATH)/common/board/board.c \
                       $(XR872_PROJECT_PATH)/common/board/board_common.c \
                       $(XR872_PROJECT_PATH)/common/board/xradio_evb/board_config.c \
                       $(XR872_PROJECT_PATH)/common/startup/gcc/exception.c \
                       $(XR872_PROJECT_PATH)/common/startup/gcc/retarget.c \
                       $(XR872_PROJECT_PATH)/common/startup/gcc/retarget_stdout.c

# drivers/src/audio
XR872_AUDIO_PATH  := drivers/src/audio
XR872_AUDIO_FILES := $(XR872_AUDIO_PATH)/manager/audio_manager.c \
                     $(XR872_AUDIO_PATH)/pcm/audio_pcm.c

# drivers/src/rom
XR872_ROM_PATH  := drivers/src/rom
XR872_ROM_FILES := $(XR872_ROM_PATH)/rom_core.c

#OS API
XR872_FREERTOSAPI_PATH := drivers/src/kernel/os/FreeRTOS
XR872_FREERTOSAPI_FILES := $(XR872_FREERTOSAPI_PATH)/os_debug.c \
							$(XR872_FREERTOSAPI_PATH)/os_mutex.c \
							$(XR872_FREERTOSAPI_PATH)/os_queue.c \
							$(XR872_FREERTOSAPI_PATH)/os_semaphore.c \
							$(XR872_FREERTOSAPI_PATH)/os_thread.c \
							$(XR872_FREERTOSAPI_PATH)/os_timer.c
