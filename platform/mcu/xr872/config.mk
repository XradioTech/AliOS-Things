#ota, xip, rom, psram function config
__CONFIG_XIP ?= y
__CONFIG_OTA ?= y
__CONFIG_PSRAM ?= n
__CONFIG_ROM ?= y

#lib net file compile: y mean not compile, use exist file.a
#                      n mean comipile.
__CONFIG_USE_PREBUILT_LIBSC_ASSISTANT := y
__CONFIG_USE_PREBUILT_LIBWPA := y
__CONFIG_USE_PREBUILT_LIBWPAS := y
__CONFIG_USE_PREBUILT_LIBWLAN := y
__CONFIG_USE_PREBUILT_LIBXRWIRELESS := y
__CONFIG_USE_PREBUILT_LIBNET80211 := y





