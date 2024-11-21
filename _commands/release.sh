# Запуск приложения
# DEV
flutter run --dart-define=API_URL=https://dev.inappdb.ru/v2/
flutter run --dart-define=API_URL=https://dreamsnet.inappdb.ru/v2/

# PROD
# flutter build apk --dart-define=API_URL=https://dev.inappdb.ru/v2/
# flutter build apk --dart-define=API_URL=https://dreamsnet.inappdb.ru/v2/
# flutter build appbundle --dart-define=API_URL=https://dreamsnet.inappdb.ru/v2/
# flutter build ios --dart-define=API_URL=https://dreamsnet.inappdb.ru/v2/