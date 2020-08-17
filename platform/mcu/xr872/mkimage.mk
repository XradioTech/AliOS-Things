include $(SOURCE_ROOT)/platform/mcu/xr872/config.mk

ifeq ($(HOST_OS),Win32)
MKIMAGE_TOOL := "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/tools/mkimage.exe"
else  # Win32
ifeq ($(HOST_OS),Linux32)
MKIMAGE_TOOL := "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/tools/mkimage"
XZ_TOOL := "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/tools/xz"
else # Linux32
ifeq ($(HOST_OS),Linux64)
MKIMAGE_TOOL := "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/tools/mkimage"
XZ_TOOL := "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/tools/xz64"
else # Linux64
$(error not surport for $(HOST_OS))
endif # Linux64
endif # Linux32
endif # Win32

EXTRA_POST_BUILD_TARGETS += mkimage

ifeq ($(__CONFIG_XIP),y)
IMAGE_XIP := -xip
else
IMAGE_XIP :=
endif

ifeq ($(__CONFIG_XIP), y)
  OBJCOPY_R_XIP := -R .xip
  OBJCOPY_J_XIP := -j .xip
else
  OBJCOPY_R_XIP :=
  OBJCOPY_J_XIP :=
endif

ifeq ($(__CONFIG_PSRAM), y)
  OBJCOPY_R_PSRAM := -R .psram_text -R .psram_data -R .psram_bss
  OBJCOPY_J_PSRAM := -j .psram_text -j .psram_data
else
  OBJCOPY_R_PSRAM :=
  OBJCOPY_J_PSRAM :=
endif

ifeq ($(__CONFIG_OTA),y)
IMAGE_OTA := -O
else
afaf
IMAGE_OTA :=
endif

BOOT_DIR ?= "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/bin/xradio_v2/boot/xr872"

ifeq ($(__CONFIG_XIP), y)
    ifeq ($(__CONFIG_PSRAM), y)
    CFG_FILE_NAME ?= image_xip_psram.cfg
    else
    CFG_FILE_NAME ?= image_xip.cfg
    endif
else
    ifeq ($(__CONFIG_PSRAM), y)
    CFG_FILE_NAME ?= image_psram.cfg
    else
    CFG_FILE_NAME ?= image.cfg
    endif
endif

IMAGE_CFG_FILE ?= "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/project/image_cfg/$(CFG_FILE_NAME)"
IMAGE_PACK_DIR ?= "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/pack"
BINARY_DIR ?= $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary

mkimage:
	@mkdir -p $(IMAGE_PACK_DIR)
	$(OBJCOPY) -O binary $(OBJCOPY_R_XIP) $(OBJCOPY_R_PSRAM) -R .eh_frame -R .init -R .fini -R .comment -R .ARM.attributes $(BINARY_DIR)/$(CLEANED_BUILD_STRING).elf $(BINARY_DIR)/$(CLEANED_BUILD_STRING).bin
ifeq ($(__CONFIG_XIP), y)
	$(OBJCOPY) -O binary $(OBJCOPY_J_XIP) $(BINARY_DIR)/$(CLEANED_BUILD_STRING).elf $(BINARY_DIR)/$(CLEANED_BUILD_STRING).xip.bin
endif
ifeq ($(__CONFIG_PSRAM), y)
	$(OBJCOPY) -O binary $(OBJCOPY_J_PSRAM) $(BINARY_DIR)/$(CLEANED_BUILD_STRING).elf $(BINARY_DIR)/$(CLEANED_BUILD_STRING).psram.bin
endif
	$(CP) -vf $(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/bin/xradio_v2/*.bin  $(IMAGE_PACK_DIR)/
	$(CP) -vf $(BOOT_DIR)/*.bin  $(IMAGE_PACK_DIR)/
	$(CP) -vf $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary/$(CLEANED_BUILD_STRING).bin  $(IMAGE_PACK_DIR)/app.bin
ifeq ($(__CONFIG_XIP), y)
	$(CP) -vf $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary/$(CLEANED_BUILD_STRING).xip.bin  $(IMAGE_PACK_DIR)/app_xip.bin
endif
ifeq ($(__CONFIG_PSRAM), y)
	$(CP) -vf $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary/$(CLEANED_BUILD_STRING).psram.bin  $(IMAGE_PACK_DIR)/app_psram.bin
endif
	$(CP) -vf $(MKIMAGE_TOOL)  $(IMAGE_PACK_DIR)/mkimage
	$(CP) -vf $(IMAGE_CFG_FILE)  $(IMAGE_PACK_DIR)/
	cd $(IMAGE_PACK_DIR) && ./mkimage ${IMAGE_OTA} -c $(CFG_FILE_NAME)
	dd if=$(IMAGE_PACK_DIR)/xr_system.img of=$(IMAGE_PACK_DIR)/ota.bin skip=32768 bs=1c
	$(PYTHON) "$(SCRIPTS_PATH)/ota_gen_md5_bin.py" $(IMAGE_PACK_DIR)/ota.bin -m $(IMAGE_MAGIC)

