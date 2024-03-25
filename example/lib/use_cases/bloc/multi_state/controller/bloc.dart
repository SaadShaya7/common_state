import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:example/models/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/utils.dart';

part 'event.dart';
part 'state.dart';

class MultiStateBloc extends Bloc<CommonStateEvent, MultiStateBlocState> {
  MultiStateBloc() : super(MultiStateBlocState()) {
    // Use this
    apiCall<Fetch, String>((event) => someUseCase(), stateName: 'state1');

    paginatedApiCall<FetchPagination, SomPaginatedData>(
      (event) => somePaginationUseCase(),
      (event) => event.pageKey,
      stateName: 'state3Pagination',
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
