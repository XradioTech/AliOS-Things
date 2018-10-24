/*
 * Copyright (C) 2017 XRADIO TECHNOLOGY CO., LTD. All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *    1. Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the
 *       distribution.
 *    3. Neither the name of XRADIO TECHNOLOGY CO., LTD. nor the names of
 *       its contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define __PRJ_CONFIG_XPLAYER
#ifdef __PRJ_CONFIG_XPLAYER

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

//#include "cedarx/xplayer/include/xplayer.h"
#include "xplayer.h"
#include "driver/chip/hal_codec.h"
#include "audio/manager/audio_manager.h"
#include "kernel/os/os.h"
//#include "util/atomic.h"
#include "sys/defs.h"
#include "common/framework/sys_ctrl/sys_ctrl.h"
#include "fs_ctrl.h"

#include "player_app.h"

#include "aos/yloop.h"
#include <netmgr.h>
#include <aos/kernel.h>
#include <aos/cli.h>



#define APLAYER_DEBUG(msg, arg...)		//printf("[Awplayer debug] <%s : %d> " msg "\n", __func__, __LINE__, ##arg)
#define APLAYER_INFO(msg, arg...)		printf("[Awplayer info] <%s : %d> " msg "\n", __func__, __LINE__, ##arg)
#define APLAYER_WARNING(msg, arg...)	printf("[Awplayer warning] <%s : %d> " msg "\n", __func__, __LINE__, ##arg)
#define APLAYER_ERROR(msg, arg...)		printf("[Awplayer error] <%s : %d> " msg "\n", __func__, __LINE__, ##arg)

struct tone_base
{
	int (*play)(tone_base *base, char *url);
	int (*stop)(tone_base *base);
	int (*destroy)(tone_base *base);
	player_callback cb;
	void *arg;
};

typedef struct awplayer_info
{
	char *url;
	uint32_t size;
	int pause_time;
} awplayer_info;

typedef struct awplayer
{
	player_base base;
	XPlayer *xplayer;
	SoundCtrl *sound;
	aplayer_states state;
	player_callback cb;
	awplayer_info info;
	OS_Mutex_t lock;
	uint8_t mute;
	player_modes mode;
	tone_base my_tone;
	tone_base *tone;
	int vol;
	uint16_t id;
	void *arg;
} awplayer;

static awplayer *awplayer_singleton = NULL;

static void tone_handler(event_msg *msg);
static void awplayer_handler(event_msg *msg);
static int awplayer_stop(player_base *base);
static int awplayer_seturl(player_base *base, const char *url, player_modes mode);


#define APLAYER_ID_AND_STATE(id, state)		(((id) << 16) | (state))
#define APLAYER_GET_ID(id_state) 			(((id_state) >> 16) & 0xFFFF)
#define APLAYER_GET_STATE(id_state) 		((id_state) & 0xFFFF)


static inline awplayer *get_awplayer()
{
	return awplayer_singleton;
}

static inline void set_current_time(awplayer *impl)
{
	if(XPlayerGetCurrentPosition(impl->xplayer, &impl->info.pause_time) != 0)
		APLAYER_WARNING("tell() return fail.");
}

static inline bool is_toning(awplayer *impl)
{
	return impl->tone != NULL;
}

static inline void set_awplayer_handler(awplayer *impl, void (**handler)(event_msg *msg))
{
	if (is_toning(impl))
		*handler = tone_handler;
	else
		*handler = awplayer_handler;
}

static void *wrap_realloc(void *p, uint32_t *osize, uint32_t nsize)
{
	if (p == NULL) {
		*osize = nsize;
		return malloc(nsize);
	}
	if (*osize >= nsize)
		return p;
	free(p);
	APLAYER_DEBUG("free %d, malloc %d;", *osize, nsize);
	*osize = nsize;
	return malloc(nsize);
}

static int set_url(awplayer *impl, char* pUrl)
{
    //* set url to the AwPlayer.
    if(XPlayerSetDataSourceUrl(impl->xplayer,
                 (const char*)pUrl, NULL, NULL) != 0)
    {
        APLAYER_ERROR("setDataSource() return fail.");
        return -1;
    }

	if (!strncmp(pUrl, "http://", 7)) {
	    if(XPlayerPrepareAsync(impl->xplayer) != 0)
	    {
	        APLAYER_ERROR("prepareAsync() return fail.");
	        return -1;
	    }
	} else {
		void (*handler)(event_msg *);
		set_awplayer_handler(impl, &handler);
		sys_handler_send(handler, APLAYER_ID_AND_STATE(impl->id, PLAYER_EVENTS_MEDIA_PREPARED), 10000);
	}
    return 0;
}

static int play(awplayer *impl)
{
    if(XPlayerStart(impl->xplayer) != 0)
    {
        APLAYER_ERROR("start() return fail.");
        return -1;
    }
    APLAYER_DEBUG("playing.\n");
    return 0;
}

static int reset(awplayer *impl)
{
    if(XPlayerReset(impl->xplayer) != 0)
    {
        APLAYER_ERROR("reset() return fail.");
        return -1;
    }
	impl->id++;
    return 0;
}

static void awplayer_handler_preprocess_in_once_mode(awplayer *impl, player_events evt)
{
	switch (evt)
	{
		case PLAYER_EVENTS_MEDIA_PREPARED:
			// process in awplayer_handler_preprocess_in_mode()
			break;
		case PLAYER_EVENTS_MEDIA_PLAYBACK_COMPLETE:
			awplayer_stop(&impl->base);
			break;
		case PLAYER_EVENTS_MEDIA_ERROR:
			awplayer_stop(&impl->base);
			break;
		default:
			break;
	}

}

static void awplayer_handler_preprocess_in_loop_mode(awplayer *impl, player_events evt)
{
	switch (evt)
	{
		case PLAYER_EVENTS_MEDIA_PREPARED:
			// process in awplayer_handler_preprocess_in_mode()
			break;
		case PLAYER_EVENTS_MEDIA_PLAYBACK_COMPLETE:
			awplayer_stop(&impl->base);
			awplayer_seturl(&impl->base, impl->info.url, PLAYER_MODES_LOOP);
			break;
		case PLAYER_EVENTS_MEDIA_ERROR:
			awplayer_stop(&impl->base);
			break;
		default:
			break;
	}
}

static void awplayer_handler_preprocess_in_mode(awplayer *impl, player_events evt, player_modes mode)
{
	if (mode == PLAYER_MODES_CUSTOM)
		return;

	APLAYER_INFO("!!!!!!!! evt: %d, mode: %d", (int)evt, (int)mode);

	if (evt == PLAYER_EVENTS_MEDIA_PREPARED)
	{
		if (impl->state != APLAYER_STATES_PAUSE)
			play(impl);
		if (impl->info.pause_time != 0)
		{
			if(XPlayerSeekTo(impl->xplayer, impl->info.pause_time) != 0)
				APLAYER_ERROR("seek() return fail.\n");
			APLAYER_INFO("seek to %d ms.\n", impl->info.pause_time);
			impl->info.pause_time = 0;
		}
		return;
	}

	if (mode == PLAYER_MODES_LOOP)
		awplayer_handler_preprocess_in_loop_mode(impl, evt);
	else if (mode == PLAYER_MODES_ONCE)
		awplayer_handler_preprocess_in_once_mode(impl, evt);

	return;
}

static void awplayer_handler(event_msg *msg)
{
	awplayer *impl = get_awplayer();
	player_events state = (player_events)APLAYER_GET_STATE(msg->data);

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (APLAYER_GET_ID(msg->data) != impl->id)
		goto out;
	awplayer_handler_preprocess_in_mode(impl, state, impl->mode);

	impl->cb((player_events)state, NULL, impl->arg);
out:
	OS_RecursiveMutexUnlock(&impl->lock);
}

static void tone_handler(event_msg *msg)
{
	awplayer* impl = get_awplayer();
	player_events state = (player_events)APLAYER_GET_STATE(msg->data);
	player_callback cb = impl->tone->cb;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (APLAYER_GET_ID(msg->data) != impl->id)
		goto out;

	APLAYER_INFO("!!!!!!!! evt: %d, state: %d", (int)state, (int)impl->state);

	switch (state)
	{
		case PLAYER_EVENTS_MEDIA_PREPARED:
			play(impl);
			break;
		case PLAYER_EVENTS_TONE_STOPED:
			impl->tone = NULL;
			reset(impl);
			if (impl->state != APLAYER_STATES_STOPED && impl->state != APLAYER_STATES_INIT)
				set_url(impl, impl->info.url);
			cb(PLAYER_EVENTS_TONE_STOPED, NULL, impl->tone->arg);
			break;
		case PLAYER_EVENTS_MEDIA_PLAYBACK_COMPLETE:
			impl->tone = NULL;
			reset(impl);
			if (impl->state != APLAYER_STATES_STOPED && impl->state != APLAYER_STATES_INIT)
				set_url(impl, impl->info.url);
			cb(PLAYER_EVENTS_TONE_COMPLETE, NULL, impl->tone->arg);
			break;
		case PLAYER_EVENTS_MEDIA_ERROR:
			impl->tone = NULL;
			reset(impl);
			if (impl->state != APLAYER_STATES_STOPED && impl->state != APLAYER_STATES_INIT)
				set_url(impl, impl->info.url);
			cb(PLAYER_EVENTS_TONE_ERROR, NULL, impl->tone->arg);
			break;
		default:
			break;
	}
out:
	OS_RecursiveMutexUnlock(&impl->lock);
}

static int awplayer_callback(void* pUserData, int msg, int ext1, void* param)
{
	awplayer* impl = (awplayer*)pUserData;
	void (*handler)(event_msg *msg);

	set_awplayer_handler(impl, &handler);

    switch(msg)
    {
        case AWPLAYER_MEDIA_INFO:
            switch(ext1)
            {
                case AW_MEDIA_INFO_NOT_SEEKABLE:
                    APLAYER_INFO("info: media source is unseekable.\n");
                    break;
            }
            break;

        case AWPLAYER_MEDIA_ERROR:
        	APLAYER_WARNING("open media source fail.\n"
        				    "reason: maybe the network is bad, or the music file is not good.");
			sys_handler_send(handler, APLAYER_ID_AND_STATE(impl->id, PLAYER_EVENTS_MEDIA_ERROR), 10000);
            break;

        case AWPLAYER_MEDIA_PREPARED:
			sys_handler_send(handler, APLAYER_ID_AND_STATE(impl->id, PLAYER_EVENTS_MEDIA_PREPARED), 10000);
            break;

        case AWPLAYER_MEDIA_PLAYBACK_COMPLETE:
        	APLAYER_INFO("playback complete.\n");
			sys_handler_send(handler, APLAYER_ID_AND_STATE(impl->id, PLAYER_EVENTS_MEDIA_PLAYBACK_COMPLETE), 10000);
            break;

        case AWPLAYER_MEDIA_SEEK_COMPLETE:
        	APLAYER_INFO("seek ok.\n");
            break;

        default:
        	APLAYER_DEBUG("unknown callback from AwPlayer.\n");
            break;
    }

	APLAYER_INFO("cedarx cb complete.\n");
    return 0;
}



static int awplayer_stop(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}
	reset(impl);
	impl->state = APLAYER_STATES_STOPED;
	impl->cb(PLAYER_EVENTS_MEDIA_STOPED, NULL, impl->arg);
	OS_RecursiveMutexUnlock(&impl->lock);

    return 0;
}

static int awplayer_pause(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	int ret;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}
	ret = XPlayerPause(impl->xplayer);
	impl->state = APLAYER_STATES_PAUSE;
	OS_RecursiveMutexUnlock(&impl->lock);

    return ret;
}

static int awplayer_resume(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	int ret;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}
	ret = play(impl);
	impl->info.pause_time = 0;
	impl->state = APLAYER_STATES_PLAYING;
	OS_RecursiveMutexUnlock(&impl->lock);

    return ret;
}

static int awplayer_seek(player_base *base, int ms)
{
	awplayer *impl = container_of(base, awplayer, base);
	int ret;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}

	impl->info.pause_time = ms;
	if(XPlayerSeekTo(impl->xplayer, ms) != 0)
	{
		APLAYER_ERROR("AwPlayer::seek() return fail.\n");
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}
	APLAYER_INFO("seek to %d ms.\n", ms);
	OS_RecursiveMutexUnlock(&impl->lock);

    return ret;
}

static int awplayer_seturl(player_base *base, const char *url, player_modes mode)
{
	awplayer *impl = container_of(base, awplayer, base);
	char *play_url = (char *)url;

	if (url == NULL)
		return -1;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}

	impl->state = APLAYER_STATES_PLAYING;

	APLAYER_INFO("request to play : %s", url);

	impl->mode = mode;
	impl->info.pause_time = 0;
    impl->info.url = wrap_realloc(impl->info.url, &impl->info.size, strlen(play_url) + 1);
    memcpy(impl->info.url, play_url, strlen(play_url) + 1);
	set_url(impl, impl->info.url);
	OS_RecursiveMutexUnlock(&impl->lock);

    return 0;
}

static int awplayer_tell(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	int ms;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if(XPlayerGetCurrentPosition(impl->xplayer, &ms) != 0)
	{
		APLAYER_WARNING("AwPlayer::tell() return fail.\n");
		OS_RecursiveMutexUnlock(&impl->lock);
		return 0;
	}
	APLAYER_INFO("tell to %d ms.\n", ms);
	OS_RecursiveMutexUnlock(&impl->lock);
	return ms;
}

static int awplayer_size(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	int ms;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if(XPlayerGetDuration(impl->xplayer, &ms) != 0)
	{
		APLAYER_WARNING("AwPlayer::GetDuration() return fail.\n");
		return 0;
	}
	APLAYER_INFO("size to %d ms.\n", ms);
	OS_RecursiveMutexUnlock(&impl->lock);
	return ms;
}

static int awplayer_setvol(player_base *base, int vol)
{
	awplayer *impl = container_of(base, awplayer, base);

	if (vol > 31)
	{
		APLAYER_WARNING("set vol %d larger than 31", vol);
		vol = 31;
	}
	else if (vol < 0)
	{
		APLAYER_WARNING("set vol %d lesser than 0", vol);
		vol = 0;
	}

	impl->vol = vol;
    aud_mgr_handler(AUDIO_DEVICE_MANAGER_VOLUME, AUDIO_OUT_DEV_SPEAKER, vol);
	return 0;
}

static int awplayer_getvol(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	return impl->vol;
}

static int awplayer_mute(player_base *base, bool is_mute)
{
	awplayer *impl = container_of(base, awplayer, base);
    impl->mute = (uint8_t)is_mute;
    aud_mgr_handler(AUDIO_DEVICE_MANAGER_MUTE, AUDIO_OUT_DEV_SPEAKER, is_mute);
	return 0;
}

static int awplayer_is_mute(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	return impl->mute;
}

static aplayer_states player_get_states(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);

	return impl->state;
}

static int awplayer_control(player_base *base, int command, void *data)
{
	awplayer *impl = container_of(base, awplayer, base);
	(void)impl;
	/* TODO: tbc... */
	return -1;
}

