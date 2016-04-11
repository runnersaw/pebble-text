export SDKVERSION=8.1

ARCHS := armv7 armv7s arm64
TARGET := iphone:clang
TARGET_SDK_VERSION := 8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 8.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = pebblesmstweak
pebblesmstweak_FILES = Tweak.xm
pebblesmstweak_FRAMEWORKS = UIKit AddressBook
pebblesmstweak_PRIVATE_FRAMEWORKS = CoreTelephony ChatKit AppSupport IMCore IMFoundation
pebblesmstweak_LDFLAGS += -Wl,-segalign,4000
pebblesmstweak_LIBRARIES = rocketbootstrap

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS; killall -9 PebbleTime; killall -9 SpringBoard"
	
SUBPROJECTS += pebblesmstweak
include $(THEOS_MAKE_PATH)/aggregate.mk
