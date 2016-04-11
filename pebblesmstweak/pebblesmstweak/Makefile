ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = pebblesmstweak
pebblesmstweak_FILES = pebblesmstweak.mm
pebblesmstweak_INSTALL_PATH = /Library/PreferenceBundles
pebblesmstweak_FRAMEWORKS = UIKit
pebblesmstweak_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/pebblesmstweak.plist$(ECHO_END)
