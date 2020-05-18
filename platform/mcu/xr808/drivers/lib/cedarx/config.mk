
BUILD_CEDARX := n

ifeq ($(__CONFIG_USE_PREBUILT_LIBMP3), y)
BUILD_MP3 := n
else
BUILD_MP3 := y
endif

ifeq ($(__CONFIG_USE_PREBUILT_LIBMP3INF), y)
BUILD_MP3INF := n
else
BUILD_MP3INF := y
endif

ifeq ($(BUILD_MP3), y)
GLOBAL_INCLUDES += ../../../lib/cedarx/src/audio/codec/mp3/include
GLOBAL_INCLUDES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3
endif

ifeq ($(BUILD_MP3INF), y)
GLOBAL_INCLUDES += drivers/include/cedarx/Cdx2.0Plugin/include
GLOBAL_INCLUDES += drivers/include/cedarx/libcore/base/include
GLOBAL_INCLUDES += ../../../lib/cedarx/src/cedarx/Cdx2.0Plugin/include
GLOBAL_INCLUDES += ../../../lib/cedarx/src/cedarx/libcore/base/include
endif

ifeq ($(BUILD_MP3), y)
GLOBAL_CFLAGS   += -D__OS_LINUX -DENABLE_MPEG_LAYER_I_II
GLOBAL_CFLAGS   += -fPIC -DARM_ADS
GLOBAL_CFLAGS   += -DPLATFORM_VERIFY
endif

ifeq ($(BUILD_CEDARX), y)
GLOBAL_CFLAGS   += -DM4A_SUPPORT
GLOBAL_CFLAGS   += -DM3U_SUPPORT
GLOBAL_CFLAGS   += -DAAC_SUPPORT
GLOBAL_CFLAGS   += -DFIFOSTREAM_SUPPORT
GLOBAL_CFLAGS   += -DHTTPS_SUPPORT
GLOBAL_CFLAGS   += -DPLATFORM_VERIFY
endif
