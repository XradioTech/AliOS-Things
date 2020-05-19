include $(SOURCE_ROOT)/platform/mcu/xr808/config.mk

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

ifeq ($(__CONFIG_OTA),y)
IMAGE_OTA := -O
else
afaf
IMAGE_OTA :=
endif

BOOT_DIR ?= "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/bin/xradio_v2/boot/xr808"

IMAGE_CFG_FILE ?= "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/project/image_cfg/image-${APP}.cfg"
IMAGE_PACK_DIR ?= "$(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/pack"
BINARY_DIR ?= $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary

mkimage:
	@mkdir -p $(IMAGE_PACK_DIR)
	$(OBJCOPY) -O binary -R .xip -R .eh_frame -R .init -R .fini -R .comment -R .ARM.attributes $(BINARY_DIR)/$(CLEANED_BUILD_STRING).elf $(BINARY_DIR)/$(CLEANED_BUILD_STRING).bin
	$(OBJCOPY) -O binary -j .xip $(BINARY_DIR)/$(CLEANED_BUILD_STRING).elf $(BINARY_DIR)/$(CLEANED_BUILD_STRING).xip.bin
	$(CP) -vf $(SOURCE_ROOT)/$($(HOST_MCU_FAMILY)_LOCATION)/drivers/bin/xradio_v2/*.bin  $(IMAGE_PACK_DIR)/
	$(CP) -vf $(BOOT_DIR)/*.bin  $(IMAGE_PACK_DIR)/
	$(CP) -vf $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary/$(CLEANED_BUILD_STRING).bin  $(IMAGE_PACK_DIR)/app.bin
	$(CP) -vf $(SOURCE_ROOT)out/$(CLEANED_BUILD_STRING)/binary/$(CLEANED_BUILD_STRING).xip.bin  $(IMAGE_PACK_DIR)/app-xip.bin
	$(CP) -vf $(MKIMAGE_TOOL)  $(IMAGE_PACK_DIR)/mkimage
	$(CP) -vf $(IMAGE_CFG_FILE)  $(IMAGE_PACK_DIR)/
	cd $(IMAGE_PACK_DIR) && ./mkimage ${IMAGE_OTA} -c image-${APP}.cfg
	dd if=$(IMAGE_PACK_DIR)/xr_system.img of=$(IMAGE_PACK_DIR)/ota.bin skip=32768 bs=1c
	$(PYTHON) "$(SCRIPTS_PATH)/ota_gen_md5_bin.py" $(IMAGE_PACK_DIR)/ota.bin -m $(IMAGE_MAGIC)

