import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../protocol/actions/send_message.dart';
import '../protocol/types/inventory.dart';

part 'generated/inv_provider.g.dart';

class InvObserverState {
  InvObserverState(this.socket, this.inventories);
  final Socket socket;
  final List<Inventory> inventories;
}

@riverpod
class InvReciever extends _$InvReciever {
  @override
  InvObserverState? build() {
    return null;
  }

  // ignore: use_setters_to_change_properties
  void updateState(InvObserverState invObserverState) {
    state = invObserverState;
  }
}

class InvObserver extends ProviderObserver {
  @override
  Future<void> didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) async {
    final invObserverState = container.read(invRecieverProvider);

    if (invObserverState == null) return;

    await sendGetDataMessage(
      invObserverState.socket,
      invObserverState.inventories,
    );
  }
}
