import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common_state.dart';

@immutable
abstract class StateObject extends Equatable {
  final List<String> stateNames;

  /// the variable that contains all the state object [CommonState]
  final Map<String, CommonState> states;

  StateObject(this.stateNames)
      : states = stateNames.fold(
          {},
          (map, stateName) {
            map[stateName] = const InitialState();
            return map;
          },
        );

  StateObject updateState(String name, CommonState newState) {
    if (states[name] == null) {
      throw Exception('state $name could not be found');
    }
    return this..states[name] = newState;
  }

  CommonState getState(String name) {
    CommonState? state = states[name];

    if (state == null) {
      throw Exception('state $name could not be found');
    }

    return state;
  }

  @override
  List<Object?> get props => [stateNames];
}

class SomethingState extends StateObject {
  SomethingState() : super(['profileState', 'state2', 'state3Pagination']);
}
