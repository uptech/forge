import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'store_interface.dart';
import 'view_store_interface.dart';

abstract class ComponentWidget<S, E> extends ConsumerStatefulWidget {
  ComponentWidget({super.key, required this.store});
  final StoreInterface<S, E> store;

  void initState(ViewStoreInterface<S, E> viewStore) {}
  void postInitState(ViewStoreInterface<S, E> viewStore) {}
  void dispose(ViewStoreInterface<S, E> viewStore) {}

  Widget build(
      BuildContext context, S state, ViewStoreInterface<S, E> viewStore);

  @override
  createState() => _ComponentState(store);
}

class _ComponentState<S, E> extends ConsumerState<ComponentWidget> {
  _ComponentState(this.store);
  final StoreInterface<S, E> store;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    widget.initState(store.viewStore(ref));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.postInitState(store.viewStore(ref));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(store.provider);
    return widget.build(context, state, store.viewStore(ref));
  }

  @override
  void dispose() {
    widget.dispose(store.viewStore(ref));
    super.dispose();
  }
}
