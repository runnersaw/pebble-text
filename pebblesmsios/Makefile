ARCHS := armv7 arm64
TARGET := iphone:clang
TARGET_SDK_VERSION := 8.4
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 9.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = pebblesmsios
pebblesmsios_FILES = main.m pebblesmsiosApplication.mm RootViewController.mm
pebblesmsios_FRAMEWORKS = PebbleKit UIKit CoreGraphics ExternalAccessory CoreBluetooth 
PebbleActivator_CFLAGS = -F./
pebblesmsios_LDFLAGS += -F./ -ObjC -Wl -segalign 4000

include $(THEOS_MAKE_PATH)/application.mk
