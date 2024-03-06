import 'package:example/common_state_overrides/app_common_state_builder.dart';
import 'package:example/controllers/multi_state_bloc/bloc.dart';
import 'package:example/controllers/multi_state_bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => MultiStateBloc()..add(Fetch()),
        child: Scaffold(
          body: AppCommonStateBuilder<MultiStateBloc, String>(
            stateName: 'state1',
            onSuccess: (data) => Text(data),
          ),
        ),
      ),
    );
  }
}
