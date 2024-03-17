import 'package:example/controllers/single_state_cubit/single_state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common_state_overrides/app_result_builder.dart';

class SingleStateCubitExample extends StatelessWidget {
  const SingleStateCubitExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => SingleStateCubit()..fetch(),
        child: Scaffold(
          body: AppResultBuilder<SingleStateCubit, String>(
            loaded: (data) => Text(data),
          ),
        ),
      ),
    );
  }
}
