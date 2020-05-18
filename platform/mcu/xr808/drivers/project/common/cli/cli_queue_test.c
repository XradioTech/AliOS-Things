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

#include <aos/cli.h>
#include "kernel/os/os.h"

static OS_Queue_t rx_queue_test;
static uint16_t rx_queue_size_test = 4;
static int msg_recv_flg;
static OS_Thread_t _rx_queue_thread;
static OS_Thread_t _tx_queue_thread;
static void rx_proc(void *argument)
{
	int ret = 0;
	//uint32_t timeout = OS_WAIT_FOREVER;
	uint32_t timeout = 100;
	int *msg = NULL;
	while (1) {
		ret = OS_MsgQueueReceive(&rx_queue_test, (void **)&msg, timeout);
		if ((ret != 0) || (msg == NULL)) {
			printf("rx timeout or msg null %d\n", ret);
		}
		printf("rx ret %d, msg %d\n", ret, *msg);
		msg_recv_flg = 1;
	}
}
static void tx_proc(void *argument)
{
	int ret = 0;
	uint32_t timeout = OS_WAIT_FOREVER;
	int msg_item = 4;
	int *msg = &msg_item;

	ret = OS_MsgQueueSend(&rx_queue_test, (void *)msg, 0);
	printf("tx1 ret %d, msg %d\n", ret, *msg);
	printf("sleep  start\n");
	OS_MSleep(1500);
	printf("sleep  over\n");
	while (true) {
		if (msg_recv_flg) {
			ret = OS_MsgQueueSend(&rx_queue_test, (void *)msg, 0);
			printf("tx2 ret %d, msg %d\n", ret, *msg);
			msg_recv_flg = 0;
		}
		OS_MSleep(50);
	}
}

void queue_test(void)
{
	int ret = 0;
	ret = OS_MsgQueueCreate(&rx_queue_test, rx_queue_size_test);
	printf("ret %d, %d\n", ret, __LINE__);
	ret = OS_ThreadCreate(&_rx_queue_thread, "rx_proc_test", rx_proc, NULL, 32, 2048);
	printf("ret %d, %d\n", ret, __LINE__);
	ret = OS_ThreadCreate(&_tx_queue_thread, "tx_proc_test", tx_proc, NULL, 32, 2048);
	printf("ret %d, %d\n", ret, __LINE__);
}

static struct cli_command ncmd = {
    .name = "queue_test",
    .help = "queue_test",
    .function = queue_test,
};

void cli_cmd_add_queue_test(void)
{
    aos_cli_register_command(&ncmd);
}
