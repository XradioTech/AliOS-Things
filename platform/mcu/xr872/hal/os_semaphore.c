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
#include "kernel/os/YunOS/os_common.h"
#include "kernel/os/os_time.h"

typedef struct OS_Semaphore {
	ksem_t sem;
	uint32_t count;
	uint32_t max_count;
} OS_Semaphore_t;

OS_Status OS_SemaphoreWait(OS_Semaphore_t *sem, OS_Time_t waitMS)
{
	tick_t ticks = waitMS == OS_WAIT_FOREVER ? OS_WAIT_FOREVER : OS_MSecsToTicks(waitMS);
	OS_Status ret;
	kstat_t sta;
	uint32_t time_tick = OS_GetTicks();

	if (sem == NULL) {
		return OS_FAIL;
	}

	sta = krhino_sem_take(&sem->sem, ticks);
	if(sta == RHINO_SUCCESS) {
		if (sem->count)
			sem->count--;
		ret = OS_OK;
	} else {
		ret = OS_E_TIMEOUT;
	}

	return ret;
}

//__nonxip_text
OS_Status OS_SemaphoreRelease(OS_Semaphore_t *sem)
{
	if (sem->max_count == 1 && sem->count == 1) {
		return OS_FAIL;
	}
	if (RHINO_SUCCESS == krhino_sem_give(&sem->sem)) {
		if (sem->count < sem->max_count)
			sem->count++;
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

