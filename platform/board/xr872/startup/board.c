/*
 * Copyright (C) 2015-2017 Alibaba Group Holding Limited
 */

#include "driver/chip/hal_def.h"
#include "driver/chip/hal_adc.h"
#include "driver/chip/hal_chip.h"
#include "aos/hal/adc_priv.h"

#include <k_api.h>
#include <k_soc.h>
#include "aos/kernel.h"
#include "aos/yloop.h"
#include "common/board/board.h"

void board_driver_init(void)
{
    return;
}

void soc_driver_init(void)
{
	static const GPIO_GlobalInitParam gpio_param = {
		.portIRQUsed  = 0xff,
		.portPmBackup = 0xff
	};

	HAL_GPIO_GlobalInit(&gpio_param);

    hal_init();

    printf("soc_driver_init done\n");
}

void soc_hardware_sys_init(void)
{
#ifdef __CONFIG_ROM
	extern void rom_init();
	rom_init();
#endif
	HAL_BoardIoctlCbRegister(board_ioctl);
	SystemInit();

    SystemCoreClockUpdate();
    HAL_GlobalInit();
}

void soc_system_init(void)
{
    printf("%s %d\n", __func__, __LINE__);

    platform_init();
}

void soc_systick_init(void)
{
    /* enable system tick */
    extern uint32_t SystemCoreClock;
    SysTick_Config(SystemCoreClock/RHINO_CONFIG_TICKS_PER_SECOND);
}

void SysTick_Handler(void)
{
    krhino_intrpt_enter();
    krhino_tick_proc();
    krhino_intrpt_exit();
}

void board_init(void)
{
    soc_sys_mem_init();

    soc_systick_init();
}
