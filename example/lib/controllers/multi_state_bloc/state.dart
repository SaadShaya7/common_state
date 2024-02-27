import '../../common_state_overrides/types.dart';

class MultiStateBlocState {
  // Those will act as map keys for your state objects
  static int state1 = 0;
  static int state2 = 1;
  static int state3 = 2;
  static int state4 = 3;

  static AppStates init = {
    state1: const Initial<String>(),
    state2: const Initial<int>(),
    state3: const Initial<double>(),
    state4: const Initial<void>(),
  };
}
