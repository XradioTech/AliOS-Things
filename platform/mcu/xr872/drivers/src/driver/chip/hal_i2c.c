/**
  * @file  hal_i2c.c
  * @author  XRADIO IOT WLAN Team
  */

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

#ifdef __CONFIG_CPU_SUPPORT_349MHZ
#ifdef __CONFIG_ROM

#include "driver/chip/hal_i2c.h"
#include "hal_base.h"

extern HAL_Status __HAL_I2C_Init(I2C_ID i2cID, const I2C_InitParam *initParam);

extern I2C_T *gI2CInstance[I2C_NUM];

static __inline I2C_T *I2C_GetI2CInstance(I2C_ID i2cID)
{
	return gI2CInstance[i2cID];
}

static __inline void I2C_DisableBus(I2C_T *i2c)
{
	HAL_CLR_BIT(i2c->I2C_CTRL, I2C_WR_CTRL_MASK | I2C_BUS_EN_BIT);
}

static __inline void I2C_EnableBus(I2C_T *i2c)
{
	HAL_MODIFY_REG(i2c->I2C_CTRL, I2C_WR_CTRL_MASK, I2C_BUS_EN_BIT);
}

static __inline void I2C_SetClockReg(I2C_T *i2c, uint8_t clkM, uint8_t clkN)
{
	HAL_MODIFY_REG(i2c->I2C_CLK_CTRL, I2C_CLK_M_MASK | I2C_CLK_N_MASK,
				   (clkM << I2C_CLK_M_SHIFT) | (clkN << I2C_CLK_N_SHIFT));
}

static __inline void I2C_SetClockFreq(I2C_T *i2c, uint32_t clockFreq)
{
	uint8_t	clkM 	= 0;
	uint8_t	clkN 	= 0;
	uint8_t	pow2N	= 1;

	uint32_t	APBClkDiv10;
	uint32_t	div;
	uint32_t	clockReal;

	APBClkDiv10 = HAL_GetAPBClock() / 10;
	div = APBClkDiv10 / clockFreq;
	if (div == 0) {
		I2C_SetClockReg(i2c, clkM, clkN);
		return;
	}

	while (clkN <= I2C_CLK_N_MAX) {
		clkM = div / pow2N - 1;
		while (clkM <= I2C_CLK_M_MAX) {
			clockReal = APBClkDiv10 / pow2N / (clkM + 1);
			if (clockReal <= clockFreq) {
				I2C_SetClockReg(i2c, clkM, clkN);
				return;
			} else {
				clkM++;
			}
		}
		clkN++;
		pow2N *= 2;
	}
}

/**
 * @brief Initialize the I2C according to the specified parameters
 * @param[in] i2cID ID of the specified I2C
 * @param[in] initParam Pointer to I2C_InitParam structure
 * @retval HAL_Status, HAL_OK on success
 */
HAL_Status HAL_I2C_Init(I2C_ID i2cID, const I2C_InitParam *initParam)
{
	I2C_T *i2c;
	HAL_Status status;

	status = __HAL_I2C_Init(i2cID, initParam);

	if ((status == HAL_OK) &&
	    ((CCM->CPU_BUS_CLKCFG & CCM_APB_CLK_SRC_MASK) == CCM_APB_CLK_SRC_AHB2CLK) &&
	    (HAL_GET_BIT(PRCM->SYS_CLK1_CTRL, PRCM_SYS_CLK_FACTORM_MASK) == PRCM_SYS_CLK_FACTORM_5_5)) {
		i2c = I2C_GetI2CInstance(i2cID);
		I2C_DisableBus(i2c);
		I2C_SetClockFreq(i2c, initParam->clockFreq);
		I2C_EnableBus(i2c);
	}

	return status;
}

#endif /* __CONFIG_ROM */
#endif /* __CONFIG_CPU_SUPPORT_349MHZ */
