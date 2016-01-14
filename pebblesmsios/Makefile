ARCHS := armv7 arm64
TARGET := iphone:clang
TARGET_SDK_VERSION := 8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 8.1

APPLICATION_NAME = pebblesmsios

pebblesmsios_CFLAGS = -F./
pebblesmsios_LDFLAGS = -F./
pebblesmsios_FILES = main.m pebblesmsiosApplication.mm RootViewController.mm PebbleKit.framework/PebbleKit
pebblesmsios_FRAMEWORKS = UIKit CoreGraphics ExternalAccessory CoreBluetooth PebbleKit

include $(THEOS)/makefiles/common.mk

include $(THEOS_MAKE_PATH)/application.mk
