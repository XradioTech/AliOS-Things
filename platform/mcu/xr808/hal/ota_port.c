#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include <errno.h>
#include "aos/hal/flash.h"
#include "sys/image.h"
#include "sys/ota.h"
#include "dm/ota/ota_agent.h"
#define IMAGE_SEQ_0   0
#define IMAGE_SEQ_1   1

#define OTA_DEBUG(...) do { \
                            printf("[ota]: "); \
                            printf(__VA_ARGS__); \
                        } while (0)

typedef struct
{
    const image_ota_param_t *iop;
    uint32_t ota_len;
    image_seq_t seq;
} ota_reboot_info_t;

static ota_reboot_info_t ota_info = {0};

hal_partition_t ota_partition = HAL_PARTITION_OTA_TEMP;

int ota_hal_init(ota_boot_param_t *param)
{
    image_seq_t seq;

    hal_logic_partition_t  part_info;
    hal_logic_partition_t *partition_info = &part_info;
    memset(partition_info, 0, sizeof(hal_logic_partition_t));
    memset(&ota_info, 0 , sizeof(ota_info));
    OTA_DEBUG("xr871_ota_init enter\n");
    ota_init();
    ota_info.iop = image_get_ota_param();
    ota_info.seq = (ota_info.iop->running_seq + 1) % IMAGE_SEQ_NUM;
    seq = ota_info.seq;
    OTA_DEBUG("image seq = %d\n", ota_info.seq);
    OTA_DEBUG("ota seq %d, flash %u, addr %#x",seq,ota_info.iop->flash[seq], ota_info.iop->addr[seq]);

    if (seq == IMAGE_SEQ_1) {
	ota_partition = HAL_PARTITION_OTA_TEMP;
    	hal_flash_info_get(HAL_PARTITION_OTA_TEMP,  partition_info);
    	hal_flash_erase(HAL_PARTITION_OTA_TEMP, 0 ,partition_info->partition_length);
    } else if (seq == IMAGE_SEQ_0) {
        ota_partition = HAL_PARTITION_APPLICATION;
        hal_flash_info_get(HAL_PARTITION_APPLICATION, partition_info);
        hal_flash_erase(HAL_PARTITION_APPLICATION, 0 ,partition_info->partition_length);
    }
    ota_info.ota_len = 0;
    return 0;
}


int ota_hal_write(unsigned int *off, char *in_buf, unsigned int in_buf_len)
{
    int ret = 0;
    unsigned int _off_set = 0;
    _off_set = ota_info.ota_len;
    ret = hal_flash_write(ota_partition, &_off_set, in_buf, in_buf_len);
    ota_info.ota_len += in_buf_len;

    OTA_DEBUG("w &_off_set 0x %08x, %d, ret %d\n", _off_set ,ota_info.ota_len, ret);
    return ret;
}

int ota_hal_read(unsigned int *off, char *out_buf, unsigned int out_buf_len)
{
    uint32_t temp;

    temp = *off;
    hal_flash_read(ota_partition, &temp, out_buf, out_buf_len);

    *off += out_buf_len;
    return 0;
}

int ota_hal_boot(ota_boot_param_t *param)
{
    OTA_DEBUG("xr871 set boot\n");
    ota_set_get_size(ota_info.ota_len);
    if (image_check_sections(ota_info.seq) == IMAGE_INVALID) {
	OTA_DEBUG("ota check image failed");
	return -1;
    }

    OTA_DEBUG("OTA: finish checking image.");
    // verify
    if (ota_verify_image(OTA_VERIFY_NONE, NULL)  != OTA_STATUS_OK) {
	OTA_DEBUG("OTA http verify image failed");
	return -1;
    }
    OTA_DEBUG("ota upgrade success");
    hal_reboot();
    return 0;
}

int ota_hal_rollback(void)
{
    int ret = 0;
    unsigned int offset = 0;
    ota_boot_param_t param;
    memset(&param, 0, sizeof(ota_boot_param_t));
    ret = hal_flash_read(HAL_PARTITION_PARAMETER_1, &offset, &param, sizeof(ota_boot_param_t));
    if(ret < 0) {
        OTA_DEBUG("rollback err:%d", ret);
        return ret;
    }
    if((param.boot_count != 0) && (param.boot_count != 0xff)) {
        param.upg_flag = 0;
        param.boot_count = 0; /*Clear bootcount to avoid rollback*/
        ret = ota_update_parameter(&param);
    }
    if(ret != 0) {
        OTA_DEBUG("rollback err:%d", ret);
    }
    return ret;
}

const char *ota_hal_version(unsigned char dev_type, char* dn)
{
    if(dev_type > 0) {
        return "v1.0.0-20180101-1000";//SYSINFO_APP_VERSION;
    }
    else {
        return SYSINFO_APP_VERSION;
    }
}
