ARCHS := armv7 arm64
TARGET := iphone:clang
TARGET_SDK_VERSION := 8.1
TARGET_IPHONEOS_DEPLOYMENT_VERSION := 9.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = pebbletextios
pebbletextios_FILES = main.m pebbletextiosApplication.mm RootViewController.mm
pebbletextios_FRAMEWORKS = UIKit CoreGraphics
pebbletextios_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/application.mk
