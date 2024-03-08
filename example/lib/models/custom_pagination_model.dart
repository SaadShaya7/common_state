import 'package:common_state/common_state.dart';

class CustomPaginationModel implements PaginatedData<String> {
  final String property1;
  final int property2;
  final PaginationModel<String> paginationProperty;

  CustomPaginationModel(this.property1, this.property2, this.paginationProperty);

  @override
  PaginationModel<String> get paginatedData => paginationProperty;
}
