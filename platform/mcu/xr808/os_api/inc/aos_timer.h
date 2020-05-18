#ifndef _AOS_TIMER_H
#define _AOS_TIMER_H

#include "k_api.h"
#include "aos/kernel.h"
#include "aos_config.h"

typedef void (*TimerCallbackFunction_t)( void* xTimer );

typedef struct
{
    TimerCallbackFunction_t cb;
    void *arg;
}espos_adapter_timer;

typedef void* os_timer_handle_t;
typedef ktimer_t os_timer__t;
#define timer_debug printf

typedef void (*timer_callback_t)(void *xTimer, void *arg);

typedef size_t espos_size_t;
typedef espos_size_t espos_tick_t;
typedef uint32_t espos_opt_t;


#if OS_TIMER_DEBUG_ERROR
#define timer_debug_error(fmt,arg...)	\
	do{														\
		os_debug("[error F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define timer_debug_error(fmt,arg...)
#endif

#if OS_TIMER_DEBUG_INFO
#define timer_debug_info(fmt,arg...)	\
	do{					\
		os_debug("[info F:%s L:%d]",__FUNCTION__,__LINE__);	\
		os_debug(fmt,##arg);	\
	  }while(0);
#else
#define timer_debug_info(fmt,arg...)
#endif

os_timer_handle_t espos_timer_create_static_adapter(
	ktimer_t *ptmr,
	const char *name,
	TimerCallbackFunction_t cb,
	void *arg,
	espos_tick_t period_ticks,
	espos_opt_t opt);

int espos_timer_start(os_timer_handle_t timer_handle);
int espos_timer_stop(os_timer_handle_t timer_handle);
int espos_timer_delete(os_timer_handle_t timer_handle);
int os_timer_period_change(os_timer_handle_t timer_handle, uint32_t new_period, uint32_t waite_time, uint32_t uxAutoReload);
int os_timer_reset(os_timer_handle_t timer_handle);

#endif
