# pub_search

An app for searching packages on pub.dev

## Getting Started

1 - Install [Flutter](https://docs.flutter.dev/get-started/install) in your local environment.
2 - Navigate to the `pub_cache` folder and run `flutter pub get`.
3 - Start an iOS Simulator or an Android emulator and run `flutter run`.

## Documentation

This app is part of a coding test for the Concepta company. The documentation is available below.

[Flutter developer test](https://concepta.notion.site/concepta/Flutter-Developer-Test-f8f6dd7f92fe422c819a1ae0393237a4#3c1ab656d6a945b7bd0b22294d2723f6)
[Figma](https://www.figma.com/file/25VUUkIB52nRwtkq8iFuGS/Flutter-Reference?node-id=1%3A22&t=RATKro3zSybWKtKI-0)

## The 80/20 approach

I've used a 80/20 approach to develop this app, where I've invested 20% of the time in 80% of the work, which was basically having the app running as per its documentation, without going into details like state management frameworks or robust architecture.

Once I was satisfied with the bulk of the work and having a 100% functional app, it was time to dive into the details, which is basically investing 80% of the time in 20% of the work. This is where I started state management, architecture, and dependency injection in order to hit the next level of code quality and maintainability.

## E2E testing

For E2E testing, install [maestro](https://maestro.mobile.dev/), install the app in a device (Android emulator/physical device or iOS simulator) with `flutter install [ios/apk]` and run the following command in the `pub_search` directory:

```
maestro run tests/E2E/smoke_test.yaml
```