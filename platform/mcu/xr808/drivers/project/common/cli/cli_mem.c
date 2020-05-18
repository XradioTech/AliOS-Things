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
#include "driver/chip/hal_chip.h"
#include "common/cmd/cmd_mem.h"
#include "common/cmd/cmd_defs.h"

static void handle_mem_cmd(char *pwbuf, int blen, int argc, char **argv)
{
	char cmd_buf[255];
	int i;
	enum cmd_status status;
	memset(cmd_buf, 0, sizeof(cmd_buf));
	if(argc > 1) {
		for (i=1; i<argc; i++) {
			if (i == 1) {
				snprintf(cmd_buf, strlen(argv[1]) + 1, "%s", argv[i]);
			} else {
			     snprintf(cmd_buf + strlen(cmd_buf),
                     strlen(cmd_buf) + strlen(argv[i]) + 1, " %s", argv[i]);
			}
		}
		status = cmd_mem_exec(cmd_buf);
		if(status != CMD_STATUS_ACKED) {
			printf("%s,err status %d\n", __func__, status);
		}
	} else {
		printf("%s, param is not correct\n", __func__);
	}
}

static struct cli_command ncmd = {
    .name = "mem",
    .help = "mem [read addr | write addr val | dump addr len]",
    .function = handle_mem_cmd,
};

void cli_cmd_add_mem(void)
{
	aos_cli_register_command(&ncmd);
}
