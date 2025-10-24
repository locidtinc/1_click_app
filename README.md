# one_click

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:
 
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 0886319933/Mykios@1234
## 0941479169
## 0354451289/1click123
## rm pubspec.lock && flutter pub get && flutter pub deps > dependencies.txt
Xoá folder cache Git tương ứng:
## rm -rf ~/.pub-cache/git/base_project-* && flutter pub cache repair && flutter pub get

# 1. Cập nhật git package
flutter pub cache repair
flutter pub get

# 2. Clean Flutter
flutter clean
flutter pub get

# 3. Clean CocoaPods (iOS)
cd ios
rm -rf Pods Podfile.lock
pod cache clean --all
pod install
cd ..

# 4. Xoá DerivedData Xcode
rm -rf ~/Library/Developer/Xcode/DerivedData

# 5. Build lại
flutter run
