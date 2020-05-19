#ifndef _AOS_TASK_H
#define _AOS_TASK_H

#include "k_api.h"
#include "aos/kernel.h"
#include "aos_config.h"
typedef void* os_task_handle_t;
typedef ktask_t os_task_t;
#define task_debug printf

#if OS_TASK_DEBUG_ERROR
#define task_debug_error(fmt,arg...)	\
	do{					\
		task_debug("[error F:%s L:%d]",__FUNCTION__,__LINE__);	\
		task_debug(fmt,##arg);	\
	  }while(0);
#else
#define task_debug_error(fmt,arg...)
#endif

#if OS_TASK_DEBUG_INFO
#define task_debug_info(fmt,arg...)	\
	do{					\
		task_debug("[info F:%s L:%d]",__FUNCTION__,__LINE__);	\
		task_debug(fmt,##arg);	\
	  }while(0);
#else
#define task_debug_info(arg...)
#endif

typedef void (*os_task_entry_t)(void *arg);

int _os_task_create(os_task_entry_t entry, const char *name, size_t stack_size, void *arg, uint8_t pri, os_task_handle_t *task_handle);
int _os_task_pri_change(os_task_handle_t task_handle, uint32_t new_pri);
int _os_task_pri_get(os_task_handle_t task_handle);
os_task_handle_t _os_cur_task_handle(void);
char *_os_get_task_name(os_task_handle_t task_handle);
int _os_task_delete(os_task_handle_t task_handle);
int _os_task_yield(void);

#endif
