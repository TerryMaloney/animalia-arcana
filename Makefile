.PHONY: setup fmt analyze test build debug ci

setup:
flutter pub get

fmt:
dart format .

analyze:
flutter analyze

test:
flutter test --reporter expanded

build:
flutter build apk --release

debug:
flutter build apk --debug

ci: fmt analyze test debug
