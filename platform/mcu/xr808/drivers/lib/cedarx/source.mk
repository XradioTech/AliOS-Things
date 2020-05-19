ifeq ($(BUILD_MP3), y)
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/ARMobj/DecodeMP3_AC320obj.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/bit.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/bitstream.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/buffers.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/dct32.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/dequant.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/dqchan.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/FastFseek.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/function.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/huffman.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/hufftabs.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/imdct.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/mp3dec.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/mp3tabs.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/polyphase.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/scalfact.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/stproc.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/subband.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP3/trigtabs.c

XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP12/stream.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP12/layer12.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP12/pvmp12_framedecoder.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/codec/mp3/libMP12/synth.c
endif

ifeq ($(BUILD_MP3INF), y)
XR872_SOURCE_FILES += ../../../lib/cedarx/src/audio/extinf/mp3/*.c
endif

ifeq ($(BUILD_CEDARX), y)
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/awrecorder/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/Cdx2.0Plugin/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/Cdx2.0Plugin/src/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/CdxEncPlugin/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/base/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/muxer/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/muxer/aac/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/muxer/base/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/aac/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/amr/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/base/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/base/id3base/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/hls/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/id3v2/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/mov/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/mp3/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/parser/wav/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/playback/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/base/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/customer/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/fifo/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/file/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/flash/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/http/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/ssl/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/libcore/stream/tcp/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/xplayer/*.c
XR872_SOURCE_FILES += ../../../lib/cedarx/src/cedarx/xrecoder/*.c
endif