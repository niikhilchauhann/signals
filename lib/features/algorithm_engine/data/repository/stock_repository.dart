import 'package:cupcake/config/api/api_service.dart';

import '../models/ipo_model.dart';

class StockRepository {
  final ApiService _client = ApiService();

  Future<IpoList> fetchAllIpos() async {
    final response = await _client.getRequest('/ipo');

    return IpoList.fromJson(response);
  }
}


