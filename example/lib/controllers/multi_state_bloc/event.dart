abstract class CommonStateEvent {}

class Fetch extends CommonStateEvent {}

class FetchPagination extends CommonStateEvent {
  final int pageKey;

  FetchPagination({required this.pageKey});
}

class UpdateSomeProperty extends CommonStateEvent {
  final bool newValue;
  UpdateSomeProperty(this.newValue);
}
