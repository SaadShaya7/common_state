import 'package:common_state/common_state.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleStatePaginationCubit extends Cubit<PaginationState<PaginationModel, String>> {
  SingleStatePaginationCubit() : super(PaginationState());

  void fetch(int pageKey) => paginatedApiCall<PaginationModel, String>(
        () async {
          await Future.delayed(const Duration(seconds: 2));

          return Right(
            PaginationModel<String>(
              pageNumber: pageKey,
              totalPages: 5,
              totalDataCount: 50,
              data: ['data', 'data', 'data', 'data', 'data', 'data', 'data', 'data', 'data', 'data'],
            ),
          );
        },
        pageKey,
      );
}
