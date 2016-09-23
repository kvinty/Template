# Project variables
# Configure them properly in case of modifying the project structure
APP_NAME=Template
PACKAGE_NAME=org.$(APP_NAME)
PACKAGE_PATH=src/org/$(APP_NAME)
MAIN_CLASS=MainActivity

# Java and SDK variables
# JAVA_HOME - JDK directory
# ANDROID_HOME - Android SDK directory
# BUILD_TOOLS_VERSION - name of subdirectory in $(ANDROID_HOME)/build-tools
JAVA_HOME=$(HOME)/external/jdk
ANDROID_HOME=$(HOME)/external/sdk
ANDROID_JAR=$(ANDROID_HOME)/platforms/android-24/android.jar
BUILD_TOOLS_VERSION=24.0.2

# Key store and signing passwords, organisation name
# Place your own passwords here instead of these stubs
STOREPASS=000000
KEYPASS=000000
ORGANISATION=NOWHERE


.PHONY: all build genkey sign align test clean

all: build genkey sign align test clean

build:
	# Make a directory for temporary files
	mkdir bin
	# Preprocess, create R.java
	$(ANDROID_HOME)/build-tools/$(BUILD_TOOLS_VERSION)/aapt package -f -m -S res -J src -M AndroidManifest.xml -I $(ANDROID_JAR)
	# Compile
	$(JAVA_HOME)/bin/java -jar $(ANDROID_HOME)/build-tools/$(BUILD_TOOLS_VERSION)/jack.jar --output-dex bin -cp $(ANDROID_JAR) -D jack.java.source.version=1.8 $(PACKAGE_PATH)/R.java $(PACKAGE_PATH)/MainActivity.java
	# Package classex.dex to APK
	$(ANDROID_HOME)/build-tools/$(BUILD_TOOLS_VERSION)/aapt package -f -M AndroidManifest.xml -S res -I $(ANDROID_JAR) -F bin/$(APP_NAME)-unsigned.apk bin

genkey:
	# Create signing key
	$(JAVA_HOME)/bin/keytool -genkey -validity 146097 -dname O=$(ORGANISATION) -keystore bin/key.jks -storepass $(STOREPASS) -keypass $(KEYPASS) -alias key -keyalg RSA -keysize 4096

sign:
	# Sign the APK
	$(JAVA_HOME)/bin/jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore bin/key.jks -storepass $(STOREPASS) -keypass $(KEYPASS) -signedjar bin/$(APP_NAME)-unaligned.apk bin/$(APP_NAME)-unsigned.apk key
	# Add "-tsa http://timestamp.digicert.com" option to disable the nasty warning above

align:
	# Align the APK
	$(ANDROID_HOME)/build-tools/$(BUILD_TOOLS_VERSION)/zipalign 4 bin/$(APP_NAME)-unaligned.apk bin/$(APP_NAME).apk
	cp bin/$(APP_NAME).apk .

test:
	# Reinstall and run the APK on a (connected) device or (launched) emulator
	adb uninstall $(PACKAGE_NAME)
	adb install $(APP_NAME).apk
	adb shell am start -n $(PACKAGE_NAME)/$(PACKAGE_NAME).$(MAIN_CLASS)

clean:
	# Delete temporary files
	rm -rf $(PACKAGE_PATH)/R.java bin
