/*
 * Copyright (C) 2017 XRADIO TECHNOLOGY CO., LTD. All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *    1. Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the
 *       distribution.
 *    3. Neither the name of XRADIO TECHNOLOGY CO., LTD. nor the names of
 *       its contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef __CONFIG_ROM

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "kernel/os/os.h"
#include "driver/chip/hal_wdg.h" /* for HAL_WDG_Feed() */
#include "driver/chip/hal_flash.h"
#include "driver/chip/hal_flashctrl.h"
#include "driver/chip/hal_icache.h"
#include "driver/chip/hal_dcache.h"
#include "driver/chip/sdmmc/hal_sdhost.h"
#include "driver/chip/hal_wakeup.h"
#include "driver/chip/hal_util.h"
#include "pm/pm.h"
#include "image/flash.h"
#include "image/fdcm.h"
#include "image/image.h"

#include "rom/ram_table.h"

#include "aos/hal/uart.h"

#if 0
void *__wrap__malloc_r(struct _reent *reent, size_t size);
void *__wrap__realloc_r(struct _reent *reent, void *ptr, size_t size);
void __wrap__free_r(struct _reent *reent, void *ptr);
void *_sbrk(int incr);
int __wrap_vprintf(const char *format, va_list ap);
int __wrap_puts(const char *s);
int __wrap_vfprintf(FILE *stream, const char *format, va_list ap);
int __wrap_fputs(const char *s, FILE *stream);
int __wrap_putchar(int c);
int __wrap_putc(int c, FILE *stream);
int __wrap_fputc(int c, FILE *stream);
int __wrap_fflush(FILE *stream);
#endif

void *__wrap__malloc_r(struct _reent *reent, size_t size)
{

	void * p;
	p = malloc(size);
	//printf("p %p, size %d\n", p, size);
	return p;
}
void *__wrap__realloc_r(struct _reent *reent, void *ptr, size_t size)
{
    //printf("%s\n", __func__);
	return realloc(ptr, size);
//#error "realloc() not support"
//		free(ptr);
	//	return malloc(size);
}
void __wrap__free_r(struct _reent *reent, void *ptr)
{
	//printf("%s\n", __func__);
	free(ptr);
}
void *_sbrk(int incr)  //cannot call
{
	printf("%s\n", __func__);
}

static int uart_out(const char *buf, int len)
{
	uart_dev_t	uart_stdio;

	memset(&uart_stdio, 0, sizeof(uart_stdio));
	uart_stdio.port = 0;
	return hal_uart_send(&uart_stdio, (void *)buf, len, 0);
}

#define s_stdio_write uart_out
#define WRAP_STDOUT_BUF_SIZE	1024
static char s_stdout_buf[WRAP_STDOUT_BUF_SIZE];

static __inline int stdio_wrap_write(char *buf, int len, int max)
{
#ifndef __CONFIG_LIBC_PRINTF_FLOAT
	/* BUG: If "__CONFIG_LIBC_PRINTF_FLOAT" is not defined, the return value
	 *      of vsnprintf() is wrong when the string format including float
	 *      conversion characters "efgEFG".
	 * FIX: Use strlen() to calc the real length.
	 */
	if (len > 0 && len <= max && buf[len] == 0 && buf[len-1] != 0) {
		/* The len seems to be correct. */
	} else {
		buf[max] = 0;
		len = strlen(buf);
	}
#endif
	return s_stdio_write(buf, len);
}


int __wrap_printf(const char *format, ...)
{
	int len;
	va_list ap;

	//stdout_mutex_lock();

	if (s_stdio_write == NULL) {
		len = 0;
	} else {
		va_start(ap, format);
		len = vsnprintf(s_stdout_buf, WRAP_STDOUT_BUF_SIZE, format, ap);
		va_end(ap);
		len = stdio_wrap_write(s_stdout_buf, len, WRAP_STDOUT_BUF_SIZE - 1);
	}

	//stdout_mutex_unlock();

	return len;
}


