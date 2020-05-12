XR872_SOURCE_FILES += hal/wifi_port.c \
		      hal/wifi.c \
                      hal/hal.c

ifeq ($(__CONFIG_OTA), y)
XR872_SOURCE_FILES += hal/ota_port.c
endif

XR872_SOURCE_FILES += hal/soc/flash.c \
                      hal/soc/sd.c \
                      hal/soc/uart.c \
                      hal/soc/wdg.c

