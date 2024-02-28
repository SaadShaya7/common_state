import 'package:flutter/material.dart';

import '../../common_state.dart';

@immutable
abstract class StateObject {
  final List<String> stateNames;

  const StateObject(this.stateNames);

  List<CommonState> get states {
    return stateNames.map((e) {
      if (e.endsWith('Pagination')) return PaginationState();
      return InitialState(e);
    }).toList();
  }

  CommonState getState(String name) => states[getStateIndex(name)];

  int getStateIndex(String name) {
    final int index = stateNames.indexOf(name);
    if (index == -1) {
      throw Exception('The state you are looking for does not exist, please check the name you provided');
    }
    return index;
  }

  //TODO implement set state method that will somehow return the child object with the modified list
}

class SomethingState extends StateObject {
  static String profileState = 'profileState';
  SomethingState() : super([profileState]);
}

var state = SomethingState();
