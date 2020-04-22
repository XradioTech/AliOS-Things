# blink sample

## Contents

```sh
blink_demo
├── blink_demo.c    # blink source code
├── maintask.c      # main task source code
├── Config.in       # kconfig file
├── aos.mk          # aos build system file
└── k_app_config.h  # aos app config file
```

## Introduction

The **blink_demo** example shows how to drive LEDs on the [supported boards](../../../board) in AliOS-Things, the example will work like this:
* LED0 blink every 1s.
* push button will turn LED1 on/off.

### Requirements

in `blink_demo.c` need to redefine the following macro:
* `GPIO_LED_IO`(LED1)

### Features

* LED0 blink every 1s.

### Dependencies


### Supported Boards

- all

### Build

```sh
# generate blink_demo@developerkit default config
aos make blink_demo@developerkit -c config

# or customize config manually
aos make menuconfig

# build
aos make
```

> if you want to see AliOS-Things supports boards, click [board](../../../board).

### Install

```sh
aos upload blink_demo@yourboard
```

> if you are not sure is the`aos upload` command supports your board, check [aos upload](../../../build/site_scons/upload).

### Reference

* https://yq.aliyun.com/articles/669088

### support for st nucleo board
* verified on stm32l476rg nucleo board, other nucleo also can be supported, please refer to the hardware guide for the gpio pin number
