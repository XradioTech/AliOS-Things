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

#include "aos/hal/uart.h"
#include "aos/kernel.h"
#include "driver/chip/hal_chip.h"
#include "board_config.h"
#include "pm/pm.h"

#define MAX_UART_NUM 2
#define UART_FIFO_SIZE 128

enum _uart_status_e
{
	_UART_STATUS_CLOSED = 0,
	_UART_STATUS_OPENED,
};

typedef struct
{
	uint8_t        uart;
	uint8_t        status;
	aos_mutex_t    tx_mutex;
	kbuf_queue_t   *bufque;
} _uart_drv_t;

static _uart_drv_t _uart_drv[MAX_UART_NUM];
static UART_ID g_uart_stdout_id = UART_NUM;

#ifdef CONFIG_PM
static int8_t g_uart_stdio_suspending = 0;

__nonxip_text
static int uart_stdio_suspend(struct soc_device *dev, enum suspend_state_t state)
{
	g_uart_stdio_suspending = 1;

//#if STDOUT_WAIT_UART_TX_DONE
	if (g_uart_stdout_id < UART_NUM) {
		UART_T *uart = HAL_UART_GetInstance(g_uart_stdout_id);
		while (!HAL_UART_IsTxEmpty(uart)) { }
		HAL_UDelay(100); /* wait tx done, 100 us for baudrate 115200 */
	}
//#endif

	switch (state) {
	case PM_MODE_SLEEP:
	case PM_MODE_STANDBY:
	case PM_MODE_HIBERNATION:
		printf("a%s ok\n", __func__);
		break;
	default:
		break;
	}
	return 0;
}


/* BESURE app cpu has run now for nuart use app gpio */
__nonxip_text
static int uart_stdio_resume(struct soc_device *dev, enum suspend_state_t state)
{
	switch (state) {
	case PM_MODE_SLEEP:
	case PM_MODE_STANDBY:
	case PM_MODE_HIBERNATION:
		printf("a%s ok\n", __func__);
		break;
	default:
		break;
	}

	g_uart_stdio_suspending = 0;

	return 0;
}

static const struct soc_device_driver uart_stdout_drv = {
	.name = "uart_stdio",
	.suspend_noirq = uart_stdio_suspend,
	.resume_noirq = uart_stdio_resume,
};

static struct soc_device uart_stdio_dev = {
	.name = "uart_stdio",
	.driver = &uart_stdout_drv,
};

#define UART_STDIO_DEV (&uart_stdio_dev)
#endif
static void uart_rx_callback(void* arg)
{
	uint8_t rx_byte;
	uart_dev_t* uart = (uart_dev_t*)arg;
	_uart_drv_t *pdrv = &_uart_drv[uart->port];
	UART_T *uart_i = HAL_UART_GetInstance(uart->port);
	//uint32_t rx_cnt = HAL_UART_GetRxFIFOLevel(uart_i);
	uint32_t rx_cnt = (uint8_t)(uart_i->RX_FIFO_LEVEL);

	while (rx_cnt --) {
		rx_byte = HAL_UART_GetRxData(uart_i);
		krhino_buf_queue_send(pdrv->bufque, &rx_byte, 1);
	}
}

