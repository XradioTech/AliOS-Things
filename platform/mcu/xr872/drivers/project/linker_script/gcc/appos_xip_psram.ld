/* Linker script to configure memory regions. */
MEMORY
{
    RAM (rwx) : ORIGIN = 0x00201000, LENGTH = 412K
    FLASH (rx) : ORIGIN = 0x00400000, LENGTH = 16M
    PSRAM (rwx) : ORIGIN = 0x01400000, LENGTH = 4096K
}
__RAM_BASE = ORIGIN(RAM);
__XIP_BASE = ORIGIN(FLASH);
__XIP_LENGTH = LENGTH(FLASH);
__XIP_END = ORIGIN(FLASH) + LENGTH(FLASH) -1;
__PSRAM_BASE = ORIGIN(PSRAM);
__PSRAM_LENGTH = LENGTH(PSRAM);
__PSRAM_END = ORIGIN(PSRAM) + LENGTH(PSRAM) -1;
__DMAHEAP_PSRAM_BASE = __PSRAM_BASE + __PSRAM_LENGTH - 256*1024;
__DMAHEAP_PSRAM_LENGTH = 256*1024;
__DMAHEAP_PSRAM_END = __DMAHEAP_PSRAM_BASE + __DMAHEAP_PSRAM_LENGTH -1;
/* Linker script to place sections and symbol values. Should be used together
 * with other linker script that defines memory regions FLASH and RAM.
 * It references following symbols, which must be defined in code:
 *   Reset_Handler : Entry of reset handler
 *
 * It defines following symbols, which code can use without definition:
 *   __exidx_start
 *   __exidx_end
 *   __etext
 *   __data_start__
 *   __preinit_array_start
 *   __preinit_array_end
 *   __init_array_start
 *   __init_array_end
 *   __fini_array_start
 *   __fini_array_end
 *   __data_end__
 *   __bss_start__
 *   __bss_end__
 *   __end__
 *   end
 *   __HeapLimit
 *   __StackLimit
 *   __StackTop
 *   __stack
 *   _estack
 */
