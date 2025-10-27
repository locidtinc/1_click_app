
get:
	flutter clean && flutter pub get

clean:
	flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

pub:
	flutter clean && flutter pub get

run:
	flutter packages pub run build_runner build --delete-conflicting-outputs

ipa:
	flutter build ipa -dart-define=DART_DEFINES_APP_NAME="1Click" --dart-define=DART_DEFINES_BASE_URL="https://api.onkiot.com"

aab:
	flutter build appbundle --release -dart-define=DART_DEFINES_APP_NAME="1Click" --dart-define=DART_DEFINES_BASE_URL="https://api.onkiot.com"

build_apk:
	flutter build apk -dart-define=DART_DEFINES_APP_NAME="1Click" --dart-define=DART_DEFINES_BASE_URL="https://api.onkiot.com"

build_ios:
	flutter build ios -dart-define=DART_DEFINES_APP_NAME="1Click" --dart-define=DART_DEFINES_BASE_URL="https://api.onkiot.com"

rm:
	flutter clean && flutter pub get && rm -rf ios/Pods ios/Podfile.lock && cd ios && pod install

tree:
	flutter pub deps > dependencies.txt

podU:
	cd ios && pod install --repo-update

apk:
	flutter build apk --no-shrink
