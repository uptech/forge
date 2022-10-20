import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'store.dart';

import 'counter.dart';

@immutable
class ComposeWithParentOwningStateState {
  const ComposeWithParentOwningStateState({required this.counter});
  final CounterState counter;
}

ComposeWithParentOwningStateState incrementCounter(Ref ref, ComposeWithParentOwningStateState state) {
  return ComposeWithParentOwningStateState(counter: CounterState(count: state.counter.count + 1));
}

class ComposeWithParentOwningState extends StatelessWidget {
  const ComposeWithParentOwningState({super.key, required this.store});
  final StoreInterface<ComposeWithParentOwningStateState> store;

  @override
  Widget build(BuildContext context) {
    return store.viewBuilder((state, viewStore) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Compose with Parent Owning State'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Counter(
                store: store.scope(
                  globalToLocalState: (appState) => appState.counter,
                  localToGlobalAction: (localAction) {
                    return (Ref ref, ComposeWithParentOwningStateState state) async {
                      return ComposeWithParentOwningStateState(counter: await localAction(ref, state.counter));
                    };
                  })
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => viewStore.send(incrementCounter),
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