ENTRY(Reset_Handler)
SECTIONS
{
    .xip :
    {
        . = ALIGN(4);
        __xip_start__ = .;
        /* examples */
        *alinkapp.a: (.text .text.* .rodata .rodata.*)
        *mqttapp.a: (.text .text.* .rodata .rodata.*)
        *opusapp.a: (.text .text.* .rodata .rodata.*)
        *linkvoiceapp.a: (.text .text.* .rodata .rodata.*)
        *xplayerapp.a: (.text .text.* .rodata .rodata.*)
        *linkkitapp.a: (.text .text.* .rodata .rodata.*)
        *linkkit_gateway.a: (.text .text.* .rodata .rodata.*)
        *http2app.a: (.text .text.* .rodata .rodata.*)
        /* framework */
        *cloud.a: (.text .text.* .rodata .rodata.*)
        *common.a: (.text .text.* .rodata .rodata.*)
        *common_transport.a: (.text .text.* .rodata .rodata.*)
        *coap.a: (.text .text.* .rodata .rodata.*)
        *mqtt.a: (.text .text.* .rodata .rodata.*)
        *websockets.a: (.text .text.* .rodata .rodata.*)
        *mbedtls_wrapper.a:(.text .text.* .rodata .rodata.*)
        *wsf.a: (.text .text.* .rodata .rodata.*)
        *netmgr.a: (.text .text.* .rodata .rodata.*)
        *gateway.a: (.text .text.* .rodata .rodata.*)
        *framework.a: (.text .text.* .rodata .rodata.*)
        *linkvoice.a: (.text .text.* .rodata .rodata.*)
        *douglas.a: (.text .text.* .rodata .rodata.*)
        *opus.a: (.text .text.* .rodata .rodata.*)
        *alink.a: (.text .text.* .rodata .rodata.*)
        *alink_transport.a: (.text .text.* .rodata .rodata.*)
        *libiot_awss.a: (.text .text.* .rodata .rodata.*)
        *libiot_nghttp2.a: (.text .text.* .rodata .rodata.*)
        *http.a: (.text .text.* .rodata .rodata.*)
        *libiot_http2stream.a: (.text .text.* .rodata .rodata.*)
        *libiot_devmodel.a: (.text .text.* .rodata .rodata.*)
        *libiot_mqtt.a: (.text .text.* .rodata .rodata.*)
        *libiot_coap.a: (.text .text.* .rodata .rodata.*)
        *libiot_infra.a: (.text .text.* .rodata .rodata.*)
        *libiot_wrappers.a: (.text .text.* .rodata .rodata.*)
        *libiot_bind.a: (.text .text.* .rodata .rodata.*)
        *libiot_dynreg.a: (.text .text.* .rodata .rodata.*)
        *libiot_certs.a: (.text .text.* .rodata .rodata.*)
        *libiot_sign.a: (.text .text.* .rodata .rodata.*)
        *ota.a: (.text .text.* .rodata .rodata.*)

        /* kernel */
        *net.a: (.text .text.* .rodata .rodata.*)
        *mesh.a: (.text .text.* .rodata .rodata.*)
        *fatfs.a: (.text .text.* .rodata .rodata.*)
        *cli.a: (.text .text.* .rodata .rodata.*)
        *yloop.a: (.text .text.* .rodata .rodata.*)
        *kv.a: (.text .text.* .rodata .rodata.*)
        *udhcp.a: (.text .text.* .rodata .rodata.*)
        /**rhino.a: (.text .text.* .rodata .rodata.*)  can not set*/
        *vfs.a: (.text .text.* .rodata .rodata.*)
        *debug.a: (.text .text.* .rodata .rodata.*)
        *ulog.a: (.text .text.* .rodata .rodata.*)
        *und.a: (.text .text.* .rodata .rodata.*)
        *ota_agent.a: (.text .text.* .rodata .rodata.*)

        /* security */
        *alicrypto.a: (.text .text.* .rodata .rodata.*)
        *libmbedcrypto.a: (.text .text.* .rodata .rodata.*)
        *libmbedtls.a: (.text .text.* .rodata .rodata.*)
        *tlsrc.a: (.text .text.* .rodata .rodata.*)
        *mbedtls.a: (.text .text.* .rodata .rodata.*)

        /* utils */
        *base64.a: (.text .text.* .rodata .rodata.*)
        *cjson.a: (.text .text.* .rodata .rodata.*)
        *digest_algorithm.a: (.text .text.* .rodata .rodata.*)

        /*libc_nano.a*/
        *libc_nano.a:lib_a-asctime.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-asctime_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-ctime.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-gmtime.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-gmtime_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-lcltime.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-lcltime_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-mktime.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strftime.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-gettzinfo.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-month_lengths.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-timelocal.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-tzcalc_limits.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-tzlock.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-tzset.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-tzset_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-tzvars.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-envlock.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-getenv.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-getenv_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-rand.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-getopt.o (.text .text.* .rodata .rodata.*)

        /*
         * Before putting the following objs of libc_nano.a to xip,
         * make sure they are not called in IRQ handler/callback.
         */
/*
        *libc_nano.a:lib_a-atoi.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-atol.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-atoll.o (.text .text.* .rodata .rodata.*)

        *libc_nano.a:lib_a-strcasecmp.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strcmp.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strncasecmp.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strncmp.o (.text .text.* .rodata .rodata.*)

        *libc_nano.a:lib_a-strcpy.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strlcpy.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strncpy.o (.text .text.* .rodata .rodata.*)

        *libc_nano.a:lib_a-strcat.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strchr.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strcspn.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strdup.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strdup_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strerror.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-u_strerr.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strrchr.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strspn.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strstr.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtod.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-gdtoa-gethex.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-gdtoa-hexnan.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtok.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtok_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtol.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtoll.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtoll_r.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-strtoul.o (.text .text.* .rodata .rodata.*)

        *libc_nano.a:lib_a-sscanf.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-stdio.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-nano-svfscanf.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-nano-vfscanf_i.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-nano-vfscanf_float.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-sf_nan.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-sccl.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-ungetc.o (.text .text.* .rodata .rodata.*)
*/
        /*
         * Before putting the following objs of libc_nano.a to xip,
         * make sure float printf is not used in IRQ handler/callback.
         */

        *libc_nano.a:lib_a-nano-vfprintf_float.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-dtoa.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-locale.o (.text .text.* .rodata .rodata.*)
        *libc_nano.a:lib_a-mprec.o (.text .text.* .rodata .rodata.*)
        *libm.a:lib_a-s_fpclassify.o (.text .text.* .rodata .rodata.*)
        *libm.a:lib_a-sf_fpclassify.o (.text .text.* .rodata .rodata.*)

        /* platform */
        *cedarx.a: (.text .text.* .rodata .rodata.*)
        *libmp3.a: (.text .text.* .rodata .rodata.*)
        *libamr.a: (.text .text.* .rodata .rodata.*)
        *libamren.a: (.text .text.* .rodata .rodata.*)
        *libaudmgr.a: (.text .text.* .rodata .rodata.*)
        *libudhcpd.a: (.text .text.* .rodata .rodata.*)
        *lwip.a: (.text .text.* .rodata .rodata.*)
        *efpg.a: (.text .text.* .rodata .rodata.*)

        /* net lib */
        *libwlan.a: (.text .text.* .rodata .rodata.*)
        *libnet80211.a: (.text .text.* .rodata .rodata.*)
        *libwpa.a: (.text .text.* .rodata .rodata.*)
        *libwpas.a: (.text .text.* .rodata .rodata.*)
        *libsc_assistant.a: (.text .text.* .rodata .rodata.*)
        *libxrwireless.a: (.text .text.* .rodata .rodata.*)

        /**board_xr872.a:k_config.o (.text .text.* .rodata .rodata.*) can not set*/
        *board_xr872.a:partition_conf.o (.text .text.* .rodata .rodata.*)

        *mcu_xr872.a:flash.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:adc.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:gpio.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:i2c.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:pwm.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:rtc.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:sd.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:timer.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:spi.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:wifi_port.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:wifi.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:ota_port.o (.text .text.* .rodata .rodata.*)

        *mcu_xr872.a:hal_adc.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_crypto.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_dmic.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_efuse.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_i2c.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_i2s.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_irrx.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_irtx.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_pwm.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_rtc.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_spi.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_spinlock.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_wdg.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:core.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:hal_sdhost.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:sd.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:mmc.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:quirks.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:sdio.o (.text .text.* .rodata .rodata.*)

        *mcu_xr872.a:ethernetif.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:ota.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:ota_file.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:efpg_efuse.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:efpg.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:mbuf_0.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:mbuf_0_mem.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:memcpy.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:checksum.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:console.o (.text .text.* .rodata .rodata.*)

        *mcu_xr872.a:container.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:event_queue.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:observer.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:publisher.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:sys_ctrl.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:looper.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:net_ctrl.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:net_sys.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:sc_assistant_port.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:sysinfo.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:iperf.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cmd_util.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cmd_mem.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cmd_upgrade.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cmd_etf.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cmd_iperf.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cmd_wlan.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:board.o (.text .text.* .rodata .rodata.*)

        *mcu_xr872.a:cli_ext.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cli_upgrade.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cli_mem.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cli_ext.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cli_upgrade.o (.text .text.* .rodata .rodata.*)
        *mcu_xr872.a:cli_mem.o (.text .text.* .rodata .rodata.*)

        *rom.a:hexdump.o (.text .text.* .rodata .rodata.*)
        *(.xip_text* .xip_rodata*)
        . = ALIGN(4);

        __xip_end__ = .;
    } > FLASH

    .psram_text :
    {
        . = ALIGN(4);
        __psram_start__ = .;
        __psram_text_start__ = .;

        *project/common/cmd/cmd_psram.o (.text* .rodata*)
        *(.psram_text* .psram_rodata*)

        . = ALIGN(4);
        __psram_text_end__ = .;
    } > PSRAM

    .psram_data :
    {
        . = ALIGN(4);
        __psram_data_start__ = .;
        *libmp3.a: ( .data .data.* vtable )
        *libaac.a: ( .data .data.* vtable )
        *libwav.a: ( .data .data.* vtable )
        *libamr.a: ( .data .data.* vtable )
        *libamren.a: ( .data .data.* vtable )
        *libreverb.a: ( .data .data.* vtable )
        *libopus.a: ( .data .data.* vtable )
        *libcedarx.a: ( .data .data.* vtable )
        *libpcm.a: ( .data .data.* vtable )
        *libaudmgr.a: ( .data .data.* vtable )
        *liblwip.a: ( .data .data.* vtable )
        *libmbedtls.a: ( .data .data.* vtable )
        *libhttpcli.a: ( .data .data.* vtable )
        *libhttpd.a: ( .data .data.* vtable )
        *libmqtt.a: ( .data .data.* vtable )
        *libnopoll.a: ( .data .data.* vtable )
        *liblibwebsockets.a: ( .data .data.* vtable )
        *libping.a: ( .data .data.* vtable )
        *libsntp.a: ( .data .data.* vtable )
        *libudhcpd.a: ( .data .data.* vtable )
        *libaliyun.a: ( .data .data.* vtable )
        *libwlan.a: ( .data .data.* vtable )
        *libwpa.a: ( .data .data.* vtable )
        *libwpas.a: ( .data .data.* vtable )
        *libwpas_wps.a: ( .data .data.* vtable )
        *libhostapd.a: ( .data .data.* vtable )
        *libnet80211.a: ( .data .data.* vtable )
        *libxrwireless.a: ( .data .data.* vtable )
        *libethernetif.a: ( .data .data.* vtable )
        *libxretf.a: ( .data .data.* vtable )
        *libxretf_gui.a: ( .data .data.* vtable )
        *libxrsys.a: ( .data .data.* vtable )
        *libsc_assistant.a: ( .data .data.* vtable )
        *libsmartlink.a: ( .data .data.* vtable )
        *libairkiss_aes.a: ( .data .data.* vtable )
        *libadt.a: ( .data .data.* vtable )
        *libcjson.a: ( .data .data.* vtable )
        *libfs.a: ( .data .data.* vtable )
        *libatcmd.a: ( .data .data.* vtable )
        *libefpg.a: ( .data .data.* vtable )
        *libota.a: ( .data .data.* vtable )
        *libxz.a: ( .data .data.* vtable )
        *libutil.a: ( .data .data.* vtable )
        *libchip.a:hal_wdg.o ( .data .data.* vtable )
        *libchip.a:hal_timer.o ( .data .data.* vtable )
        *libchip.a:hal_rtc.o ( .data .data.* vtable )
        *libchip.a:hal_crypto.o ( .data .data.* vtable )
        *libchip.a:hal_sdhost.o ( .data .data.* vtable )
        *libchip.a:sd.o ( .data .data.* vtable )
        *libchip.a:core.o ( .data .data.* vtable )
        *libchip.a:test.o ( .data .data.* vtable )
        *libchip.a:hal_i2s.o ( .data .data.* vtable )
        *libchip.a:ac107.o ( .data .data.* vtable )
        *libchip.a:xradio_internal_codec.o ( .data .data.* vtable )
        *libchip.a:hal_snd_card.o ( .data .data.* vtable )
        *libchip.a:hal_i2c.o ( .data .data.* vtable )
        *libchip.a:hal_dmic.o ( .data .data.* vtable )
        *libchip.a:hal_pwm.o ( .data .data.* vtable )
        *libchip.a:hal_spi.o ( .data .data.* vtable )
        *libchip.a:hal_efuse.o ( .data .data.* vtable )
        *libm.a: ( .data .data.* vtable )
        *libc_nano.a:lib_a-asctime.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-asctime_r.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-ctime.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-gmtime.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-gmtime_r.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-lcltime.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-lcltime_r.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-mktime.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-strftime.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-gettzinfo.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-month_lengths.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-timelocal.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-tzcalc_limits.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-tzlock.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-tzset.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-tzset_r.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-tzvars.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-envlock.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-getenv.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-getenv_r.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-rand.o ( .data .data.* vtable )
        *libc_nano.a:lib_a-getopt.o ( .data .data.* vtable )

        *project/common/cmd*.o ( .data .data.* vtable )
        *project/common/iperf*.o ( .data .data.* vtable )
        *project/common/apps/player_app.o ( .data .data.* vtable )
        *project/common/apps/recorder_app.o ( .data .data.* vtable )
        *project/common/apps/cedarx/os_glue/cdx_memory.o ( .data .data.* vtable )
        *project/common/apps/cedarx/os_glue/atomic.o ( .data .data.* vtable )
        *project/common/apps/cedarx/os_glue/file.o ( .data .data.* vtable )
        *project/common/apps/cedarx/os_glue/pthread.o ( .data .data.* vtable )
        *project/common/apps/cedarx/os_glue/sleep.o ( .data .data.* vtable )
        *project/common/apps/cedarx/capture_ctrl/captureControl_rtos.o ( .data .data.* vtable )
        *project/common/apps/cedarx/sound_ctrl/card_pcm.o ( .data .data.* vtable )
        *project/common/apps/cedarx/sound_ctrl/reverb_buffer.o ( .data .data.* vtable )
        *project/common/apps/cedarx/sound_ctrl/reverb_pcm.o ( .data .data.* vtable )
        *project/common/apps/cedarx/sound_ctrl/soundControl_rtos.o ( .data .data.* vtable )
        *project/common/apps/cedarx/sound_ctrl/soundStreamControl.o ( .data .data.* vtable )
        *command.o ( .data .data.* vtable )
        *(.psram_data*)

        . = ALIGN(4);
        __psram_data_end__ = .;
    } > PSRAM

    .psram_bss :
    {
        . = ALIGN(4);
        __psram_bss_start__ = .;
        *libmp3.a: ( .bss .bss.* COMMON )
        *libaac.a: ( .bss .bss.* COMMON )
        *libwav.a: ( .bss .bss.* COMMON )
        *libamr.a: ( .bss .bss.* COMMON )
        *libamren.a: ( .bss .bss.* COMMON )
        *libreverb.a: ( .bss .bss.* COMMON )
        *libopus.a: ( .bss .bss.* COMMON )
        *libcedarx.a: ( .bss .bss.* COMMON )
        *libpcm.a: ( .bss .bss.* COMMON )
        *libaudmgr.a: ( .bss .bss.* COMMON )
        *liblwip.a: ( .bss .bss.* COMMON )
        *libmbedtls.a: ( .bss .bss.* COMMON )
        *libhttpcli.a: ( .bss .bss.* COMMON )
        *libhttpd.a: ( .bss .bss.* COMMON )
        *libmqtt.a: ( .bss .bss.* COMMON )
        *libnopoll.a: ( .bss .bss.* COMMON )
        *liblibwebsockets.a: ( .bss .bss.* COMMON )
        *libping.a: ( .bss .bss.* COMMON )
        *libsntp.a: ( .bss .bss.* COMMON )
        *libudhcpd.a: ( .bss .bss.* COMMON )
        *libaliyun.a: ( .bss .bss.* COMMON )
        *libwlan.a: ( .bss .bss.* COMMON )
        *libwpa.a: ( .bss .bss.* COMMON )
        *libwpas.a: ( .bss .bss.* COMMON )
        *libwpas_wps.a: ( .bss .bss.* COMMON )
        *libhostapd.a: ( .bss .bss.* COMMON )
        *libnet80211.a: ( .bss .bss.* COMMON )
        *libxrwireless.a: ( .bss .bss.* COMMON )
        *libethernetif.a: ( .bss .bss.* COMMON )
        *libxretf.a: ( .bss .bss.* COMMON )
        *libxretf_gui.a: ( .bss .bss.* COMMON )
        *libxrsys.a: ( .bss .bss.* COMMON )
        *libsc_assistant.a: ( .bss .bss.* COMMON )
        *libsmartlink.a: ( .bss .bss.* COMMON )
        *libairkiss_aes.a: ( .bss .bss.* COMMON )
        *libadt.a: ( .bss .bss.* COMMON )
        *libcjson.a: ( .bss .bss.* COMMON )
        *libfs.a: ( .bss .bss.* COMMON )
        *libatcmd.a: ( .bss .bss.* COMMON )
        *libefpg.a: ( .bss .bss.* COMMON )
        *libota.a: ( .bss .bss.* COMMON )
        *libxz.a: ( .bss .bss.* COMMON )
        *libutil.a: ( .bss .bss.* COMMON )
        *libchip.a:hal_wdg.o ( .bss .bss.* COMMON )
        *libchip.a:hal_timer.o ( .bss .bss.* COMMON )
        *libchip.a:hal_rtc.o ( .bss .bss.* COMMON )
        *libchip.a:hal_crypto.o ( .bss .bss.* COMMON )
        *libchip.a:hal_sdhost.o ( .bss .bss.* COMMON )
        *libchip.a:sd.o ( .bss .bss.* COMMON )
        *libchip.a:core.o ( .bss .bss.* COMMON )
        *libchip.a:test.o ( .bss .bss.* COMMON )
        *libchip.a:hal_i2s.o ( .bss .bss.* COMMON )
        *libchip.a:ac107.o ( .bss .bss.* COMMON )
        *libchip.a:xradio_internal_codec.o ( .bss .bss.* COMMON )
        *libchip.a:hal_snd_card.o ( .bss .bss.* COMMON )
        *libchip.a:hal_i2c.o ( .bss .bss.* COMMON )
        *libchip.a:hal_dmic.o ( .bss .bss.* COMMON )
        *libchip.a:hal_pwm.o ( .bss .bss.* COMMON )
        *libchip.a:hal_spi.o ( .bss .bss.* COMMON )
        *libchip.a:hal_efuse.o ( .bss .bss.* COMMON )
        *libm.a: ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-asctime.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-asctime_r.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-ctime.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-gmtime.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-gmtime_r.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-lcltime.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-lcltime_r.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-mktime.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-strftime.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-gettzinfo.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-month_lengths.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-timelocal.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-tzcalc_limits.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-tzlock.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-tzset.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-tzset_r.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-tzvars.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-envlock.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-getenv.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-getenv_r.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-rand.o ( .bss .bss.* COMMON )
        *libc_nano.a:lib_a-getopt.o ( .bss .bss.* COMMON )

        *project/common/cmd*.o ( .bss .bss.* COMMON )
        *project/common/iperf*.o ( .bss .bss.* COMMON )
        *project/common/apps/player_app.o ( .bss .bss.* COMMON )
        *project/common/apps/recorder_app.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/os_glue/cdx_memory.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/os_glue/atomic.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/os_glue/file.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/os_glue/pthread.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/os_glue/sleep.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/capture_ctrl/captureControl_rtos.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/sound_ctrl/card_pcm.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/sound_ctrl/reverb_buffer.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/sound_ctrl/reverb_pcm.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/sound_ctrl/soundControl_rtos.o ( .bss .bss.* COMMON )
        *project/common/apps/cedarx/sound_ctrl/soundStreamControl.o ( .bss .bss.* COMMON )
        *command.o ( .bss .bss.* COMMON )
        *(.psram_bss*)

        . = ALIGN(16);
        __psram_bss_end__ = .;
        __psram_end__ = .;
    } > PSRAM

    .text :
    {
        . = ALIGN(4);
        __text_start__ = .;
        __VECTOR_BASE = .;
        KEEP(*(.isr_vector))
        KEEP(*(.text.Reset_Handler))
        KEEP(*(.cpu_text))
        *(.text*)
        *(.nonxip_text*)
        *(.sram_text*)
        KEEP(*(.init))
        KEEP(*(.fini))
        /* .ctors */
        *crtbegin.o(.ctors)
        *crtbegin?.o(.ctors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
        *(SORT(.ctors.*))
        *(.ctors)
        /* .dtors */
        *crtbegin.o(.dtors)
        *crtbegin?.o(.dtors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
        *(SORT(.dtors.*))
        *(.dtors)
        *(.rodata*)
        *(.nonxip_rodata*)
        *(.sram_rodata*)
        KEEP(*(.eh_frame*))
        . = ALIGN(4);
        __text_end__ = .;
    } > RAM
    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > RAM
    __exidx_start = .;
    .ARM.exidx :
    {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } > RAM
    __exidx_end = .;
    . = ALIGN(4);
    __etext = .;
    _sidata = .;
    .data :
    {
        . = ALIGN(4);
        __data_start__ = .;
        _sdata = .;
        *(vtable)
        *(.data*)
        *(.nonxip_data*)
        *(.sram_data*)
        . = ALIGN(4);
        /* preinit data */
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP(*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);
        . = ALIGN(4);
        /* init data */
        PROVIDE_HIDDEN (__init_array_start = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        PROVIDE_HIDDEN (__init_array_end = .);
        . = ALIGN(4);
        /* finit data */
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array))
        PROVIDE_HIDDEN (__fini_array_end = .);
        KEEP(*(.jcr*))
        . = ALIGN(4);
        *(*.got*)
        __data_end__ = .;
        _edata = .;
    } > RAM
    .bss :
    {
        . = ALIGN(4);
        __bss_start__ = .;
        _sbss = .;
        *(.bss*)
        *(COMMON)
        *(.nonxip_bss*)
        *(.sram_bss*)
        . = ALIGN(4);
        __bss_end__ = .;
        _ebss = .;
    } > RAM
    .heap (COPY):
    {
        __end__ = .;
        end = __end__;
        *(.heap*)
        __HeapLimit = .;
    } > RAM
    /* .stack_dummy section doesn't contains any symbols. It is only
     * used for linker to calculate size of stack sections, and assign
     * values to stack symbols later */
    .stack_dummy (COPY):
    {
        *(.stack*)
    } > RAM
    .ram_table : AT(__bss_start__)
    {
        . = ALIGN(4);
        KEEP(*(.ram_table))
        . = ALIGN(4);
    } > RAM
    __ram_table_lma_start__ = __bss_start__;
    __ram_table_lma_end__ = __ram_table_lma_start__ + SIZEOF(.ram_table);
    /*REMAIN_CACHE_SIZE = 24K;*/
    /* Set stack top to end of RAM, and stack limit move down by
     * size of stack_dummy section */
    __StackTop = ORIGIN(RAM) + LENGTH(RAM);
    /*__StackTop += REMAIN_CACHE_SIZE;*/
    __StackBottom = __StackTop - 0x400;
    _estack = __StackTop;
    __StackLimit = __StackTop - SIZEOF(.stack_dummy);
    PROVIDE(__stack = __StackTop);
    PROVIDE(heap_start = __end__);
    PROVIDE(heap_end = __StackBottom);
    PROVIDE(heap_len = heap_end - heap_start);
    __FLASH_BASE = ORIGIN(FLASH);
    PROVIDE(__XIP_Base = __FLASH_BASE);
    /* Check if data + heap + stack exceeds RAM limit */
    ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
    ASSERT(__DMAHEAP_PSRAM_BASE > __psram_end__, "ld: region dmapsramheap overflowed with psram heap")
}