int32_t hal_uart_init(uart_dev_t *uart)
{
	int32_t ret = -1;
	_uart_drv_t *pdrv = &_uart_drv[uart->port];
	g_uart_stdout_id = uart->port;

	printf("%s: Humble test enter, port = %d\n", __func__, uart->port);
	if (uart != NULL) {
		_uart_drv_t *pdrv = &_uart_drv[uart->port];
		UART_InitParam board_uart_param = {
			.baudRate = 115200,
			.parity   = UART_PARITY_NONE,
			.stopBits = UART_STOP_BITS_1,
			.dataBits = UART_DATA_BITS_8,
			.isAutoHwFlowCtrl = 0
		};

		if (pdrv->status == _UART_STATUS_CLOSED) {
			// convert uart parameters
			board_uart_param.baudRate = uart->config.baud_rate;
			if (uart->config.parity == ODD_PARITY) {
				board_uart_param.parity = UART_PARITY_ODD;
			} else if (uart->config.parity == EVEN_PARITY) {
				board_uart_param.parity = UART_PARITY_EVEN;
			}
			if (uart->config.stop_bits == STOP_BITS_2) {
				board_uart_param.stopBits = UART_STOP_BITS_2;
			}
			switch (uart->config.data_width) {
				case DATA_WIDTH_5BIT:
					board_uart_param.dataBits = UART_DATA_BITS_5;
					break;
				case DATA_WIDTH_6BIT:
					board_uart_param.dataBits = UART_DATA_BITS_6;
					break;
				case DATA_WIDTH_7BIT:
					board_uart_param.dataBits = UART_DATA_BITS_7;
					break;
				case DATA_WIDTH_8BIT:
					board_uart_param.dataBits = UART_DATA_BITS_8;
					break;
				default:
					board_uart_param.dataBits = UART_DATA_BITS_8;
					break;
			}
			if (uart->config.flow_control != FLOW_CONTROL_DISABLED)
				board_uart_param.isAutoHwFlowCtrl = 1;

			ret = HAL_UART_Init(uart->port, &board_uart_param);
			if (ret == 0) {
				kstat_t stat;
				stat = krhino_buf_queue_dyn_create(&pdrv->bufque, "cli",
					(UART_FIFO_SIZE*1 + UART_FIFO_SIZE*4), 1);//RINGBUF_TYPE_DYN mode, need more sram,msglen head
				if(stat != RHINO_SUCCESS) {
					HAL_UART_DeInit(uart->port);
					return stat;
				}
				aos_mutex_new(&pdrv->tx_mutex);
				HAL_UART_EnableRxCallback(uart->port, uart_rx_callback, uart);
				pdrv->status = _UART_STATUS_OPENED;
			}
		}

#ifdef CONFIG_PM
		if (!g_uart_stdio_suspending) {
			pm_register_ops(UART_STDIO_DEV);
		}
#endif
	}

	printf("%s: exit\n", __func__);
	return ret;
}

int32_t hal_uart_finalize(uart_dev_t *uart)
{
	int32_t ret = -1;
	_uart_drv_t *pdrv = &_uart_drv[uart->port];

	printf("%s: enter, port = %d\n", __func__, uart->port);
	if (pdrv->status == _UART_STATUS_OPENED) {
#ifdef CONFIG_PM
			if (!g_uart_stdio_suspending) {
				pm_unregister_ops(UART_STDIO_DEV);
			}
#endif
		aos_mutex_free(&pdrv->tx_mutex);
		krhino_buf_queue_dyn_del(pdrv->bufque);
		ret = HAL_UART_DeInit(uart->port);
		pdrv->status = _UART_STATUS_CLOSED;
	}

	printf("%s: exit\n", __func__);
	return ret;
}

int32_t hal_uart_send(uart_dev_t *uart, const void *data, uint32_t size, uint32_t timeout)
{
	int32_t ret = -1;
	_uart_drv_t *pdrv = &_uart_drv[uart->port];

#ifdef CONFIG_PM
	if (g_uart_stdio_suspending) {
		return 0;
	}
#endif

	if (pdrv->status == _UART_STATUS_OPENED) {
		aos_mutex_lock(&pdrv->tx_mutex, timeout);
		ret = HAL_UART_Transmit_Poll(uart->port, data, size);
		aos_mutex_unlock(&pdrv->tx_mutex);
	}
	return ret;
}

int32_t hal_uart_recv_II(uart_dev_t *uart, void *data, uint32_t expect_size, uint32_t *recv_size, uint32_t timeout)
{
	kstat_t ret = -1;
	_uart_drv_t *pdrv = &_uart_drv[uart->port];

	if (pdrv->status == _UART_STATUS_OPENED) {
		uint32_t readlen  = 0;
		uint32_t totallen = 0;
		while (1) {
			ret = krhino_buf_queue_recv(pdrv->bufque, timeout, data, &readlen);
			if (ret != RHINO_SUCCESS) {
				if (recv_size) {
					*recv_size = totallen;
				}
				return -ret;
			}
			if (readlen == 0) {
				break;
			}
			totallen += readlen;
			data += readlen;
			if (totallen >=  expect_size) {
				break;
			}
		}
		if (recv_size) {
			*recv_size = totallen;
		}
	}

	return 0;
}
