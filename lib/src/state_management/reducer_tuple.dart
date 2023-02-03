import 'effect_task.dart';
import 'reducer_action.dart';
import 'package:equatable/equatable.dart';

class ReducerTuple<S extends Equatable, E, A extends ReducerAction> {
  ReducerTuple(this.state, this.effectTasks);
  final S state;
  final Iterable<EffectTask<S, E, A>> effectTasks;

  factory ReducerTuple.noop(S state) {
    return ReducerTuple(state, []);
  }
}
