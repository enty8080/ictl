# `ictl`

Pwny plugin that allows to manipulate some user interface features available on Apple iOS.

## Features

This plugin (`ictl`) can do this things:

* Controlling and emulating SpringBoard gestures and hardware keys.
* Manipulating location services in order to turn them off, on or obtain accurate device location.
* Controlling device applications, media player, calls.

## Usage

Load `ictl` plugin to the Pwny to add commands and manipulate some user interface features.

`load ictl`

## Implementing

To implement `ictl` to Pwny follow these steps:

* **1.** Build `ictl.dylib` with `make` command and put it to `pwny/data/`.
* **2.** Move `ictl.py` to `pwny/plugins/`.