static int awplayer_playtone(player_base *base, tone_base *drv, char *url)
{
	awplayer *impl = container_of(base, awplayer, base);
	int ret;

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}
	set_current_time(impl);
	reset(impl);
	impl->tone = drv;
	ret = drv->play(drv, url);
	OS_RecursiveMutexUnlock(&impl->lock);

	/* TODO: how to resume music if use other tone drv? */

	return ret;
}

static int awplayer_stoptone(player_base *base, tone_base *drv)
{
	awplayer *impl = container_of(base, awplayer, base);

	OS_RecursiveMutexLock(&impl->lock, -1);
	if (!is_toning(impl))
	{
		OS_RecursiveMutexUnlock(&impl->lock);
		return -1;
	}
	drv->stop(drv);
	OS_RecursiveMutexUnlock(&impl->lock);

	return 0;
}

static int awplayer_tone_play(tone_base *base, char *url)
{
	awplayer *impl = container_of(base, awplayer, my_tone);
	set_url(impl, url);
    return 0;
}

static int awplayer_tone_stop(tone_base *base)
{
	awplayer *impl = container_of(base, awplayer, my_tone);

	void (*handler)(event_msg *);
	set_awplayer_handler(impl, &handler);
	sys_handler_send(handler, APLAYER_ID_AND_STATE(impl->id, PLAYER_EVENTS_TONE_STOPED), 10000);

	return 0;
}

