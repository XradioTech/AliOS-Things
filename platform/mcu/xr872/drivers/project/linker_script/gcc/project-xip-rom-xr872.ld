/* Linker script to configure memory regions. */
MEMORY
{
    RAM (rwx) : ORIGIN = 0x00201000, LENGTH = 412K
    FLASH (rx) : ORIGIN = 0x00400000, LENGTH = 16M
}
__RAM_BASE = ORIGIN(RAM);
__XIP_BASE = ORIGIN(FLASH);
__XIP_LENGTH = LENGTH(FLASH);
__XIP_END = ORIGIN(FLASH) + LENGTH(FLASH) -1;
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
}
