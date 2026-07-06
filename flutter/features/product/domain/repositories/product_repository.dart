import '../entities/product.dart';
import '../entities/trace_log.dart';

abstract class ProductRepository {
  Future<Product> getProductSummary(String sku);

  /// Returns full product details.
  ///
  /// When [verify] is true, the backend also performs blockchain verification
  /// and may wrap the product inside a `product` field together with `trace_logs`.
  Future<(ProductFull, List<TraceLog>, bool /* verified */ )> getFullProduct(
    String sku, {
    bool verify = false,
  });

  Future<List<TraceLog>> getTraceLogs(String sku);
}


