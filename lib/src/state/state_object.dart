// ignore_for_file: body_might_complete_normally_nullable

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../common_state.dart';

@immutable
abstract class StateObject extends Equatable {
  final List<String> stateNames;

  /// the variable that contains all the state object [CommonState]
  final Map<String, CommonState> states;

  StateObject(this.stateNames, [States? states])
      : states = states ??
            stateNames.fold(
              {},
              (map, stateName) {
                map[stateName] =
                    stateName.toLowerCase().endsWith('pagination') ? PaginationState() : const InitialState();
                return map;
              },
            );

  @mustCallSuper
  @mustBeOverridden
  StateObject? updateState(String name, CommonState newState) {
    if (states[name] == null) {
      throw Exception('state $name could not be found');
    }

    // Instance of the object that inherits this state object must be returned here
  }

  States updatedState(String name, CommonState newState) {
    // Create a new map to ensure object reference difference
    final updatedMap = Map<String, CommonState>.from(states);
    updatedMap[name] = newState;
    return updatedMap;
  }

  CommonState getState(String name) {
    CommonState? state = states[name];

    if (state == null) {
      throw Exception('state $name could not be found');
    }

    return state;
  }

  @override
  List<Object?> get props => [states];
}
