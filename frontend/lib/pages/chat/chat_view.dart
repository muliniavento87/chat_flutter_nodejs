import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_state.dart';
import 'chat_vm.dart';

class ChatView extends ConsumerWidget {
  final FlutterLocalNotificationsPlugin flnp;
  const ChatView(this.flnp, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // set valori input View nello State del VM
    //  - get state vm
    ChatState state = ref.watch(chatVMProvider(flnp));
    //  - get istanza vm
    final vm = ref.read(chatVMProvider(flnp).notifier);

    return (state.loading) ?
    const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chat (socket_io_client)'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: vm.scrollController,
                itemCount: state.msgs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(state.msgs[index]),
                      )
                  );
                },
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: vm.msgController,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {vm.sendMessage(vm);},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}