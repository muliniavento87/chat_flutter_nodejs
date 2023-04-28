import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/chat/chat_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// notifiche
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*
void main() {
  runApp(const MyApp());
}
*/


Future<void> main() async {
  // main modificato per implementare notifiche
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp(flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flnp;
  const MyApp(this.flnp, {super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: ChatView(flnp)
    );
  }
}
