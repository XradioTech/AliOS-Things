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

#include <stdio.h>
#include <sys/unistd.h>
#include "aos/hal/sd.h"
#include "driver/chip/hal_def.h"
#include "driver/chip/sdmmc/hal_sdhost.h"
#include "driver/chip/sdmmc/sdmmc.h"

#define SD_DBG_ON	0
#define SD_INF_ON	0
#define SD_WRN_ON	1
#define SD_ERR_ON	1

#define SD_LOG(flags, fmt, arg...)  \
    do {                            \
        if (flags)                  \
            printf(fmt, ##arg);     \
    } while (0)

#define SD_DBG(fmt, arg...) SD_LOG(SD_DBG_ON, "[SD DBG] "fmt, ##arg)
#define SD_INF(fmt, arg...) SD_LOG(SD_INF_ON, "[SD INF] "fmt, ##arg)
#define SD_WRN(fmt, arg...) SD_LOG(SD_WRN_ON, "[SD WRN] "fmt, ##arg)
#define SD_ERR(fmt, arg...)                         \
    do {                                            \
        SD_LOG(SD_ERR_ON, "[SD ERR] %s():%d, "fmt,  \
               __func__, __LINE__, ##arg);          \
    } while (0)

#define SDC_ID	0

static hal_sd_info_t sd_info;
static int sd_initialize = 0;

#ifdef CONFIG_DETECT_CARD
static void card_detect(uint32_t present)
{
	if (present) {
		SD_DBG("card exist\n");
	} else {
		SD_WRN("card not exist\n");
	}
}
#endif

static int sd_init()
{
	struct mmc_host *host;
	SDC_InitTypeDef sdc_param;

	SD_DBG("%s %d\n", __func__, __LINE__);

#ifdef CONFIG_DETECT_CARD
	sdc_param.cd_mode = PRJCONF_MMC_DETECT_MODE;
	sdc_param.cd_cb = card_detect;
#endif
	sdc_param.debug_mask = 0x0;
	sdc_param.dma_use = 1;
	host = HAL_SDC_Create(SDC_ID, &sdc_param);
	if (host == NULL) {
		SD_ERR("sdc create fail\n");
		return -1;
	}
	if (HAL_SDC_Init(host) == NULL) {
		SD_ERR("sdc init fail\n");
		return -1;
	}
	return 0;
}

static int sd_deinit()
{
	struct mmc_card *card = mmc_card_open(SDC_ID);
	if (card == NULL) {
		SD_ERR("card open fail\n");
		return -1;
	} else {
		if (mmc_card_present(card)) {
			mmc_card_deinit(card);
		}
		mmc_card_close(SDC_ID);
		mmc_card_delete(SDC_ID);
	}
	HAL_SDC_Deinit(SDC_ID);
	HAL_SDC_Destory(card->host);

	return 0;
}

static struct mmc_card *sd_card_scan()
{
	struct mmc_card *card;

	SDCard_InitTypeDef card_param = {0};
	card_param.debug_mask = 0x0;
	card_param.type = 2;
	if (mmc_card_create(SDC_ID, &card_param) != 0) {
		SD_ERR("mmc create fail\n");
		return NULL;
	}
	card = mmc_card_open(SDC_ID);
	if (card == NULL) {
		SD_ERR("mmc open fail\n");
		mmc_card_delete(SDC_ID);
		return NULL;
	}
	if (!mmc_card_present(card)) {
		int mmc_ret = mmc_rescan(card, SDC_ID);
		if (mmc_ret != 0) {
			SD_ERR("mmc scan fail\n");
			mmc_card_close(SDC_ID);
			mmc_card_delete(SDC_ID);
			return NULL;
		} else {
			SD_INF("mmc init\n");
		}
	}
	mmc_card_close(SDC_ID);

	return card;
}

/**@brief Initialises a sd interface
*
* @param  sd       : the interface which should be initialised
* @param  config   : sd configuration structure
*
* @return    0     : on success.
* @return    EIO   : if an error occurred with any step
*/
int32_t hal_sd_init(sd_dev_t *sd)
{
	int32_t ret;
	struct mmc_card *card = NULL;

	SD_DBG("%s %d\n", __func__, __LINE__);

	if (!sd_initialize) {
		memset(&sd_info, 0, sizeof(hal_sd_info_t));

		ret = sd_init();
		if (ret != 0)
			return -1;

		card = sd_card_scan();
		if (card == NULL)
			return -1;
	    sd_initialize = 1;
	}

	sd->port = SDC_ID;
	sd->config.bus_wide = card->bus_width;
	if (card->state & MMC_STATE_HIGHSPEED)
		sd->config.freq = 50000000;
	else
		sd->config.freq = 25000000;
	sd->priv = (void*)card;
	sd_info.blk_size = 512;
	sd_info.blk_nums = card->csd.capacity/512;

	return 0;
}


/**@brief read sd blocks
*
* @param  sd       : the interface which should be initialised
* @param  data     : pointer to the buffer which will store incoming data
* @param  blk_addr : sd blk addr
* @param  blks     : sd blks
* @param  timeout  : timeout in milisecond
* @return    0     : on success.
* @return    EIO   : if an error occurred with any step
*/
int32_t hal_sd_blks_read(sd_dev_t *sd, uint8_t *data, uint32_t blk_addr, uint32_t blks, uint32_t timeout)
{
	int32_t ret = -1;
	if (sd_initialize && sd->priv)
		ret = mmc_block_read(sd->priv, data, blk_addr, blks);
	return ret;
}

/**@brief write sd blocks
*
* @param  sd       : the interface which should be initialised
* @param  data     : pointer to the buffer which will store incoming data
* @param  blk_addr : sd blk addr
* @param  blks     : sd blks
* @param  timeout  : timeout in milisecond
* @return    0     : on success.
* @return    EIO   : if an error occurred with any step
*/
int32_t hal_sd_blks_write(sd_dev_t *sd, uint8_t *data, uint32_t blk_addr, uint32_t blks, uint32_t timeout)
{
	int32_t ret = -1;
	if (sd_initialize && sd->priv)
		ret = mmc_block_write(sd->priv, data, blk_addr, blks);
	return ret;
}

/**@brief erase sd blocks
*
* @param  sd              : the interface which should be initialised
* @param  blk_start_addr  : sd blocks start addr
* @param  blk_end_addr    : sd blocks end addr
* @return    0            : on success.
* @return    EIO          : if an error occurred with any step
*/
int32_t hal_sd_erase(sd_dev_t *sd, uint32_t blk_start_addr, uint32_t blk_end_addr)
{
	//TODO:
	return 0;
}

/**@brief get sd state
*
* @param  sd       : the interface which should be initialised
* @param  stat     : pointer to the buffer which will store incoming data
* @return    0     : on success.
* @return    EIO   : if an error occurred with any step
*/
int32_t hal_sd_stat_get(sd_dev_t *sd, hal_sd_stat *stat)
{
	*stat = SD_STAT_TRANSFER;
	return 0;
}

/**@brief get sd info
*
* @param  sd       : the interface which should be initialised
* @param  stat     : pointer to the buffer which will store incoming data
* @return    0     : on success.
* @return    EIO   : if an error occurred with any step
*/
int32_t hal_sd_info_get(sd_dev_t *sd, hal_sd_info_t *info)
{
	info->blk_size = sd_info.blk_size;
	info->blk_nums = sd_info.blk_nums;
	return 0;
}

/**@brief Deinitialises a sd interface
*
* @param  sd       : the interface which should be initialised
* @return    0     : on success.
* @return    EIO   : if an error occurred with any step
*/
int32_t hal_sd_finalize(sd_dev_t *sd)
{
	if (!sd_initialize)
		return 0;
	sd_initialize = 0;

	return sd_deinit();
}

#if 0
void sd_test()
{
	int i, ret;
	static sd_dev_t sdmmc;
	uint8_t read_buff[1024] = {0};
	uint8_t write_buff[1024];

	for (i = 0; i < 1024; i++) {
		write_buff[i] = (uint8_t)i;
		//printf("write: %d\n", write_buff[i]);
	}

	if (hal_sd_init(&sdmmc) != 0) {
		printf("hal_sd_init fail\n");
		return;
	}

	ret = hal_sd_blks_write(&sdmmc, write_buff, 2000, 2, 1);
	if (ret != 0) {
		printf("%s write fail\n", __func__);
	} else
		printf("%s write success\n", __func__);

	ret = hal_sd_blks_read(&sdmmc, read_buff, 2000, 2, 1);
	if (ret != 0) {
		printf("%s read fail\n", __func__);
	} else
		printf("%s read success\n", __func__);

	for(i=0; i < 1024; i++)
		printf("read: %d\n", read_buff[i]);

	hal_sd_finalize(&sdmmc);

	printf("test end------------\n");
}
#endif
