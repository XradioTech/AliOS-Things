/* Linker script to configure memory regions. */
MEMORY
{
    RAM (rwx) : ORIGIN = 0x00218000, LENGTH = 316K
    FLASH (rx) : ORIGIN = 0x00400000, LENGTH = 1024K
}
__RAM_BASE = ORIGIN(RAM);
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
        *libawss.a: (.text .text.* .rodata .rodata.*)
        *libiot_sdk_impl.a: (.text .text.* .rodata .rodata.*)
        *libiot_http.a: (.text .text.* .rodata .rodata.*)
        *libiot_system.a: (.text .text.* .rodata .rodata.*)
        *libiot_alcs.a: (.text .text.* .rodata .rodata.*)
        *libiot_dm.a: (.text .text.* .rodata .rodata.*)
        *libiot_cm.a: (.text .text.* .rodata .rodata.*)
        *libiot_utils.a: (.text .text.* .rodata .rodata.*)
        *libiot_mqtt.a: (.text .text.* .rodata .rodata.*)
        *linkkitapp.a: (.text .text.* .rodata .rodata.*)
				*uOTA.a: (.text .text.* .rodata .rodata.*)
				*libiot_coap_local.a: (.text .text.* .rodata .rodata.*)
				*libiot_coap_coappack.a: (.text .text.* .rodata .rodata.*)

		/* kernel */
        *net.a: (.text .text.* .rodata .rodata.*)
        *mesh.a: (.text .text.* .rodata .rodata.*)
        *fatfs.a: (.text .text.* .rodata .rodata.*)
        *cli.a: (.text .text.* .rodata .rodata.*)
        *yloop.a: (.text .text.* .rodata .rodata.*)
        *kv.a: (.text .text.* .rodata .rodata.*)
        *udhcp.a: (.text .text.* .rodata .rodata.*)
        /**libc_nano.a: (.text .text.* .rodata .rodata.*)*/
				/**rhino.a: (.text .text.* .rodata .rodata.*)  can not set*/

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
				*wlan.a: (.text .text.* .rodata .rodata.*)
				*net80211.a: (.text .text.* .rodata .rodata.*)
				*wpa.a: (.text .text.* .rodata .rodata.*)
				*sc_assistant.a: (.text .text.* .rodata .rodata.*)
				*wireless.a: (.text .text.* .rodata .rodata.*)

				*mcu_xr872.a:container.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:event_queue.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:observer.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:publisher.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:sys_ctrl.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:looper.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:net_ctrl.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:sc_assistant_port.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:sysinfo.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:cmd_util.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:cmd_mem.o (.text .text.* .rodata .rodata.*)
				*mcu_xr872.a:board.o (.text .text.* .rodata .rodata.*)

        /* All xip end */
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
    /* Set stack top to end of RAM, and stack limit move down by
     * size of stack_dummy section */
    __StackTop = ORIGIN(RAM) + LENGTH(RAM);
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
