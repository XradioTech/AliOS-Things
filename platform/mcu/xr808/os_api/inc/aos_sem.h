#ifndef _AOS_SEM_H
#define _AOS_SEM_H

#include "k_api.h"
#include "aos/kernel.h"
#include "aos_config.h"
typedef void* os_sem_handle_t;
typedef ksem_t os_sem__t;

#if OS_SEM_DEBUG_ERROR
#define sem_debug_error(fmt,arg...)	\
	do{					\
		os_debug("[error F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define sem_debug_error(fmt,arg...)
#endif

#if OS_SEM_DEBUG_INFO
#define sem_debug_info(fmt,arg...)	\
	do{					\
		os_debug("[info F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define sem_debug_info(fmt,arg...)
#endif

os_sem_handle_t _os_sem_create_counting(uint32_t max_count, uint32_t init_num);
os_sem_handle_t _os_sem_create_binary(void);
int _os_take_sem(os_sem_handle_t sem_handle, os_tick_type_t waite_time);
int _os_sem_give(os_sem_handle_t sem_handle);
int _os_sem_delete(os_sem_handle_t sem_handle);

#endif
