// ignore_for_file: body_might_complete_normally_nullable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../common_state.dart';
import '../types.dart';

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
abstract class StateObject<T> extends BaseState with EquatableMixin {
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

    if (_containsDuplicates(initial.map((e) => e.name))) {
      throw ArgumentError('State names cannot contain duplicates. Please provide unique state names.');
    }
  }

  /// Update the state of a specific state in the state object
  T updateState(String name, CommonState newState) {
    if (states[name] == null) {
      throw ArgumentError('state $name could not be found');
    }

    return instanceCreator(_updatedState(name, newState));
  }

  /// returns the state of the specific name, throws an exception if the state is not found
  /// [S] is the type of the state
  CommonState<S> getState<S>(String name) {
    CommonState<S>? state = states[name] as CommonState<S>?;

    if (state == null) {
      throw ArgumentError('The state ($name) could not be found, please check the state name');
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
          throw ArgumentError('initial state names cannot be null nor empty, please provide a valid name');
        }

        final String stateName = initial.name!;

        map[stateName] = initial;
        return map;
      },
    );
  }

  static bool _containsDuplicates(Iterable<String?> names) => names.toSet().length < names.length;

  @override
  List<Object?> get props => [states];
}