static int awplayer_tone_destroy(tone_base *base)
{
	return 0;
}
static void awplayer_null_callback(player_events event, void *data, void *arg)
{
	APLAYER_INFO("cb event:%d", event);
}

static void awplayer_setcb(player_base *base, player_callback cb, void *arg)
{
	awplayer *impl = container_of(base, awplayer, base);
	if (!cb)
		impl->cb = awplayer_null_callback;
	else
		impl->cb = cb;
	impl->arg = arg;
}

player_base *awplayer_create()
{
	if (awplayer_singleton)
		return &awplayer_singleton->base;

	awplayer *impl = malloc(sizeof(*impl));
	if (impl == NULL)
		return NULL;
	memset(impl, 0, sizeof(*impl));

	XPlayerBufferConfig bufcfg = {	.maxStreamBufferSize = 14 * 1024,
									.maxStreamFrameCount = 18,
									.maxBitStreamBufferSize = 6 * 1024,
									.maxBitStreamFrameCount = 6,
									.maxPcmBufferSize = 24 * 1024 };

//	XPlayerSetBuffer(impl->xplayer, &bufcfg);

    impl->xplayer = XPlayerCreate();
    if(impl == NULL)
    	goto failed;

    //* set callback to player.
    XPlayerSetNotifyCallback(impl->xplayer, awplayer_callback, (void*)impl);

    //* check if the player work.
    if(XPlayerInitCheck(impl->xplayer) != 0)
    	goto failed;

SoundCtrl* SoundDeviceCreate();
    impl->sound = SoundDeviceCreate();
    XPlayerSetAudioSink(impl->xplayer, (void*)impl->sound);


    impl->base.play		 	= awplayer_seturl;
    impl->base.stop 		= awplayer_stop;
    impl->base.pause 		= awplayer_pause;
    impl->base.resume 		= awplayer_resume;
    impl->base.seek 		= awplayer_seek;
    impl->base.tell 		= awplayer_tell;
    impl->base.size 		= awplayer_size;
    impl->base.setvol 		= awplayer_setvol;
	impl->base.getvol 		= awplayer_getvol;
	impl->base.mute 		= awplayer_mute;
	impl->base.is_mute 		= awplayer_is_mute;
    impl->base.control		= awplayer_control;
    impl->base.play_tone	= awplayer_playtone;
	impl->base.stop_tone	= awplayer_stoptone;
    impl->base.set_callback	= awplayer_setcb;
	impl->base.get_status   = player_get_states;
	impl->cb 				= awplayer_null_callback;

    OS_RecursiveMutexCreate(&impl->lock);

    impl->state = APLAYER_STATES_INIT;
	impl->mode = PLAYER_MODES_LOOP;

    awplayer_singleton = impl;

    return &impl->base;

failed:
	APLAYER_ERROR("create player failed, quit.\n");
	if (impl->sound)
		free(impl->sound);
	if (impl->xplayer != NULL)
		XPlayerDestroy(impl->xplayer);
	if (impl != NULL)
		free(impl);
	return NULL;
}

