import '../../domain/entities/product_scan.dart';

class ProductScanModel extends ProductScan {
  const ProductScanModel({
    required super.id,
    required super.sku,
    required super.scannedAt,
    super.location,
    super.isVerified = true,
  });

  factory ProductScanModel.fromJson(Map<String, dynamic> json) {
    return ProductScanModel(
      id: json['id'] as String,
      sku: json['sku'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      location: json['location'] as String?,
      isVerified: json['isVerified'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'scannedAt': scannedAt.toIso8601String(),
      'location': location,
      'isVerified': isVerified,
    };
  }
}
