/*
 * Copyright (c) 2014-2016 Alibaba Group. All rights reserved.
 * License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "aos/kernel.h"
#include <aos/yloop.h>
#include "netmgr.h"
#include "ulog/ulog.h"

#ifdef WITH_SAL
#include <atcmd_config_module.h>
#endif

#ifdef CSP_LINUXHOST
#include <signal.h>
#endif

static char linkkit_started = 0;

extern void iotx_main(void *p);

static void wifi_service_event(input_event_t *event, void *priv_data)
{
    if (event->type != EV_WIFI) {
        return;
    }

    if (event->code != CODE_WIFI_ON_GOT_IP) {
        return;
    }

    netmgr_ap_config_t config;
    memset(&config, 0, sizeof(netmgr_ap_config_t));
    netmgr_get_ap_config(&config);
    LOG("wifi_service_event config.ssid %s", config.ssid);
    if (strcmp(config.ssid, "xiaomi") == 0 || strcmp(config.ssid, "xiaomi") == 0) {
        //clear_wifi_ssid();
        return;
    }

    if (!linkkit_started) {
        aos_task_new("iotx_example",iotx_main,NULL,1024*10);
        linkkit_started = 1;
    }
}

static void cloud_service_event(input_event_t *event, void *priv_data)
{
    if (event->type != EV_YUNIO) {
        return;
    }

    LOG("cloud_service_event %d", event->code);

    if (event->code == CODE_YUNIO_ON_CONNECTED) {
        LOG("user sub and pub here");
        return;
    }

    if (event->code == CODE_YUNIO_ON_DISCONNECTED) {
    }
}


int application_start(int argc, char **argv)
{
#ifdef CSP_LINUXHOST
    signal(SIGPIPE, SIG_IGN);
#endif

#ifdef WITH_SAL
    sal_device_config_t data = {0};

    data.uart_dev.port = 1;
    data.uart_dev.config.baud_rate = 115200;
    data.uart_dev.config.data_width = DATA_WIDTH_8BIT;
    data.uart_dev.config.parity = NO_PARITY;
    data.uart_dev.config.stop_bits  = STOP_BITS_1;
    data.uart_dev.config.flow_control = FLOW_CONTROL_DISABLED;
    data.uart_dev.config.mode = MODE_TX_RX;

    sal_add_dev(NULL, &data);
    sal_init();
#endif

    aos_set_log_level(AOS_LL_DEBUG);

    netmgr_init();
    //aos_register_event_filter(EV_KEY, linkkit_key_process, NULL);
    aos_register_event_filter(EV_WIFI, wifi_service_event, NULL);
    aos_register_event_filter(EV_YUNIO, cloud_service_event, NULL);

#ifdef CONFIG_AOS_CLI
    //aos_cli_register_command(&resetcmd);
    //aos_cli_register_command(&ncmd);
#endif
    netmgr_start(false);
    //aos_task_new("netmgr", start_netmgr, NULL, 4096);

    aos_loop_run();

    return 0;
}