int __wrap_vprintf(const char *format, va_list ap)
{
	//printf("%s\n", __func__);
	int len;

	//stdout_mutex_lock();

	if (s_stdio_write == NULL) {
		len = 0;
	} else {
		len = vsnprintf(s_stdout_buf, WRAP_STDOUT_BUF_SIZE, format, ap);
		len = stdio_wrap_write(s_stdout_buf, len, WRAP_STDOUT_BUF_SIZE - 1);
	}

	//stdout_mutex_unlock();

	return len;

}
int __wrap_puts(const char *s)
{
	//printf("%s\n", __func__);
	int len;

	//stdout_mutex_lock();

	if (s_stdio_write == NULL) {
		len = 0;
	} else {
		len = s_stdio_write(s, strlen(s));
		len += s_stdio_write("\n", 1);
	}

	//stdout_mutex_unlock();

	return len;

}
int __wrap_vfprintf(FILE *stream, const char *format, va_list ap)
{
	if (stream != stdout && stream != stderr)
		return 0;

	return __wrap_vprintf(format, ap);

}
int __wrap_fputs(const char *s, FILE *stream)
{
	if (stream != stdout && stream != stderr)
		return 0;

	return __wrap_puts(s);

}
int __wrap_putchar(int c)
{
	int len;
	char cc;

	//stdout_mutex_lock();

	if (s_stdio_write == NULL) {
		len = 0;
	} else {
		cc = c;
		len = s_stdio_write(&cc, 1);
	}

	//stdout_mutex_unlock();

	return len;

}
int __wrap_putc(int c, FILE *stream)
{
	if (stream != stdout && stream != stderr)
		return 0;

	return __wrap_putchar(c);
}
int __wrap_fputc(int c, FILE *stream)
{
	return __wrap_putc(c, stream);
}
int __wrap_fflush(FILE *stream)
{
	return 0;
}

typedef void * TaskHandle_t;
void vApplicationStackOverflowHook(TaskHandle_t xTask, char *pcTaskName) {

	printf("task %p(%s) stack over flow\n", xTask, pcTaskName);
}

#if 0
void OS_ThreadList(void)
{
	printf("%s\n", __func__);
}
#endif

/* SDC */
struct mmc_request;
extern int32_t HAL_SDC_Update_Clk(struct mmc_host *host, uint32_t clk);
extern int32_t HAL_SDC_Clk_PWR_Opt(struct mmc_host *host, uint32_t oclk_en, uint32_t pwr_save);
extern int32_t HAL_SDC_PowerOn(struct mmc_host *host);
extern int32_t HAL_SDC_PowerOff(struct mmc_host *host);
extern int32_t HAL_SDC_Request(struct mmc_host *host, struct mmc_request *mrq);

static int ram_OS_SemaphoreIsValid(OS_Semaphore_t *sem)
{
	return OS_SemaphoreIsValid(sem);
}

static void ram_OS_SemaphoreSetInvalid(OS_Semaphore_t *sem)
{
	OS_SemaphoreSetInvalid(sem);
}

static void ram_OS_MSleep(OS_Time_t msec)
{
	OS_MSleep(msec);
}

static OS_Time_t ram_OS_GetTicks(void)
{
	return OS_GetTicks();
}

#define configMINIMAL_STACK_SIZE                128
#define configTIMER_QUEUE_LENGTH                10
#define configTIMER_TASK_STACK_DEPTH            512


#define RAM_TBL_SET(name, val)	[RAM_TBL_IDX_##name] = (unsigned int)(val)

