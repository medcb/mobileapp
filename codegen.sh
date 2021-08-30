
# json mapping
flutter packages pub run build_runner build --delete-conflicting-outputs

# translations
flutter pub run easy_localization:generate -S assets/translations -O lib/generated
flutter pub run easy_localization:generate -S assets/translations -f keys -o lib/generated/locale_keys.g.dart
