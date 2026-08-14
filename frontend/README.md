# waste_up

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter run -d chrome --dart-define-from-file=lib/environments/local.json

## PWA installation metadata

Set `PwaInstallationTitle` and `PwaInstallationDescription` in an environment
JSON file. They update the PWA manifest's installation name and description at
startup. For example, run the staging configuration with:

flutter run -d chrome --dart-define-from-file=lib/environments/staging.json