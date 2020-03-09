---
title: "Work with I2C on Raspberry Pi"
---

Article is describing basic steps on how to start working with an I2C device. The end goal is a simple LED clock.
Everything was done on the Raspbian "Buster" with using Adafruit 4-Digit 7-Segment Display.

Essential links:

 - [Implementing I2C device drivers in userspace](https://www.kernel.org/doc/html/latest/i2c/dev-interface.html) - basics on how to work with I2C in Linux
 - [i2c-tools](https://git.kernel.org/pub/scm/utils/i2c-tools/i2c-tools.git) - user-space library and command line tools
 - [Adafruit 1.2" 4-Digit 7-Segment Display w/I2C Backpack](https://www.adafruit.com/product/1270) - information about used LED display

First, enable I2C:

```
$ sudo raspi-config nonint do_i2c 0
```

Then install needed use-space tools and library:

```
$ sudo apt install i2c-tools libi2c-dev
```

Run next command to check that LED display is connected (default address is 0x70):

```
$ sudo i2cdetect -y 1                     
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: 70 -- -- -- -- -- -- --
```

Simple communication with the display can be done with the help of `i2cget` and `i2cset` tools.
Adafruit LED display is using HT16K33 as a driver and addresses and values of its internal registers can be found in the datasheet.
In addition, source code of the `i2c-tools` can be used as an example on how to read and write data. For example to turn display on:

```
$ sudo i2cset -y 1 0x70 0x81
```

Below is the resulting source code of the program which reads system time and shows it on the display.
To compile it:

```
$ g++ ledclock.cpp -li2c -o ledclock
```

Source code:

{{< gist dmitriy5181 a349a9d803dbc34bd254d8215774828f >}}