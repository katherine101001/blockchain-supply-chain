import '../../domain/entities/product_scan.dart';
import '../../domain/repositories/home_repository.dart';
import '../../../../core/services/shared_preferences_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final SharedPreferencesService sharedPreferencesService;

  HomeRepositoryImpl({required this.sharedPreferencesService});

  @override
  Future<List<ProductScan>> getRecentScans() async {
    // Use only SharedPreferences - no API or mock data
    return await sharedPreferencesService.getRecentScans();
  }

  @override
  Future<void> addScan(String sku) async {
    // Add to local storage only
    await sharedPreferencesService.addScanBySku(sku);
  }
}
