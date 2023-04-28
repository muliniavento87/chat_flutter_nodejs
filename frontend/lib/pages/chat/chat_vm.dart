import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/src/socket.dart';
import 'chat_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const ADDRESS = 'http://muliniavento87.ignorelist.com:4200';

class ChatVM extends StateNotifier<ChatState> {
  final Ref ref;
  final FlutterLocalNotificationsPlugin flnp;
  late IO.Socket socket;
  final TextEditingController msgController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  ChatVM(this.ref, this.flnp) : super(const ChatState()) {
    // get valori per la View usando await
    initAsync();
  }

  Future<void> initAsync() async {
    try {
      state = state.copyWith(loading: true);

      socket = IO.io(
        ADDRESS,
        IO.OptionBuilder().setTransports(['websocket']).build(),
      );
      connectSocket();
      // scroll per portare sempre giù il focus
      //scrollController.addListener(scrollListener);

      state = state.copyWith(loading: false);
    } catch (err) {
      Logger().d("error...");
    }
  }

  void connectSocket() {
    socket.onConnect((data) => newMsgSent('Hello, server! BY FLUTTER', socket, 'msg-client-2-server'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
    socket.on('test-message', (data) => newMsgReceived(data), );
    socket.on('msg-server-2-client', (data) => newMsgReceived(data), );
  }

  void sendMessage(ChatVM vm) {
    // invio messaggio al server
    //socket.emit('msg-client-2-server', _controller.text);
    vm.newMsgSent(msgController.text, socket, 'msg-client-2-server');
    msgController.clear();
  }

  void newMsgReceived(msg){
    //Logger().d("newMsgReceived: " + msg);
    List<String> list = [];
    list.addAll(state.msgs);
    list.add("Server: $msg");
    scrollController.jumpTo(scrollController.position.maxScrollExtent);

    Map<String, dynamic> message = {};
    message['notification'] = {};
    message['notification']['title'] = "Nuovo messaggio";
    message['notification']['body'] = msg;
    _onMessageReceived(message);

    state = state.copyWith(msgs: list);
  }

  void newMsgSent(msg, Socket socket, id) {
    socket.emit(id, msg);
    /*
    List<String> list = [];
    list.addAll(state.msgs);
    list.add("Me: $msg");
    state = state.copyWith(msgs: list);
    */
  }

  Future<void> _showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String title,
      String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void _onMessageReceived(Map<String, dynamic> message) {
    final String title = message['notification']['title'];
    final String body = message['notification']['body'];
    _showNotification(flnp, title, body);
  }
}

/// get VM dalla View (View NATA CON parametri di input (es. "String s"))

final chatVMProvider = StateNotifierProvider.autoDispose.family<ChatVM, ChatState, FlutterLocalNotificationsPlugin>((ref, flnp) {
  return ChatVM(ref, flnp);
});

/*
/// get VM dalla View (View NATA SENZA parametri di input)
final chatVMProvider = StateNotifierProvider.autoDispose<ChatVM, ChatState>((ref) {
    return ChatVM(ref);
});
*/

