/*
 * Copyright (C) 2015-2017 Alibaba Group Holding Limited
 */

#include <stdio.h>

#include <aos/kernel.h>
#include "net/wlan/wlan.h"


char *ap_ssid = "1234";
char *ap_pwd = "12345678";

int application_start(int argc, char *argv[])
{
    int count = 0;
    printf("nano entry here!\r\n");

	wlan_sta_set((uint8_t *)ap_ssid, strlen(ap_ssid), (uint8_t *)ap_pwd);

	wlan_sta_enable();

    while(1) {
        printf("hello world! count %d \r\n", count++);

        aos_msleep(1000);
    };
}
