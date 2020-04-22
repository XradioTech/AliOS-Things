#ifndef _AOS_EVENT_H
#define _AOS_EVENT_H

#include "k_api.h"
#include "aos/kernel.h"
#include "aos_config.h"
//#include "typedef.h"
typedef void* os_event_handle_t;
typedef kevent_t os_event__t;
typedef  uint32_t os_event_bits_t;
#if OS_EVENT_DEBUG_ERROR
#define event_debug_error(fmt,arg...)	\
	do{					\
		os_debug("[error F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define event_debug_error(fmt,arg...)
#endif

#if OS_EVENT_DEBUG_INFO
#define event_debug_info(fmt,arg...)	\
	do{					\
		os_debug("[info F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define event_debug_info(fmt,arg...)
#endif

os_event_handle_t _os_event_group_create(void);
void _os_event_group_delete(os_event_handle_t event_handle);
int _os_event_set(os_event_handle_t event_handle, os_event_bits_t set_bits);
int _os_event_clear(os_event_handle_t event_handle, os_event_bits_t set_bits);
int _os_event_wait_bits(os_event_handle_t event_handle, os_event_bits_t wait_bits, int wait_option, int clear_option, os_event_bits_t *read_flags, os_tick_type_t block_time);

#endif