void awplayer_destroy(player_base *base)
{
	awplayer *impl = container_of(base, awplayer, base);
	if (awplayer_singleton == NULL)
		return;

    APLAYER_INFO("destroy AwPlayer.\n");
	awplayer_stop(base);
	if (impl->xplayer != NULL)
		XPlayerDestroy(impl->xplayer);
	if (impl->info.url)
		free(impl->info.url);
	if (impl != NULL)
		free(impl);
	awplayer_singleton = NULL;

}

tone_base * awplayer_tone_create(player_base *player, player_callback cb, void *arg)
{
	awplayer *impl = container_of(player, awplayer, base);
	impl->my_tone.cb = cb;
    impl->my_tone.play = awplayer_tone_play;
	impl->my_tone.stop = awplayer_tone_stop;
    impl->my_tone.destroy = awplayer_tone_destroy;
	impl->my_tone.arg = arg;

	return &impl->my_tone;
}

void awtone_destroy(tone_base *base)
{
	base->destroy(base);
}

#endif
static int client_init_play;
static aos_task_t pal_task;

static void xplayer_now(void *p) {
		int ret;
#if 1
		ret = fs_mount_request(FS_MNT_DEV_TYPE_SDCARD, 0, FS_MNT_MODE_MOUNT);
		if(ret == 0)
			printf("[dxh] can  mount %d\n", ret);
		else
			printf("[dxh] can not mount %d\n", ret);
		player_base *base = awplayer_create();
		//base->play(base, "file://music/1.mp3", PLAYER_MODES_ONCE);
		base->play(base, "http://95fwno.beva.cn/dq/Fq6M-Jxu1gDrpCy6vrhwGjCQeD9v.mp3", PLAYER_MODES_ONCE);

#endif

}

