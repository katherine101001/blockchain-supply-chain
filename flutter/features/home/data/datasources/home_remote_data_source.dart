import '../models/product_scan_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductScanModel>> fetchRecentScans();
  Future<void> postScan(String sku);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // final http.Client client; // Inject client here later

  @override
  Future<List<ProductScanModel>> fetchRecentScans() async {
    // No longer used - we use SharedPreferences only
    // Return empty list to avoid mock data
    return [];
  }

  @override
  Future<void> postScan(String sku) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    // Here you would POST to your FastAPI backend
    // final response = await client.post(...)
  }
}
