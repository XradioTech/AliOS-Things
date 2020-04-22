#ifndef _AOS_QUEUE_H
#define _AOS_QUEUE_H

#include "k_api.h"
#include "aos/kernel.h"
#include "aos_config.h"
typedef void* os_queue_handle_t;
typedef kbuf_queue_t os_queue__t;

#if OS_QUEUE_DEBUG_ERROR
#define queue_debug_error(fmt,arg...)	\
	do{					\
		os_debug("[error F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define queue_debug_error(fmt,arg...)
#endif

#if OS_QUEUE_DEBUG_INFO
#define queue_debug_info(fmt,arg...)	\
	do{					\
		os_debug("[info F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define queue_debug_info(fmt,arg...)
#endif

os_queue_handle_t _os_queue_create(uint32_t queue_len, uint32_t item_size);
int _os_queue_send(os_queue_handle_t queue_handle, void *send_buf, os_tick_type_t wait_time);
int _os_queue_recive(os_queue_handle_t queue_handle, void *recv_buf, os_tick_type_t wait_time);
int _os_queue_delete(os_queue_handle_t queue_handle);
int _os_queue_used_nums(os_queue_handle_t queue_handle);
int _os_queue_free_nums(os_queue_handle_t queue_handle);
int _os_queue_peek(os_queue_handle_t queue_handle, void *recv_buf, os_tick_type_t wait_time);

#endif
