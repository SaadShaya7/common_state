// ignore_for_file: body_might_complete_normally_nullable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../common_state.dart';

@immutable
abstract class StateObject extends Equatable {
  final List<CommonState> initial;

  /// the variable that contains all the state object [CommonState]
  final Map<String, CommonState> states;

  StateObject(this.initial, [States? states])
      : states = states ??
            initial.fold(
              {},
              (map, initial) {
                if (initial.name == null || initial.name!.isEmpty) {
                  throw Exception('State name cannot be null or empty');
                }

                final String stateName = initial.name!;

                if (initial is! InitialState && initial is! PaginationState) {
                  throw Exception('${initial.runtimeType} is not a valid initial state');
                }

                map[stateName] = initial;
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
