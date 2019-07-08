include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64

BUNDLE_NAME = NetworkManager
NetworkManager_BUNDLE_EXTENSION = bundle
NetworkManager_FILES = CCNetworkManager.x
NetworkManager_FRAMEWORKS = CoreTelephony
NetworkManager_PRIVATE_FRAMEWORKS = ControlCenterUIKit
NetworkManager_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += networkmanagerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
