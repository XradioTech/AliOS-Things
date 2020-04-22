#ifndef _AOS_COMMON_H
#define _AOS_COMMON_H

#include "k_api.h"
#include "aos/kernel.h"
#include "aos_config.h"
#include "aos_assert.h"
//#include "typedef.h"
#define os_true 1
#define os_false 0

#define OS_WAIT_FOREVER 0xfffffffful
typedef uint32_t os_tick_type_t;

void _os_delay_tick(uint32_t tick);
void _os_delay_ms(uint32_t ms);

#endif
