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
#ifndef _KERNEL_OS_YUNOS_OS_MUTEX_H_
#define _KERNEL_OS_YUNOS_OS_MUTEX_H_

#include "kernel/os/YunOS/os_common.h"

#ifdef __cplusplus
extern "C" {
#endif

#if 0
typedef aos_hdl_t aos_mutex_t;
typedef struct {
    void *hdl;
} aos_hdl_t;
#endif

typedef void* SemaphoreHandle_t;

typedef struct OS_Mutex {
	SemaphoreHandle_t	handle;
} OS_Mutex_t;

static __inline OS_Status OS_MutexCreate(OS_Mutex_t *mutex)
{
	//aos_mutex_new(aos_mutex_t *)mutex)
	if (RHINO_SUCCESS == aos_mutex_new((aos_mutex_t *)mutex)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline OS_Status OS_MutexDelete(OS_Mutex_t *mutex)
{

	//void aos_mutex_free(aos_mutex_t *mutex)
	aos_mutex_free((aos_mutex_t *)mutex);
	return OS_OK;
#if 0
	if (RHINO_SUCCESS == krhino_mutex_del(&mutex->mutex)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
#endif
}

static __inline OS_Status OS_MutexLock(OS_Mutex_t *mutex, OS_Time_t waitMS)
{
	//tick_t ticks = OS_MSecsToTicks(waitMS);
	//int aos_mutex_lock(aos_mutex_t *mutex, unsigned int timeout)

	if (RHINO_SUCCESS == aos_mutex_lock((aos_mutex_t *)mutex, waitMS)) {
		return OS_OK;
	} else {
		return OS_E_TIMEOUT;
	}
}

static __inline OS_Status OS_MutexUnlock(OS_Mutex_t *mutex)
{
	//int aos_mutex_unlock(aos_mutex_t *mutex)

	if (RHINO_SUCCESS == aos_mutex_unlock((aos_mutex_t *)mutex)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline OS_Status OS_RecursiveMutexCreate(OS_Mutex_t *mutex)
{
	return OS_MutexCreate(mutex);
}

static __inline OS_Status OS_RecursiveMutexDelete(OS_Mutex_t *mutex)
{
	return OS_MutexDelete(mutex);
}

static __inline OS_Status OS_RecursiveMutexLock(OS_Mutex_t *mutex, OS_Time_t waitMS)
{
	return OS_MutexLock(mutex, waitMS);
}

static __inline OS_Status OS_RecursiveMutexUnlock(OS_Mutex_t *mutex)
{
	return OS_MutexUnlock(mutex);
}

static __inline int OS_MutexIsValid(OS_Mutex_t *mutex)
{
	return aos_mutex_is_valid((aos_mutex_t *)mutex);

	//return (mutex->mutex.blk_obj.obj_type == RHINO_MUTEX_OBJ_TYPE);
}

static __inline void OS_MutexSetInvalid(OS_Mutex_t *mutex)
{
	aos_mutex_t *mutex_t = NULL;
	mutex_t = (aos_mutex_t *)mutex;
	mutex_t->hdl = NULL;
	//mutex->mutex.blk_obj.obj_type = RHINO_OBJ_TYPE_NONE;
}

/**
 * @brief Get the mutex object's owner
 * @note A mutex object's owner is a thread that locks the mutex
 * @param[in] mutex Pointer to the mutex object
 * @return The handle of the thread that locks the mutex object.
 *         NULL when the mutex is not locked by any thread.
 */
static __always_inline void *OS_MutexGetOwner(OS_Mutex_t *mutex)
{
	aos_mutex_t *mutex_t;
	mutex_t = (aos_mutex_t *)mutex;
	return (((kmutex_t *)(mutex_t->hdl))->mutex_task);
}

#ifdef __cplusplus
}
#endif

#endif /* _KERNEL_OS_YUNOS_OS_MUTEX_H_ */
