deps_config := \
	test/yunit/Config.in \
	test/testcase/network/coap/Config.in \
	test/testcase/network/lwm2m/Config.in \
	test/testcase/network/yloop/Config.in \
	test/testcase/network/rtp/Config.in \
	test/testcase/network/netmgr/Config.in \
	test/testcase/network/websoc/Config.in \
	test/testcase/network/libsrtp/Config.in \
	test/testcase/network/http/Config.in \
	test/testcase/network/ble/mesh/Config.in \
	test/testcase/network/ble/host/Config.in \
	test/testcase/network/lwip/Config.in \
	test/testcase/network/Config.in \
	test/testcase/certificate/certificate_test/Config.in \
	test/testcase/certificate/Config.in \
	test/testcase/3rdparty/experimental/fs/fatfs/Config.in \
	test/testcase/3rdparty/experimental/fs/spiffs/Config.in \
	test/testcase/3rdparty/experimental/Config.in \
	test/testcase/osal/cmsis/Config.in \
	test/testcase/osal/posix/Config.in \
	test/testcase/osal/aos/Config.in \
	test/testcase/osal/Config.in \
	test/testcase/utility/cjson/Config.in \
	test/testcase/utility/Config.in \
	test/testcase/middleware/uagent/uagent/Config.in \
	test/testcase/middleware/uagent/Config.in \
	test/testcase/kernel/lib/rbtree/Config.in \
	test/testcase/kernel/basic/Config.in \
	test/testcase/kernel/fs/vfs/Config.in \
	test/testcase/kernel/fs/ramfs/Config.in \
	test/testcase/kernel/fs/kv/Config.in \
	test/testcase/kernel/rhino/Config.in \
	test/testcase/kernel/Config.in \
	test/testcase/Config.in \
	test/Config.in \
	core/rbtree/Config.in \
	components/utility/zlib/Config.in \
	components/security/mbedtls/Config.in \
	components/utility/cjson/Config.in \
	components/security/linksecurity/prov/Config.in \
	components/security/linksecurity/itls/Config.in \
	components/security/linksecurity/isst/Config.in \
	components/security/linksecurity/irot/demo/Config.in \
	components/security/linksecurity/irot/tee/Config.in \
	components/security/linksecurity/irot/se/Config.in \
	components/security/linksecurity/irot/km/Config.in \
	components/security/linksecurity/irot/Config.in \
	components/security/linksecurity/id2/Config.in \
	components/security/linksecurity/dpm/Config.in \
	components/security/linksecurity/alicrypto/Config.in \
	components/security/linksecurity/ls_hal/Config.in \
	components/security/linksecurity/ls_osa/Config.in \
	components/security/linksecurity/Config.in \
	components/language/jsengine/src/services/Config.in \
	components/language/jsengine/src/engine/Config.in \
	components/language/jsengine/Config.in \
	components/dm/bootloader/Config.in \
	components/dm/ota/Config.in \
	components/dm/ulog/Config.in \
	components/network/netmgr/activation/chip_code/Config.in \
	components/network/netmgr/activation/Config.in \
	components/bus/knx/Config.in \
	components/bus/canopen/Config.in \
	components/bus/usb/Config.in \
	components/bus/mbmaster/Config.in \
	components/fs/ramfs/Config.in \
	components/service/uai/Config.in \
	components/service/ulocation/Config.in \
	components/service/udata/Config.in \
	components/dm/uagent/Config.in \
	components/linkkit/certs/Config.in \
	components/linkkit/wrappers/Config.in \
	components/linkkit/infra/Config.in \
	components/linkkit/dynamic_register/Config.in \
	components/linkkit/dev_reset/Config.in \
	components/linkkit/dev_sign/Config.in \
	components/linkkit/iot_coap/Config.in \
	components/linkkit/iot_http/Config.in \
	components/linkkit/http2/Config.in \
	components/linkkit/wifi_provision/Config.in \
	components/linkkit/dev_model/Config.in \
	components/linkkit/mqtt/Config.in \
	components/linkkit/Config.in \
	components/network/mal/Config.in \
	components/network/httpdns/Config.in \
	components/network/websocket/Config.in \
	components/dm/und/Config.in \
	components/network/http/Config.in \
	components/network/umesh2/Config.in \
	components/utility/yloop/Config.in \
	components/network/rtp/Config.in \
	components/network/netmgr/Config.in \
	components/utility/at/Config.in \
	components/network/sal/Config.in \
	components/network/lwm2m/Config.in \
	components/network/lwip/Config.in \
	components/wireless/lorawan/lorawan_4_4_2/Config.in \
	components/wireless/lorawan/lorawan_4_4_0/Config.in \
	components/wireless/lorawan/Config.in \
	components/network/libsrtp/Config.in \
	components/network/coap/Config.in \
	components/wireless/bluetooth/blemesh/Config.in \
	components/wireless/bluetooth/ble/host/profile/Config.in \
	components/wireless/bluetooth/ble/host/bt_common/Config.in \
	components/wireless/bluetooth/ble/host/Config.in \
	components/wireless/bluetooth/ble/breeze/ref-impl/Config.in \
	components/wireless/bluetooth/ble/breeze/Config.in \
	components/network/Config.in \
	components/peripherals/sensor/Config.in \
	components/peripherals/iot_comm_module/sal/Config.in \
	components/peripherals/iot_comm_module/mal/Config.in \
	components/peripherals/iot_comm_module/Config.in \
	components/peripherals/Config.in \
	core/osal/cmsis/Config.in \
	core/osal/posix/Config.in \
	core/osal/aos/Config.in \
	core/vfs/Config.in \
	core/kv/Config.in \
	core/debug/Config.in \
	core/cli/Config.in \
	core/libc/Config.in \
	core/cplusplus/Config.in \
	core/mbins/Config.in \
	core/pwrmgmt/Config.in \
	core/init/Config.in \
	core/mk/syscall/ksyscall/Config.in \
	core/mk/kspace/Config.in \
	core/rhino/Config.in \
	core/Config.in \
	platform/board/board_legacy/xr871evb/Config.in \
	platform/mcu/xr871/Config.in \
	platform/board/board_legacy/xr809/Config.in \
	platform/mcu/xm510/Config.in \
	platform/board/board_legacy/xm510_evb/Config.in \
	platform/mcu/wm_w600/Config.in \
	platform/board/board_legacy/wm_w600_kit/Config.in \
	platform/mcu/rda5981x/Config.in \
	platform/board/board_legacy/uno-91h/Config.in \
	platform/mcu/swm320/Config.in \
	platform/board/board_legacy/swm320evb/Config.in \
	platform/mcu/sv6266/Config.in \
	platform/board/board_legacy/sv6266_evb/Config.in \
	platform/board/board_legacy/stm32l496g-discovery/Config.in \
	platform/board/board_legacy/stm32l476rg-nucleo/Config.in \
	platform/board/board_legacy/stm32l433rc-nucleo/Config.in \
	platform/board/board_legacy/stm32l432kc-nucleo/Config.in \
	platform/mcu/stm32f7xx/Config.in \
	platform/board/board_legacy/stm32f769i-discovery/Config.in \
	platform/board/board_legacy/stm32f429zi-mk/Config.in \
	platform/board/stm32f429zi-nucleo/Config.in \
	platform/board/board_legacy/stm32f412zg-nucleo/Config.in \
	platform/board/board_legacy/stm32f411re-nucleo/Config.in \
	platform/mcu/stm32f4xx_cube/Config.in \
	platform/board/board_legacy/stm32f401re-nucleo/Config.in \
	platform/mcu/stm32f0xx/Config.in \
	platform/board/board_legacy/stm32f091rc-nucleo/Config.in \
	platform/board/board_legacy/starterkit/Config.in \
	platform/mcu/sscp131/Config.in \
	platform/board/board_legacy/ssc1667/Config.in \
	platform/mcu/atsaml21/Config.in \
	platform/board/board_legacy/saml21_iot_sk/Config.in \
	platform/board/board_legacy/rk1108/Config.in \
	platform/board/board_legacy/pca10056/Config.in \
	platform/board/board_legacy/pca10040e/Config.in \
	platform/mcu/nrf52xxx/Config.in \
	platform/board/board_legacy/pca10040/Config.in \
	platform/board/board_legacy/nutiny-evb-nano130/Config.in \
	platform/mcu/nano130ke3bn/Config.in \
	platform/board/board_legacy/numaker-pfm-nano130/Config.in \
	platform/board/board_legacy/numaker-iot-m487/Config.in \
	platform/mcu/m487jidae/Config.in \
	platform/board/board_legacy/numaker-pfm-m487/Config.in \
	platform/mcu/msp432p4xx/Config.in \
	platform/board/board_legacy/msp432p4111launchpad/Config.in \
	platform/board/board_legacy/mk3239/Config.in \
	platform/board/board_legacy/mk3166/Config.in \
	platform/mcu/stm32f4xx/Config.in \
	platform/board/board_legacy/mk3165/Config.in \
	platform/mcu/moc108/Config.in \
	platform/board/board_legacy/mk3060/Config.in \
	platform/mcu/mx1101/Config.in \
	platform/board/board_legacy/mk1101/Config.in \
	platform/board/board_legacy/m400/Config.in \
	platform/mcu/efm32gxx/Config.in \
	platform/board/board_legacy/m100c/Config.in \
	platform/mcu/lpc54628/Config.in \
	platform/board/board_legacy/lpcxpresso54628/Config.in \
	platform/mcu/lpc54608/Config.in \
	platform/board/board_legacy/lpcxpresso54608/Config.in \
	platform/mcu/lpc54114/Config.in \
	platform/board/board_legacy/lpcxpresso54114/Config.in \
	platform/mcu/lpc54102/Config.in \
	platform/board/board_legacy/lpcxpresso54102/Config.in \
	platform/mcu/lpc54018/Config.in \
	platform/board/board_legacy/lpcxpresso54018/Config.in \
	platform/board/board_legacy/imx6sl/Config.in \
	platform/arch/arm/armv7a/Config.in \
	platform/mcu/imx6/Config.in \
	platform/board/board_legacy/imx6dq/Config.in \
	platform/board/board_legacy/hr8p296fllt/Config.in \
	platform/mcu/hr8p2xx/Config.in \
	platform/board/board_legacy/hr8p287fjlt/Config.in \
	platform/mcu/hk32f103/Config.in \
	platform/board/board_legacy/hk32f103rb_evb/Config.in \
	platform/arch/risc-v/risc_v32I/Config.in \
	platform/mcu/freedom-e/e310/Config.in \
	platform/board/board_legacy/hifive1/Config.in \
	platform/mcu/hc32l136/Config.in \
	platform/board/board_legacy/hc32l136k8ta/Config.in \
	platform/mcu/gd32f4xx/Config.in \
	platform/board/board_legacy/gd32f450z-eval/Config.in \
	platform/mcu/gd32f3x0/Config.in \
	platform/board/board_legacy/gd32f350r-eval/Config.in \
	platform/mcu/gd32f30x/Config.in \
	platform/board/board_legacy/gd32f307c-eval/Config.in \
	platform/mcu/mkl82z7/Config.in \
	platform/board/board_legacy/frdmkl82z/Config.in \
	platform/mcu/mkl81z7/Config.in \
	platform/board/board_legacy/frdmkl81z/Config.in \
	platform/mcu/mkl43z4/Config.in \
	platform/board/board_legacy/frdmkl43z/Config.in \
	platform/mcu/mkl28z7/Config.in \
	platform/board/board_legacy/frdmkl28z/Config.in \
	platform/mcu/mkl27z644/Config.in \
	platform/board/board_legacy/frdmkl27z/Config.in \
	platform/mcu/mkl26z4/Config.in \
	platform/board/board_legacy/frdmkl26z/Config.in \
	platform/mcu/fm33a0xx/Config.in \
	platform/board/board_legacy/fm33a0xx-discovery/Config.in \
	platform/mcu/mimxrt1021/Config.in \
	platform/board/board_legacy/evkmimxrt1020/Config.in \
	platform/mcu/mimxrt1052/Config.in \
	platform/board/board_legacy/evkbimxrt1050/Config.in \
	platform/board/board_legacy/esp8285/Config.in \
	platform/board/board_legacy/esp32sram/Config.in \
	platform/arch/xtensa/lx6/Config.in \
	platform/mcu/esp32/Config.in \
	platform/board/board_legacy/esp32devkitc/Config.in \
	platform/mcu/es8p508x/Config.in \
	platform/board/board_legacy/es8p5088fllq/Config.in \
	platform/mcu/stm32l0xx/Config.in \
	platform/board/board_legacy/eml3047/Config.in \
	platform/mcu/dahua/Config.in \
	platform/board/board_legacy/dh5021a_evb/Config.in \
	platform/arch/arm/armv7m-mk/Config.in \
	platform/board/board_legacy/developerkit-mk/Config.in \
	platform/board/board_legacy/developerkit/Config.in \
	platform/mcu/cy8c6347/Config.in \
	platform/board/board_legacy/cy8ckit-062/Config.in \
	platform/arch/csky/cskyv2-l/Config.in \
	platform/mcu/csky/Config.in \
	platform/board/board_legacy/cb2201/Config.in \
	platform/mcu/bk7231u/Config.in \
	platform/board/board_legacy/bk7231udevkitc/Config.in \
	platform/mcu/bk7231s/Config.in \
	platform/board/board_legacy/bk7231sdevkitc/Config.in \
	platform/arch/arm/armv5/Config.in \
	platform/mcu/bk7231/Config.in \
	platform/board/board_legacy/bk7231devkitc/Config.in \
	platform/mcu/stm32l475/Config.in \
	platform/board/board_legacy/b_l475e/Config.in \
	platform/mcu/atsamd5x_e5x/Config.in \
	platform/board/board_legacy/atsame54-xpro/Config.in \
	platform/arch/arm/armv6m/Config.in \
	platform/mcu/cy8c4147/Config.in \
	platform/board/board_legacy/asr6501/Config.in \
	platform/mcu/mvs_ap80xx/Config.in \
	platform/board/board_legacy/ap80a0/Config.in \
	platform/mcu/stm32l4xx_cube/Config.in \
	platform/board/board_legacy/AIoTKIT/Config.in \
	platform/board/board_legacy/amebaz_dev/Config.in \
	platform/mcu/xmc/Config.in \
	platform/board/board_legacy/xmc4800-relax/Config.in \
	platform/arch/linux/Config.in \
	platform/mcu/linux/Config.in \
	platform/board/linuxhost/Config.in \
	platform/mcu/asr5501mk/Config.in \
	platform/board/mk3072/Config.in \
	platform/mcu/asr5501/Config.in \
	platform/board/asr5501/Config.in \
	platform/mcu/rtl8710bn/Config.in \
	platform/board/mk3080/Config.in \
	platform/arch/xtensa/lx106/Config.in \
	platform/mcu/esp8266/Config.in \
	platform/board/esp8266/Config.in \
	platform/mcu/stm32f1xx/Config.in \
	platform/board/stm32f103rb-nucleo/Config.in \
	platform/arch/arm/armv7m/Config.in \
	platform/mcu/aamcu_demo/Config.in \
	platform/board/aaboard_demo/Config.in \
	platform/board/Config.in \
	application/Config.in \
	application/profile/tmall_model/Config.in \
	application/profile/gatewayapp/Config.in \
	application/profile/Config.in \
	application/example/knx_demo/Config.in \
	application/example/umesh2_demo/Config.in \
	application/example/example_legacy/wifi_at_app/Config.in \
	application/example/example_legacy/mal_app/Config.in \
	application/example/example_legacy/lwm2m_app/Config.in \
	application/example/example_legacy/at_app/Config.in \
	application/example/example_legacy/httpdns_app/Config.in \
	application/example/example_legacy/websoc_app/Config.in \
	application/example/example_legacy/yloop_app/Config.in \
	application/example/example_legacy/sal_app/Config.in \
	application/example/example_legacy/ulog_app/Config.in \
	application/example/example_legacy/uapp2/Config.in \
	core/mk/syscall/usyscall/Config.in \
	core/mk/uspace/Config.in \
	application/example/example_legacy/uapp1/Config.in \
	application/example/example_legacy/uai_demo/uai_cifar10_demo/Config.in \
	application/example/example_legacy/uai_demo/uai_kws_demo/Config.in \
	application/example/example_legacy/jsengine_app/Config.in \
	application/example/example_legacy/udata_demo/udata_cloud_demo/Config.in \
	application/example/example_legacy/udata_demo/udata_local_demo/Config.in \
	application/example/example_legacy/udata_demo/sensor_cloud_demo/Config.in \
	application/example/example_legacy/udata_demo/sensor_local_demo/Config.in \
	application/example/example_legacy/httpclient_app/Config.in \
	application/example/example_legacy/httpapp/Config.in \
	application/example/example_legacy/yts/Config.in \
	application/example/example_legacy/ulocation/qianxunapp/Config.in \
	application/example/example_legacy/ulocation/baseapp/Config.in \
	application/example/example_legacy/udataapp/Config.in \
	application/example/example_legacy/uart/Config.in \
	application/example/example_legacy/sk/sk_gui/Config.in \
	application/example/example_legacy/prov_app/Config.in \
	application/example/example_legacy/otaapp/Config.in \
	application/example/example_legacy/mqttapp/Config.in \
	application/example/example_legacy/modbus_app/Config.in \
	application/example/example_legacy/lorawan/linkwan/Config.in \
	application/example/example_legacy/linkkitapp/Config.in \
	application/example/example_legacy/linkkit_gateway/Config.in \
	application/example/example_legacy/itls_app/Config.in \
	application/example/example_legacy/id2_app/Config.in \
	application/example/example_legacy/http2app/Config.in \
	application/example/example_legacy/halapp/Config.in \
	application/example/example_legacy/helloworld/Config.in \
	application/example/example_legacy/dk/dk_qr/Config.in \
	application/example/example_legacy/dk/dk_gui/Config.in \
	application/example/example_legacy/dk/dk_camera/Config.in \
	application/example/example_legacy/dk/dk_audio/Config.in \
	application/example/example_legacy/das_app/Config.in \
	application/example/example_legacy/coapapp/Config.in \
	application/example/example_legacy/bluetooth/breezeapp/Config.in \
	application/example/example_legacy/bluetooth/bleperipheral/Config.in \
	application/example/example_legacy/bluetooth/blemesh_tmall/Config.in \
	application/example/example_legacy/bluetooth/bleadv/Config.in \
	application/example/example_legacy/blink/Config.in \
	application/example/debug_demo/Config.in \
	application/example/ulog_demo/Config.in \
	application/example/ulocation/qianxun_demo/Config.in \
	application/example/ulocation/base_demo/Config.in \
	application/example/modbus_demo/Config.in \
	application/example/lwm2m_demo/Config.in \
	application/example/http2_demo/Config.in \
	application/example/vfs_demo/Config.in \
	application/example/kernel_demo/aos_api_demo/Config.in \
	application/example/kernel_demo/krhino_api_demo/Config.in \
	application/example/yts_demo/Config.in \
	application/example/linkkit_gateway_demo/Config.in \
	application/example/mqtt_demo/Config.in \
	application/example/yloop_demo/Config.in \
	application/example/blink_demo/Config.in \
	application/example/http_demo/Config.in \
	application/example/coap_demo/Config.in \
	application/example/linkkit_demo/Config.in \
	application/example/ota_demo/Config.in \
	application/example/hal_demo/Config.in \
	application/example/helloworld_demo/Config.in \
	application/example/Config.in \
	./build/Config.in

out/config/auto.conf: \
	$(deps_config)


$(deps_config): ;
