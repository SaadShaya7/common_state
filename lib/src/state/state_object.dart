// ignore_for_file: body_might_complete_normally_nullable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common_state.dart';

/// An abstract class representing common states of an object.
///
/// This class provides a base for concrete state objects. Extend this class
/// and provide your class type as the generic type parameter.
///
/// Example usage:
///
/// ```dart
/// class MyStateObject extends StateObject<MyStateObject> {
///   MyStateObject([States? states]) : super(
///     [
///       const InitialState('state1'),
///       const PaginationState('state2'),
///     ],
///     (states) => MyStateObject(states),
///     states,
///   );
/// }
/// ```
@immutable
abstract class StateObject<T> extends Equatable {
  /// The initial state
  final List<CommonState> initial;

  /// the variable that contains all the state object [CommonState]
  final Map<String, CommonState> states;

  /// Used to create a new instance of [T] with the new state
  final InstanceCreator<T> instanceCreator;

  StateObject(this.initial, this.instanceCreator, [States? states]) : states = states ?? _mapStates(initial) {
    if (T == dynamic) {
      throw ArgumentError('Type argument T cannot be dynamic. Please provide a specific type.');
    }
  }

  /// Update the state of a specific state in the state object
  T updateState(String name, CommonState newState) {
    if (states[name] == null) {
      throw Exception('state $name could not be found');
    }

    return instanceCreator(_updatedState(name.toLowerCase(), newState));
  }

  /// returns the state of the specific name, throws an exception if the state is not found
  CommonState getState(String name) {
    CommonState? state = states[name.toLowerCase()];

    if (state == null) {
      throw Exception('state $name could not be found');
    }

    return state;
  }

  States _updatedState(String name, CommonState newState) {
    final updatedMap = Map<String, CommonState>.from(states);
    updatedMap[name] = newState;
    return updatedMap;
  }

  static States _mapStates(List<CommonState> statesList) {
    return statesList.fold(
      {},
      (map, initial) {
        if (initial.name == null || initial.name!.isEmpty) {
          throw Exception('State name cannot be null or empty');
        }

        final String stateName = initial.name!.toLowerCase(); // parse to lowercase to avoid case sensitivity

        if (initial is! InitialState && initial is! PaginationState) {
          throw Exception('${initial.runtimeType} is not a valid initial state');
        }

        map[stateName] = initial;
        return map;
      },
    );
  }

  @override
  List<Object?> get props => [states];
}
