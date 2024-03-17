import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common_state_overrides/app_result_builder.dart';
import '../controllers/multi_state_bloc/bloc.dart';
import '../controllers/multi_state_bloc/event.dart';

class MultiStateBlocExample extends StatelessWidget {
  const MultiStateBlocExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => MultiStateBloc()..add(Fetch()),
        child: Scaffold(
          body: AppResultBuilder<MultiStateBloc, String>(
            stateName: 'state1',
            loaded: (data) => Text(data),
          ),
        ),
      ),
    );
  }
}
