import 'package:example/overrides/app_result_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/single_state_cubit.dart';

class Data extends StatelessWidget {
  const Data({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SingleStateCubit()..fetch(),
      child: Scaffold(
        body: Center(
          child: AppResultBuilder<SingleStateCubit, String>(
            loaded: (data) => Text(data, style: const TextStyle(fontSize: 30)),
          ),
        ),
      ),
    );
  }
}
