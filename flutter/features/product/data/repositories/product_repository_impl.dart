import '../../domain/entities/product.dart';
import '../../domain/entities/trace_log.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product> getProductSummary(String sku) async {
    return remoteDataSource.getProductSummary(sku);
  }

  @override
  Future<(ProductFull, List<TraceLog>, bool)> getFullProduct(
    String sku, {
    bool verify = false,
  }) async {
    final (product, traceLogs, verified) =
        await remoteDataSource.getFullProduct(sku, verify: verify);

    return (product, traceLogs, verified);
  }

  @override
  Future<List<TraceLog>> getTraceLogs(String sku) async {
    return remoteDataSource.getTraceLogs(sku);
  }
}


