// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:common_state/common_state.dart';
import 'package:example/overrides/types.dart';
import 'package:flutter/material.dart';

import '../../../../models/utils.dart';

@immutable
class MultiStateBlocState extends StateObject<MultiStateBlocState> {
  final bool? someProperty;
  final ExampleProperty? exampleProperty;

  MultiStateBlocState([
    States? states,
    this.someProperty,
    this.exampleProperty,
  ]) : super(
          [
            const Initial<String>('state1'),
            const Initial<int>('state2'),
            PaginationState<SomPaginatedData, String>('state3Pagination')
          ],
          (states) => MultiStateBlocState(states, someProperty, exampleProperty),
          states,
        );

  MultiStateBlocState copyWith({bool? someProperty, ExampleProperty? exampleProperty}) => MultiStateBlocState(
        states,
        someProperty ?? this.someProperty,
        exampleProperty ?? this.exampleProperty,
      );

  @override
  List<Object?> get props => [states, someProperty, exampleProperty];
}
