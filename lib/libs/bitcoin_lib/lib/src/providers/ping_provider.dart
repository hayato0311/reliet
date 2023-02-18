import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../protocol/actions/send_message.dart';
import '../protocol/types/nonce.dart';

part 'generated/ping_provider.g.dart';

class PingObserverState {
  PingObserverState(this.socket, this.nonce);
  final Socket socket;
  final Nonce nonce;
}

@riverpod
class PingReciever extends _$PingReciever {
  @override
  PingObserverState? build() {
    return null;
  }

  // ignore: use_setters_to_change_properties
  void updateState(PingObserverState pingObserverState) {
    state = pingObserverState;
  }
}

class PingObserver extends ProviderObserver {
  @override
  Future<void> didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) async {
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');

    final pingObserverState = container.read(pingRecieverProvider);

    if (pingObserverState == null) return;

    await sendPongMessage(pingObserverState.socket, pingObserverState.nonce);
  }
}
