# `ictl`

Pwny plugin that allows to manipulate some user interface features available on Apple iOS.

> **Warning**  
> Mind the fact that `ictl` won't work on all Apple iOS systems, due to the fact that `ictl` exploits [MobileSubstrate (*Cydia Substrate*)](https://iphonedev.wiki/index.php/Cydia_Substrate) in order to access device features. [MobileSubstrate (*Cydia Substrate*)](https://iphonedev.wiki/index.php/Cydia_Substrate) is only available on jailbroken iPhones. So, do not try to use it on non-jailbroken iPhones.

## Features

This plugin (`ictl`) can do this things:

* Control and emulate SpringBoard gestures and hardware keys.
* Manipulate location services in order to turn them off, on or obtain accurate device location.
* Control device applications, media player, calls.

## Usage

Load `ictl` plugin to the Pwny to add commands and manipulate some user interface features.

`load ictl`

## Implementing

To implement `ictl` to Pwny follow these steps:

* **1.** Build `ictl.dylib` and `ictl.so` via `make all` and move them to `pwny/data/`
* **2.** Move `ictl.py` to `pwny/plugins/`.

**NOTE:** Pass `pwny` (Pwny SDK) and `sdk` (iPhone SDK) to `make all`, like this `make pwny=<sdk> sdk=<sdk>`.

## Facts

* Based on fully-implemented [@enty8080's](https://github.com/enty8080) Apple iOS implant called [ac1d](https://web.archive.org/web/20201118064306/http://github.com/enty8080/ac1d).
