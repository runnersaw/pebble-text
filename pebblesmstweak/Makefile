
ARCHS := armv7 armv7s arm64
TARGET := iphone:clang
TARGET_SDK_VERSION := 9.2
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 8.0
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = pebblesmstweak
pebblesmstweak_FILES = main.xm enableTextReply.xm $(wildcard PBSMSClasses/*.m) $(wildcard PBSMSClasses/*.xm)
pebblesmstweak_FRAMEWORKS = UIKit AddressBook
pebblesmstweak_PRIVATE_FRAMEWORKS = CoreTelephony ChatKit AppSupport IMCore IMFoundation IMSharedUtilities
pebblesmstweak_LDFLAGS += -Wl,-segalign,4000
pebblesmstweak_LIBRARIES = rocketbootstrap applist

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 MobileSMS; killall -9 PebbleTime; killall -9 SpringBoard"