unsigned int ram_table[256] __attribute__((section(".ram_table"))) = {
	/* chip */
	RAM_TBL_SET(SYS_PLL_CLOCK, SYS_PLL_CLOCK),  //ram
	RAM_TBL_SET(SYS_LFCLOCK, SYS_LFCLOCK),  //ram
	RAM_TBL_SET(HAL_PRCM_GetHFClock, HAL_PRCM_GetHFClock), //rom code
	RAM_TBL_SET(HAL_PRCM_GetLFClock, HAL_PRCM_GetLFClock),  //ram patch
	RAM_TBL_SET(HAL_PRCM_GetDevClock, HAL_PRCM_GetDevClock), //rom code
	RAM_TBL_SET(HAL_CCM_BusGetAPBSClock, HAL_CCM_BusGetAPBSClock),  //rom code

#if 1
	/* lib */
	RAM_TBL_SET(__wrap__malloc_r, __wrap__malloc_r),
	RAM_TBL_SET(__wrap__realloc_r, __wrap__realloc_r),
	RAM_TBL_SET(__wrap__free_r, __wrap__free_r),
	RAM_TBL_SET(_sbrk, _sbrk),
	RAM_TBL_SET(__wrap_vprintf, __wrap_vprintf),
	RAM_TBL_SET(__wrap_puts, __wrap_puts),
	RAM_TBL_SET(__wrap_vfprintf, __wrap_vfprintf),
	RAM_TBL_SET(__wrap_fputs, __wrap_fputs),
	RAM_TBL_SET(__wrap_putchar, __wrap_putchar),
	RAM_TBL_SET(__wrap_putc, __wrap_putc),
	RAM_TBL_SET(__wrap_fputc, __wrap_fputc),
	RAM_TBL_SET(__wrap_fflush, __wrap_fflush),
#endif

#if 0
		/* lib */
		RAM_TBL_SET(__wrap__malloc_r, NULL),
		RAM_TBL_SET(__wrap__realloc_r, NULL),
		RAM_TBL_SET(__wrap__free_r, NULL),
		RAM_TBL_SET(_sbrk, NULL),
		RAM_TBL_SET(__wrap_vprintf, NULL),
		RAM_TBL_SET(__wrap_puts, NULL),
		RAM_TBL_SET(__wrap_vfprintf, NULL),
		RAM_TBL_SET(__wrap_fputs, NULL),
		RAM_TBL_SET(__wrap_putchar, NULL),
		RAM_TBL_SET(__wrap_putc, NULL),
		RAM_TBL_SET(__wrap_fputc, NULL),
		RAM_TBL_SET(__wrap_fflush, NULL),
#endif

	/* FreeRTOS */
	RAM_TBL_SET(configMINIMAL_STACK_SIZE, configMINIMAL_STACK_SIZE),
	RAM_TBL_SET(configTIMER_QUEUE_LENGTH, configTIMER_QUEUE_LENGTH),
	RAM_TBL_SET(configTIMER_TASK_STACK_DEPTH, configTIMER_TASK_STACK_DEPTH),
	RAM_TBL_SET(vApplicationStackOverflowHook, vApplicationStackOverflowHook),

	/* OS */
	RAM_TBL_SET(OS_SemaphoreCreate, OS_SemaphoreCreate),
	RAM_TBL_SET(OS_SemaphoreCreateBinary, OS_SemaphoreCreateBinary),
	RAM_TBL_SET(OS_SemaphoreDelete, OS_SemaphoreDelete),
	RAM_TBL_SET(OS_SemaphoreWait, OS_SemaphoreWait),
	RAM_TBL_SET(OS_SemaphoreRelease, OS_SemaphoreRelease),
	RAM_TBL_SET(OS_SemaphoreIsValid, ram_OS_SemaphoreIsValid),
	RAM_TBL_SET(OS_SemaphoreSetInvalid, ram_OS_SemaphoreSetInvalid),

	RAM_TBL_SET(OS_MutexCreate, OS_MutexCreate),
	RAM_TBL_SET(OS_MutexDelete, OS_MutexDelete),
	RAM_TBL_SET(OS_MutexLock, OS_MutexLock),
	RAM_TBL_SET(OS_MutexUnlock, OS_MutexUnlock),
	RAM_TBL_SET(OS_RecursiveMutexCreate, OS_RecursiveMutexCreate),
	RAM_TBL_SET(OS_RecursiveMutexDelete, OS_RecursiveMutexDelete),
	RAM_TBL_SET(OS_RecursiveMutexLock, OS_RecursiveMutexLock),
	RAM_TBL_SET(OS_RecursiveMutexUnlock, OS_RecursiveMutexUnlock),

	RAM_TBL_SET(OS_ThreadList, OS_ThreadList),   //exception.c rom  // configUSE_TRACE_FACILITY == 1 not define
	RAM_TBL_SET(OS_ThreadSuspendScheduler, OS_ThreadSuspendScheduler),
	RAM_TBL_SET(OS_ThreadResumeScheduler, OS_ThreadResumeScheduler),
	RAM_TBL_SET(OS_ThreadIsSchedulerRunning, OS_ThreadIsSchedulerRunning),

	RAM_TBL_SET(OS_TimerCreate, OS_TimerCreate),
	RAM_TBL_SET(OS_TimerDelete, OS_TimerDelete),
	RAM_TBL_SET(OS_TimerStart, OS_TimerStart),
	RAM_TBL_SET(OS_TimerChangePeriod, OS_TimerChangePeriod),
	RAM_TBL_SET(OS_TimerStop, OS_TimerStop),
	RAM_TBL_SET(OS_TimerIsActive, OS_TimerIsActive),

	RAM_TBL_SET(OS_HZ, OS_HZ),
	RAM_TBL_SET(OS_GetTicks, ram_OS_GetTicks),
	RAM_TBL_SET(OS_MSleep, ram_OS_MSleep),

	RAM_TBL_SET(HAL_UDelay, HAL_UDelay),
	RAM_TBL_SET(HAL_Alive, HAL_WDG_Feed),

	/* image */
	RAM_TBL_SET(flash_rw, flash_rw),
	RAM_TBL_SET(flash_get_erase_block, flash_get_erase_block),
	RAM_TBL_SET(flash_erase, flash_erase),
	RAM_TBL_SET(fdcm_open, fdcm_open),
	RAM_TBL_SET(fdcm_read, fdcm_read),
	RAM_TBL_SET(fdcm_write, fdcm_write),
	RAM_TBL_SET(image_checksum16, image_checksum16),

	/* flash */
	RAM_TBL_SET(HAL_Flash_Open, HAL_Flash_Open),
	RAM_TBL_SET(HAL_Flash_Close, HAL_Flash_Close),
	RAM_TBL_SET(HAL_Flash_Write, HAL_Flash_Write),
	RAM_TBL_SET(HAL_Flash_Read, HAL_Flash_Read),
	RAM_TBL_SET(HAL_Flash_Erase, HAL_Flash_Erase),
	RAM_TBL_SET(HAL_Flash_MemoryOf, HAL_Flash_MemoryOf),
	RAM_TBL_SET(flashcDriverCreate, flashcDriverCreate),
#if FLASH_SPI_ENABLE
	RAM_TBL_SET(spiDriverCreate, spiDriverCreate),
#else
	RAM_TBL_SET(spiDriverCreate, NULL),
#endif

	RAM_TBL_SET(FlashChipGetCfgList, FlashChipGetCfgList),
	RAM_TBL_SET(FlashChipGetChipList, FlashChipGetChipList),
	RAM_TBL_SET(defaultControl, defaultControl),
	RAM_TBL_SET(HAL_Flashc_Delay, HAL_Flashc_Delay),
	RAM_TBL_SET(HAL_Flashc_Xip_Init, HAL_Flashc_Xip_Init),
	RAM_TBL_SET(HAL_Flashc_Xip_Deinit, HAL_Flashc_Xip_Deinit),
	RAM_TBL_SET(HAL_Flashc_Init, HAL_Flashc_Init),
	RAM_TBL_SET(HAL_Flashc_Deinit, HAL_Flashc_Deinit),
	RAM_TBL_SET(HAL_Flashc_Open, HAL_Flashc_Open),
	RAM_TBL_SET(HAL_Flashc_Close, HAL_Flashc_Close),
	RAM_TBL_SET(FC_GetDataDelay, FC_GetDataDelay),
#ifdef __CONFIG_XIP
	RAM_TBL_SET(ICACHE_START_ADDR, ICACHE_START_ADDR),
	RAM_TBL_SET(ICACHE_END_ADDR, ICACHE_END_ADDR),
#endif
#ifdef __CONFIG_PSRAM
	RAM_TBL_SET(DCACHE_START_ADDR, DCACHE_START_ADDR),
	RAM_TBL_SET(DCACHE_END_ADDR, DCACHE_END_ADDR),
#endif
	/* sdio */
	RAM_TBL_SET(HAL_SDC_Open, HAL_SDC_Open),
	RAM_TBL_SET(HAL_SDC_Close, HAL_SDC_Close),
	RAM_TBL_SET(HAL_SDC_Update_Clk, HAL_SDC_Update_Clk),
	RAM_TBL_SET(HAL_SDC_Clk_PWR_Opt, HAL_SDC_Clk_PWR_Opt),
	RAM_TBL_SET(HAL_SDC_PowerOn, HAL_SDC_PowerOn),
	RAM_TBL_SET(HAL_SDC_PowerOff, HAL_SDC_PowerOff),
	RAM_TBL_SET(HAL_SDC_Request, HAL_SDC_Request),

	/* pm */
	RAM_TBL_SET(WakeIo_To_Gpio, WakeIo_To_Gpio),
	RAM_TBL_SET(pm_check_wakeup_irqs, pm_check_wakeup_irqs),
};

#endif /* __CONFIG_ROM */
