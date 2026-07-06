import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductSummary(String sku);
  Future<(ProductFullModel, List<TraceLogModel>, bool)> getFullProduct(
    String sku, {
    bool verify,
  });
  Future<List<TraceLogModel>> getTraceLogs(String sku);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl({Dio? client})
    : _client = client ?? ApiClient().client;

  final Dio _client;

  String _dioErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please check if the server is running.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server. Please check:\n'
          '1. Server is running at ${_client.options.baseUrl}\n'
          '2. For Android emulator, use 10.0.2.2:8000\n'
          '3. For physical device, use your computer IP address';
    }
    if (e.response != null) {
      return 'Server error: ${e.response?.statusCode} - ${e.response?.statusMessage}';
    }
    return 'Connection error';
  }

  @override
  Future<ProductModel> getProductSummary(String sku) async {
    try {
      final response = await _client.get<Map<String, dynamic>>('/product/$sku');

      if (response.data == null) {
        throw Exception('No data received from API');
      }

      return ProductModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to fetch product summary: ${e.toString()}');
    }
  }

  @override
  Future<(ProductFullModel, List<TraceLogModel>, bool)> getFullProduct(
    String sku, {
    bool verify = false,
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '/product/$sku',
        queryParameters: {'full': true, if (verify) 'verify': true},
      );

      if (response.data == null) {
        throw Exception('No data received from API');
      }

      final data = response.data!;

      final productJson = data.containsKey('product')
          ? data['product'] as Map<String, dynamic>
          : data;

      final product = ProductFullModel.fromJson(productJson);

      final List<TraceLogModel> traceLogs;
      bool verified = false;

      if (data.containsKey('trace_logs')) {
        final logsJson = data['trace_logs'] as List<dynamic>;
        traceLogs = logsJson
            .map((e) => TraceLogModel.fromJson(e as Map<String, dynamic>))
            .toList();
        verified = traceLogs.any((log) => log.verified == true);
      } else {
        traceLogs = [];
      }

      return (product, traceLogs, verified);
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to fetch full product: ${e.toString()}');
    }
  }

  @override
  Future<List<TraceLogModel>> getTraceLogs(String sku) async {
    try {
      // Convert SKU to lowercase to match API format
      //final normalizedSku = sku.toLowerCase();
      final response = await _client.get<List<dynamic>>('/product/$sku/trace');

      final data = response.data ?? [];
      return data
          .map((e) => TraceLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(_dioErrorMessage(e));
    } catch (e) {
      throw Exception('Failed to fetch trace logs: ${e.toString()}');
    }
  }
}
