import '../entities/product_scan.dart';

abstract class HomeRepository {
  Future<List<ProductScan>> getRecentScans();
  Future<void> addScan(String sku);
}
