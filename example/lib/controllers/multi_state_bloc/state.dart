import 'package:common_state/common_state.dart';

class MultiStateBlocState extends StateObject {
  MultiStateBlocState([States? states]) : super(['state1', 'state2', 'state3Pagination'], states);

  @override
  StateObject? updateState(String name, CommonState newState) {
    super.updateState(name, newState);
    return MultiStateBlocState(updatedState(name, newState));
  }
}
