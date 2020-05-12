#include <aos/cli.h>
#include "driver/chip/hal_chip.h"
#include "common/cmd/cmd_iperf.h"
#include "common/cmd/cmd_defs.h"

static void handle_xriperf_cmd(char *pwbuf, int blen, int argc, char **argv)
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
		status = cmd_iperf_exec(cmd_buf);
		if(status != CMD_STATUS_OK) {
			printf("%s,err status %d\n", __func__, status);
		}
	} else {
		printf("%s, param is not correct\n", __func__);
	}

}

static struct cli_command ncmd = {
    .name = "xriperf",
    .help = "iperf tcp udp",
    .function = handle_xriperf_cmd,
};

void cli_cmd_add_iperf(void)
{
	aos_cli_register_command(&ncmd);
}
