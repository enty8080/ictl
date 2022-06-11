include $(THEOS)/makefiles/common.mk

export SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk

TWEAK_NAME = ictl

ictl_FILES = Tweak.xm
ictl_CFLAGS = -fobjc-arc -Wno-unused -I./include
ictl_PRIVATE_FRAMEWORKS = AppSupport UIKit MediaRemote MediaPlayer AVFoundation CoreLocation

include $(THEOS)/makefiles/tweak.mk
