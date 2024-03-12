import 'package:common_state/common_state.dart';
import 'package:example/common_state_overrides/app_common_state_builder.dart';
import 'package:example/common_state_overrides/app_common_state_pagination_builder.dart';
import 'package:example/controllers/multi_state_bloc/bloc.dart';
import 'package:example/controllers/multi_state_bloc/event.dart';
import 'package:example/controllers/multi_state_bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(ExamplePaginationApp());
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
  ExamplePaginationApp({super.key});
  final MultiStateBloc bloc = MultiStateBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => bloc,
        child: Builder(builder: (context) {
          bloc
            ..add(UpdateSomeProperty(true))
            ..add(UpdateExampleProperty(const ExampleProperty(2, true)));
          return Scaffold(
            body: AppCommonStatePaginationBuilder<MultiStateBloc, String>.pagedListView(
              stateName: 'state3Pagination',
              onPageKeyChanged: (value) {
                context.read<MultiStateBloc>().add(FetchPagination(pageKey: value));
              },
              itemBuilder: (context, item, index) {
                bloc.add(UpdateExampleProperty(ExampleProperty(index + 2, true)));

                return const Text('here we are');
              },
            ),
          );
        }),
      ),
    );
  }
}

class SomPaginatedData implements PaginatedData<String> {
  final int someValue;
  final PaginationModel<String> paginatedValue;

  SomPaginatedData(this.someValue, this.paginatedValue);

  @override
  PaginationModel<String> get paginatedData => paginatedValue;
}
