LIB_SRC_PATH = ../../../..
ifeq ($(BUILD_SC_ASSISTANT), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/sc_assistant/*.c
endif

ifeq ($(BUILD_WLAN), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wlan/*.c
endif

ifeq ($(BUILD_NET80211), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/net80211/*.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/net80211/port/*.c
endif

ifeq ($(BUILD_XRWIRELESS), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/driver/wireless/xradio/*.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/driver/wireless/xradio/common/*.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/driver/wireless/xradio/linux/*.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/driver/wireless/xradio/port/*.c
endif

ifeq ($(BUILD_WPA), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/wpa_debug.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/wpabuf.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/os_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/eloop_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/eloop_xradio_mail.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/crypto_none.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/tls_none.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/aes-internal.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/md5.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/md5-internal.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/rc4.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha1.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha1-prf.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha1-internal.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha1-pbkdf2.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/drivers/driver_common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/drivers/driver_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/drivers/drivers.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/common/ieee802_11_common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/common/hw_features_common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/common/wpa_common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/common/wpa_ctrl_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/l2_packet/l2_packet_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/aes-internal-enc.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eap_common/eap_common.c
endif

ifeq ($(BUILD_WPAS), y)
ifeq ($(__CONFIG_WLAN_STA), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/aes-internal-dec.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/aes-unwrap.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/rsn_supp/wpa.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/rsn_supp/preauth.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/rsn_supp/pmksa_cache.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/rsn_supp/peerkey.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/rsn_supp/wpa_ie.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/config.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/notify.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/bss.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/wmm_ac.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/wpa_supplicant.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/events.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/blacklist.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/wpas_glue.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/scan.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/config_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/eap_register.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/ctrl_iface_xradio.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/main_xradio.c
ifeq ($(__CONFIG_WLAN_STA_WPS), y)
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/wpa_supplicant/wps_supplicant.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/uuid.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eap_peer/eap_wsc.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eap_common/eap_wsc_common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_common.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_attr_parse.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_attr_build.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_attr_process.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_dev_attr.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_enrollee.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/wps/wps_registrar.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eapol_supp/eapol_supp_sm.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eap_peer/eap.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eap_peer/eap_methods.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/crypto_internal-modexp.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/tls/bignum.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/aes-cbc.c
#XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/aes-internal-enc.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha256.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha256-prf.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/sha256-internal.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/dh_groups.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/crypto/dh_group5.c
XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/utils/base64.c
#XR_SOURCE_FILES += $(LIB_SRC_PATH)/wlan/src/net/wpa_supplicant-2.4/src/eap_common/eap_common.c
endif
endif
endif