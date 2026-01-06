class ApiResponse<T> {
  final bool success;
  final T? data;
  final String error;

  const ApiResponse({
    this.success = false,
    this.data,
    this.error = '',
  });

  factory ApiResponse.parse(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
  }) =>
      ApiResponse(
        error: json['error'] ?? '',
        success: json['success'] ?? false,
        data: fromJsonT == null ? json['data'] : fromJsonT(json['data']),
      );

  factory ApiResponse.error({String error = ""}) => ApiResponse(success: false, data: null, error: error);
}

class ApiListResponse<T> {
  final bool success;
  final List<T> data;
  final int count;
  final String error;
  final double? openingLoad;
  final double? currentLoad;
  final double? openingCash;
  final double? currentCash;
  final double? remainingCreditLimit;
  final double? loadOrdered;
  final double? loadUnordered;
  final double? creditLimit;

  const ApiListResponse({
    this.success = false,
    this.data = const [],
    this.count = 0,
    this.error = '',
    this.currentCash,
    this.openingCash,
    this.openingLoad,
    this.currentLoad,
    this.creditLimit,
    this.remainingCreditLimit,
    this.loadOrdered,
    this.loadUnordered,
  });

  factory ApiListResponse.parse(
    Map<String, dynamic> json, {
    T Function(dynamic json)? fromJsonT,
  }) {
    if (json['data'] == null) return ApiListResponse(success: false, data: [], count: json['count']);

    return ApiListResponse(
      success: json['success'] ?? false,
      data: List<T>.from((json['data'] is List<dynamic> ? json['data'] : json['data']['rows']).map((x) => fromJsonT!(x))),
      count: json['data'] is List<dynamic> ? 0 : json['data']['count'] ?? 0,
      error: json['error'] ?? '',
      currentCash: double.tryParse(json['currentCash'].toString()),
      openingCash: double.tryParse(json['openingCash'].toString()),
      openingLoad: double.tryParse(json['openingLoad'].toString()),
      currentLoad: double.tryParse(json['currentLoad'].toString()),
      creditLimit: double.tryParse(json['creditLimit'].toString()),
      remainingCreditLimit: double.tryParse(json['remainingCreditLimit'].toString()),
      loadOrdered: double.tryParse(json['loadOrdered'].toString()),
      loadUnordered: double.tryParse(json['loadUnordered'].toString()),
    );
  }

  factory ApiListResponse.error() => ApiListResponse(success: false, data: [], count: 0, error: "");
}
