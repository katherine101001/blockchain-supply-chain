import 'package:equatable/equatable.dart';

class ProductScan extends Equatable {
  final String id;
  final String sku;
  final DateTime scannedAt;
  final String? location;
  final bool isVerified;

  const ProductScan({
    required this.id,
    required this.sku,
    required this.scannedAt,
    this.location,
    this.isVerified = true,
  });

  @override
  List<Object?> get props => [id, sku, scannedAt, location, isVerified];
}