static void wifi_service_event(input_event_t *event, void *priv_data)
{
    if (event->type == EV_WIFI && event->code == CODE_WIFI_ON_GOT_IP)
    {
		if (client_init_play) {
			return;
		}
		client_init_play = 1;
       // aos_task_new("pal init task", pal_sample, NULL,1024*4);
        aos_task_new_ext(&pal_task, "pal_test", xplayer_now, NULL,
                         1024*2,AOS_DEFAULT_APP_PRI-1);
    }
}

int application_start(int argc, char *argv[])
{
    //aos_post_delayed_action(1000, app_delayed_action, NULL);
    //int ret;
    printf("[dxh] player is enter\n");
#if 1  // url play
	aos_register_event_filter(EV_WIFI, wifi_service_event, NULL);
	netmgr_init();
    netmgr_start(false);
#endif
#if 0 //local play
			ret = fs_mount_request(FS_MNT_DEV_TYPE_SDCARD, 0, FS_MNT_MODE_MOUNT);
			if(ret == 0)
				printf("[dxh] can  mount %d\n", ret);
			else
				printf("[dxh] can not mount %d\n", ret);
			player_base *base = awplayer_create();
			base->play(base, "file://music/1.mp3", PLAYER_MODES_ONCE);

#endif

    aos_loop_run();

    return 0;
}


