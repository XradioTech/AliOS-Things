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
#ifndef _KERNEL_OS_YUNOS_OS_TIMER_H_
#define _KERNEL_OS_YUNOS_OS_TIMER_H_

#include "kernel/os/YunOS/os_common.h"

#ifdef __cplusplus
extern "C" {
#endif

#if 0
typedef struct {
    void *hdl;
} aos_hdl_t;

typedef aos_hdl_t aos_timer_t;
#endif

typedef enum {
	OS_TIMER_ONCE		= 0,
	OS_TIMER_PERIODIC	= 1
} OS_TimerType;

typedef void (*OS_TimerCallback_t)(void *arg);

typedef void * TimerHandle_t;

typedef struct OS_Timer {
    TimerHandle_t           handle;
} OS_Timer_t;

typedef struct OS_Timer_XR{
	ktimer_t *handle; /* must be first */
	OS_TimerType type;
	OS_TimerCallback_t cb;
	void *ctx;
} OS_Timer_XR_t;

static __inline void krhino_timer_cb(void *timer, void *arg)
{
	OS_Timer_XR_t *tmpTimerCtx;
	tmpTimerCtx = (OS_Timer_XR_t *)arg;
	tmpTimerCtx->cb(tmpTimerCtx->ctx);
}

static __inline OS_Status OS_TimerCreate(OS_Timer_t *timer, OS_TimerType type,
                         OS_TimerCallback_t cb, void *ctx, OS_Time_t periodMS)
{
	OS_Timer_XR_t *timer_t;

	sys_time_t first = krhino_ms_to_ticks((uint32_t)periodMS);
	sys_time_t round = type == OS_TIMER_ONCE ? 0 : first;// round:first value;non round: 0

    timer_t = krhino_mm_alloc(sizeof(OS_Timer_XR_t));
    if (timer_t == NULL) {
        return OS_E_NOMEM;
    }

	memset(timer_t, 0, sizeof(OS_Timer_XR_t));

	if (RHINO_SUCCESS == krhino_timer_dyn_create(&timer_t->handle, "timer", krhino_timer_cb,
													first, round, timer_t, 0)) { //auto_run disable
		//timer->handle = (void*)timer_obj;
		timer_t->ctx = ctx;
		timer_t->cb = cb;
		timer_t->type = type;
		timer->handle = timer_t;
		return OS_OK;
	} else {
		krhino_mm_free(timer_t);
		timer->handle = NULL;
		return OS_FAIL;
	}
}

static __inline OS_Status OS_TimerDelete(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if (RHINO_SUCCESS == krhino_timer_dyn_del(timer_t->handle)) {
		krhino_mm_free(timer_t);
		timer->handle = NULL;
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline OS_Status OS_TimerStart(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if (RHINO_SUCCESS == krhino_timer_start(timer_t->handle)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}

}

static __inline OS_Status OS_TimerChangePeriod(OS_Timer_t *timer, OS_Time_t periodMS)
{

	//int aos_timer_change(aos_timer_t *timer, int ms)

	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	tick_t first = krhino_ms_to_ticks((uint32_t)periodMS);
	tick_t round = timer_t->type == OS_TIMER_ONCE ? 0 : first;
	if (RHINO_SUCCESS == krhino_timer_change(timer_t->handle, first, round)) {
		if (RHINO_SUCCESS == krhino_timer_start(timer_t->handle)) {  //need to restart
			return OS_OK;
		} else {
			return OS_FAIL;
		}
	} else {
		return OS_FAIL;
	}

}

static __inline OS_Status OS_TimerStop(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if (RHINO_SUCCESS == krhino_timer_stop(timer_t->handle)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline int OS_TimerIsValid(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if(timer_t == NULL) {
		return 0;
	}

	if(timer_t->handle == NULL) {
		return 0;
	}

	return 1;
}

static __inline void OS_TimerSetInvalid(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);
	//timer_t->handle= NULL;
	timer->handle = OS_INVALID_HANDLE;
}

static __always_inline int OS_TimerIsActive(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);
	return (timer_t->handle->timer_state == TIMER_ACTIVE);
}

static __inline void *OS_TimerGetContext(void *arg)
{
	return arg;
}

#ifdef __cplusplus
}
#endif

#endif /* _KERNEL_OS_YUNOS_OS_TIMER_H_ */
