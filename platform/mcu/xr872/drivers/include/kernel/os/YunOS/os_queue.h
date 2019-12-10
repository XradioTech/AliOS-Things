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
#ifndef _KERNEL_OS_YUNOS_OS_QUEUE_H_
#define _KERNEL_OS_YUNOS_OS_QUEUE_H_

#include "kernel/os/YunOS/os_time.h"
#include "kernel/os/YunOS/os_common.h"

#ifdef __cplusplus
extern "C" {
#endif

#if 0
typedef struct {
    void *hdl;
} aos_hdl_t;

typedef aos_hdl_t aos_queue_t;
#endif

typedef void * QueueHandle_t;

typedef struct OS_Queue {
    QueueHandle_t   handle;
} OS_Queue_t;

typedef struct OS_Queue_XR {
	kbuf_queue_t queue;
	uint32_t item_size;
	void* msg_start;
} OS_Queue_XR_t;

static __inline int OS_QueueIsValid(OS_Queue_t *queue)
{
	OS_Queue_XR_t *queue_t = NULL;
	queue_t = queue->handle;

	return (queue_t->queue.blk_obj.obj_type == RHINO_BUF_QUEUE_OBJ_TYPE);
}

static __inline void OS_QueueSetInvalid(OS_Queue_t *queue)
{
	OS_Queue_XR_t *queue_t = NULL;
	queue_t = queue->handle;

	queue_t->queue.blk_obj.obj_type = RHINO_OBJ_TYPE_NONE;
	//queue->handle = NULL;
}

//int aos_queue_new(aos_queue_t *queue, void *buf, unsigned int size, int max_msg);
static __inline OS_Status OS_QueueCreate(OS_Queue_t *queue, uint32_t queueLen, uint32_t itemSize)
{
	void *msg_start = NULL;
	OS_Queue_XR_t *queue_t = NULL;

	msg_start = malloc(queueLen * itemSize + queueLen*4);
	if (msg_start == NULL) {
		return OS_E_NOMEM;
	}

	queue_t = malloc(sizeof(OS_Queue_XR_t));
	if (queue_t == NULL) {
		free(msg_start);
		return OS_E_NOMEM;
	}

	memset(queue_t, 0, sizeof(OS_Queue_XR_t));

	if (RHINO_SUCCESS == krhino_buf_queue_create(&queue_t->queue, "UNDEF", msg_start,
		(queueLen * itemSize + queueLen*4), itemSize)) {//RINGBUF_TYPE_DYN mode, need more sram,msglen head
		queue_t->msg_start = msg_start;
		queue_t->item_size = itemSize;
		queue->handle = queue_t;
		return OS_OK;
	} else {
		free(queue_t);
		queue_t = NULL;
		free(msg_start);
		msg_start = NULL;
		queue->handle = NULL;
		return OS_FAIL;
	}
}

static __inline OS_Status OS_QueueDelete(OS_Queue_t *queue)
{
	OS_Queue_XR_t *queue_t = NULL;
	queue_t = queue->handle;

	if ((queue != NULL) && queue->handle != NULL) {
		if (RHINO_SUCCESS == krhino_buf_queue_del(&queue_t->queue)) {
			if(queue_t->msg_start != NULL)
				free(queue_t->msg_start);

			if(queue_t != NULL)
				free(queue->handle);

			queue->handle = NULL;
			return OS_OK;
		} else {
			return OS_FAIL;
		}
	}
	return OS_OK;
}

static __inline OS_Status OS_QueueSend(OS_Queue_t *queue, const void *item, OS_Time_t waitMS)
{
	OS_Queue_XR_t *queue_t = NULL;
	queue_t = queue->handle;

	if (RHINO_SUCCESS == krhino_buf_queue_send(&queue_t->queue, item, queue_t->item_size)) {
		return OS_OK;
	} else {
		return OS_FAIL;
	}
}

static __inline OS_Status OS_QueueReceive(OS_Queue_t *queue, void *item, OS_Time_t waitMS)
{
	OS_Queue_XR_t *queue_t = NULL;
	queue_t = queue->handle;

	tick_t ticks = waitMS == OS_WAIT_FOREVER ? OS_WAIT_FOREVER : OS_MSecsToTicks(waitMS);
	size_t msg_len;

	if (RHINO_SUCCESS == krhino_buf_queue_recv(&queue_t->queue, ticks, item, &msg_len)) {
		return OS_OK;
	} else {
		return OS_E_TIMEOUT;
	}
}

static __inline OS_Status OS_MsgQueueCreate(OS_Queue_t *queue, uint32_t queueLen)
{
	return OS_QueueCreate(queue, queueLen, sizeof(void*));
}

static __inline OS_Status OS_MsgQueueDelete(OS_Queue_t *queue)
{
	return OS_QueueDelete(queue);
}

static __inline OS_Status OS_MsgQueueSend(OS_Queue_t *queue, void *msg, OS_Time_t waitMS)
{
	return OS_QueueSend(queue, &msg, waitMS);
}

static __inline OS_Status OS_MsgQueueReceive(OS_Queue_t *queue, void **msg, OS_Time_t waitMS)
{
	return OS_QueueReceive(queue, msg, waitMS);
}

#ifdef __cplusplus
}
#endif

#endif /* _KERNEL_OS_YUNOS_OS_QUEUE_H_ */
