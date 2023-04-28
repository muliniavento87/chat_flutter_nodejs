# flutter_chat
Flutter chat


## Flutter riverpod, build_runner, freezed, ...
1. riverpod (ATTENZIONE: incapsula l'app nel widget "ProviderScope()" altrimenti Riverpod non funziona)
```agsl
flutter pub add flutter_riverpod
```
2. logger
```agsl
flutter pub add logger
```
3. freezed_annotation
```agsl
flutter pub add freezed_annotation
```
4. freezed
```agsl
dependencies:
  freezed: ^2.3.2
```
5. build_runner
```agsl
dev_dependencies:
  build_runner: ^2.3.3
```
5. refresh pacchetti
```agsl
flutter pub get
```

## Scripts
scripts:
build: flutter clean && flutter pub get && flutter packages pub run build_runner build --delete-conflicting-outputs
watch: flutter pub run build_runner watch --delete-conflicting-outputs
apk: flutter build apk --release -t lib/main_x.dart --target-platform android-arm,android-arm64  # esclude x64 per gli emulatori
apbundle: flutter build appbundle -t lib/main_x.dart  --release --target-platform android-arm,android-arm64  # esclude x64 per gli emulatori
apk_emulator: flutter build apk --release --target-platform android-arm,android-arm64,android-x64
ios:
wala: flutter build ios --release
walaX: flutter build ios -t lib/main_x.dart --flavor WalaX
labels: flutter gen-l10n --template-arb-file=app_en.arb #forza il refresh delle stringhe e da eventuali errori


## install libreria Socket.io
1. Installiamo il pacchetto socket_io_client (https://pub.dev/packages/socket_io_client/install), il comando sotto aggiorna pubspec.yaml
```agsl
flutter pub add socket_io_client
```
2. update
```agsl
flutter pub get
```
3. import
```agsl
import 'package:socket_io_client/socket_io_client.dart' as IO;
```
4. abilita permessi:
   1. ANDROID (android/app/src/main/AndroidManifest.xml), PRIMA di "<application ..."
    ```agsl
    <uses-permission android:name="android.permission.INTERNET" />
    ```
   2. IOS (Aggiungi il seguente codice nel file ios/Runner/Info.plist)
   ```agsl
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    ```


## install libreria notifiche
flutter pub add flutter_local_notifications
