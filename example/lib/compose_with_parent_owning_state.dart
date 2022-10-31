import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_forge/flutter_forge.dart';

import 'counter.dart';

// Environment
class ComposeWithParentOwningStateEnvironment {}

// State
@immutable
class ComposeWithParentOwningStateState {
  const ComposeWithParentOwningStateState({required this.counter});
  final CounterState counter;
}

// Actions
class ComposeWithParentOwningStateAction {
  static ActionTuple<ComposeWithParentOwningStateState,
          ComposeWithParentOwningStateEnvironment>
      incrementCounter(Ref ref, ComposeWithParentOwningStateState state) {
    return ActionTuple(
        ComposeWithParentOwningStateState(
            counter: CounterState(count: state.counter.count + 1)),
        null);
  }
}

// Widget
class ComposeWithParentOwningState extends ComponentWidget<
    ComposeWithParentOwningStateState,
    ComposeWithParentOwningStateEnvironment> {
  ComposeWithParentOwningState({super.key, required super.store});

  @override
  Widget buildView(context, ref, state, viewStore) {
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
                    toChildState: (state) => state.counter,
                    fromChildAction: pullbackAction<
                            ComposeWithParentOwningStateState,
                            ComposeWithParentOwningStateEnvironment,
                            CounterState,
                            CounterEnvironment>(
                        stateScoper: (parentState) => parentState.counter,
                        environmentScoper: (_) => CounterEnvironment(),
                        statePullback: (childState) =>
                            ComposeWithParentOwningStateState(
                                counter: childState)))),
          ],
        ),
      ),
    );
  }
}
