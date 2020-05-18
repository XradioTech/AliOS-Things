#ifndef _AOS_MEM_H
#define _AOS_MEM_H

#include "aos/kernel.h"
#include "aos_config.h"

void *_os_malloc(uint32_t size);
void *_os_realloc(void *ptr, uint32_t size);
void *_os_calloc(size_t n, uint32_t size);
void _os_free(void *ptr);
void os_print_heap();

#endif