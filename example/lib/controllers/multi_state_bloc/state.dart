import 'package:common_state/common_state.dart';
import 'package:example/common_state_overrides/types.dart';

class MultiStateBlocState extends StateObject {
  MultiStateBlocState([States? states])
      : super([
          const Initial<String>('state1'),
          const Initial<int>('state2'),
          PaginationState<String>('state3Pagination')
        ], states);

  @override
  StateObject? updateState(String name, CommonState newState) {
    super.updateState(name, newState);
    return MultiStateBlocState(updatedState(name, newState));
  }
}
