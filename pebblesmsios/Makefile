ARCHS := armv7 arm64
TARGET := iphone:clang
TARGET_SDK_VERSION := 8.4
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 9.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = pebblesmsios
pebblesmsios_FILES = main.m pebblesmsiosApplication.mm RootViewController.mm
pebblesmsios_FRAMEWORKS = UIKit CoreGraphics ExternalAccessory CoreBluetooth 
pebblesmsios_CFLAGS = -F./
pebblesmsios_LDFLAGS += -F./ -ObjC -Wl 

include $(THEOS_MAKE_PATH)/application.mk
