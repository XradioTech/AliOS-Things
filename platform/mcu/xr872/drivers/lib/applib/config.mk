
ifeq ($(__CONFIG_USE_PREBUILT_LIBREVERB), y)
BUILD_REVERB := n
else
BUILD_REVERB := y
endif

ifeq ($(BUILD_REVERB), y)
GLOBAL_INCLUDES += drivers/include/audio/reverb \
                   ../../../lib/applib/src/audio/reverb/include
endif

ifeq ($(BUILD_REVERB), y)
GLOBAL_CFLAGS += -DREVERB_PLATFORM_VERIFY
endif
