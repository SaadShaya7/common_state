import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/models/error.dart';
import 'package:example/use_cases/bloc/multi_state/controller/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/utils.dart';
import 'event.dart';

class MultiStateBloc extends Bloc<CommonStateEvent, MultiStateBlocState> {
  MultiStateBloc() : super(MultiStateBlocState()) {
    // Use this
    multiStateApiCall<Fetch, String>('state1', (event) => someUseCase());

    multiStatePaginatedApiCall<FetchPagination, SomPaginatedData>(
      'state3Pagination',
      (event) => somePaginationUseCase(),
      (event) => event.pageKey,
    );

    on<UpdateSomeProperty>((event, emit) {
      emit(state.copyWith(someProperty: event.newValue));
    });

    on<UpdateExampleProperty>((event, emit) {
      emit(state.copyWith(exampleProperty: event.newExampleProperty));
    });
  }

  Future<Either<CustomErrorType, String>> someUseCase() {
    return Future.delayed(const Duration(seconds: 2), () {
      return const Right('success');
    });
  }

  Future<Either<CustomErrorType, SomPaginatedData>> somePaginationUseCase() {
    return Future.delayed(
      const Duration(seconds: 2),
      () {
        return Right(
          SomPaginatedData(
            1,
            PaginationModel(
              pageNumber: 1,
              totalPages: 10,
              totalDataCount: 100,
              data: ['Paged data'],
            ),
          ),
        );
      },
    );
  }
}
