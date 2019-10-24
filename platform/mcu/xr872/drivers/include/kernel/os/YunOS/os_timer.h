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
	aos_timer_t timer;
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
    timer_t = aos_malloc(sizeof(OS_Timer_XR_t));
    if (timer_t == NULL) {
        return OS_E_NOMEM;
    }

	memset(timer_t, 0, sizeof(OS_Timer_XR_t));
	//int aos_timer_new(aos_timer_t *timer, void (*fn)(void *, void *), void *arg,
					//  int ms, int repeat);

	if(aos_timer_new(&(timer_t->timer), krhino_timer_cb, timer_t,
							periodMS, type) == 0) {
		timer_t->ctx = ctx;
		timer_t->type = type;
		timer_t->cb = cb;
		timer->handle = timer_t;
		return OS_OK;
	} else {
		aos_free(timer_t);
		timer->handle = NULL;
		return OS_FAIL;
	}
}

static __inline OS_Status OS_TimerDelete(OS_Timer_t *timer)
{
	//void aos_timer_free(aos_timer_t *timer)
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	aos_timer_free(&(timer_t->timer));
	timer_t->cb = NULL;
	aos_free(timer_t);
	timer->handle = NULL;
	return OS_OK;
}

static __inline OS_Status OS_TimerStart(OS_Timer_t *timer)
{
	//int aos_timer_start(aos_timer_t *timer)
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if (RHINO_SUCCESS == aos_timer_start(&(timer_t->timer))) {
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
	if (RHINO_SUCCESS == krhino_timer_change(timer_t->timer.hdl, first, round)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline OS_Status OS_TimerStop(OS_Timer_t *timer)
{
	//int aos_timer_stop(aos_timer_t *timer)

	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if (RHINO_SUCCESS == aos_timer_stop(&(timer_t->timer))) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline int OS_TimerIsValid(OS_Timer_t *timer)
{
	//return (timer->handle != OS_INVALID_HANDLE);

	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	if(timer_t == NULL) {
		return 0;
	}

	if(timer_t->timer.hdl == NULL) {
		return 0;
	}

	return 1;
}

static __inline void OS_TimerSetInvalid(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);
	timer_t->timer.hdl = NULL;
	timer->handle = OS_INVALID_HANDLE;
}

static __always_inline int OS_TimerIsActive(OS_Timer_t *timer)
{
	OS_Timer_XR_t *timer_t;
	timer_t = (OS_Timer_XR_t *)(timer->handle);

	//ktimer_t *ktimer = timer->handle;
	return (((ktimer_t *)(timer_t->timer.hdl))->timer_state == TIMER_ACTIVE);
}

static __inline void *OS_TimerGetContext(void *arg)
{
	return arg;
}

#ifdef __cplusplus
}
#endif

#endif /* _KERNEL_OS_YUNOS_OS_TIMER_H_ */
