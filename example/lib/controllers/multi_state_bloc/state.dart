import 'package:common_state/common_state.dart';
import 'package:example/common_state_overrides/types.dart';
import 'package:example/main.dart';

class MultiStateBlocState extends StateObject<MultiStateBlocState> {
  MultiStateBlocState([States? states])
      : super(
          [
            const Initial<String>('state1'),
            const Initial<int>('state2'),
            PaginationState<SomPaginatedData, String>('state3Pagination')
          ],
          (states) => MultiStateBlocState(states),
          states,
        );
}
