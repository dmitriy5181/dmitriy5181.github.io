---
title: "Hello ESPHome World"
---

After discovering [Home Assistant](https://www.home-assistant.io/),
the [ESPHome](https://github.com/esphome/esphome) became a logical continuation.
First run with a blinking LED on WEMOS D1 mini.

While ESPHome supports over-the-air updates, the very first firmware flashing must be done via
a serial port. [ESPHome-Flasher](https://github.com/esphome/esphome-flasher) can do it, has
a very straightforward interface and pre-built binaries. A driver for the CH340 USB-to-serial
converter will be also needed. ESPHome itself can be installed via
[PyPI](https://pypi.org/project/esphome/).

With all tools installed a basic starting point can look like this:

{{< gist dmitriy5181 a1261844b6172e36482e8d4a174fad40 >}}

To compile it run:

```
$ esphome compile hello-esphome.yaml
```

After successful compilation the firmware can be found under _.pioenvs/hello/firmware.bin_. This 
file can be uploaded via ESPHome-Flasher and if everything went fine the LED will start blinking!

![](/hello-esphome.gif)

Following updates can be uploaded already via WiFi. To compile, upload and attach to the logger 
run:

```
$ esphome run hello-esphome.yaml
```
