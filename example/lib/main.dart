import 'package:example/common_state_overrides/app_common_state_builder.dart';
import 'package:example/common_state_overrides/app_common_state_pagination_builder.dart';
import 'package:example/controllers/multi_state_bloc/bloc.dart';
import 'package:example/controllers/multi_state_bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ExamplePaginationApp());
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
            loaded: (data) => Text(data),
          ),
        ),
      ),
    );
  }
}

class ExamplePaginationApp extends StatelessWidget {
  const ExamplePaginationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => MultiStateBloc(),
        child: Builder(builder: (context) {
          return Scaffold(
            body: AppCommonStatePaginationBuilder<MultiStateBloc,
                String>.pagedListView(
              stateName: 'state3Pagination',
              onPageKeyChanged: (value) {
                context
                    .read<MultiStateBloc>()
                    .add(FetchPagination(pageKey: value));
              },
              itemBuilder: (context, item, index) => Text(item),
            ),
          );
        }),
      ),
    );
  }
}
