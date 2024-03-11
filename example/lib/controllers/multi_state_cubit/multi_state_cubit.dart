// import 'package:common_state/common_state.dart';
// import 'package:either_dart/either.dart';
// import 'package:example/controllers/multi_state_cubit/multi_state_cubit_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class MultiStateCubit extends Cubit<MultiStateCubitState> {
//   MultiStateCubit() : super(MultiStateCubitState());

//   // Use this
//   void get() async => CubitStateHandlers.multiStateApiCall(
//         apiCall: () async => const Right("Success"),
//         emit: emit,
//         state: state,
//         stateName: MultiStateCubitState.state1,
//       );

//   // Or this
//   void get2() => multiStateApiCall(MultiStateCubitState.state1, () async => const Right("Success"));
// }
