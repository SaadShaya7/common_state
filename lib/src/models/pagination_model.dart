class PaginationModel<T> {
  final int pageNumber;
  final int totalPages;
  final int totalDataCount;
  final List<T> data;

  PaginationModel({
    required this.pageNumber,
    required this.totalPages,
    required this.totalDataCount,
    required this.data,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json, T Function(dynamic? json) tFromJson) {
    return PaginationModel(
      pageNumber: json['pageNumber'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalDataCount: json['totalDataCount'] ?? 0,
      data: json['data'] is List ? (json['data'] as List).map((e) => tFromJson(e)).toList() : [],
    );
  }
}
