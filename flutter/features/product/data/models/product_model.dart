import '../../domain/entities/product.dart';
import '../../domain/entities/trace_log.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.sku,
    required super.productType,
    required super.price,
    required super.availability,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      sku: json['sku'] as String,
      productType: json['product_type'] as String,
      price: (json['price'] as num).toDouble(),
      availability: (json['availability'] as num).toInt(),
    );
  }
}

class ProductFullModel extends ProductFull {
  const ProductFullModel({
    required super.sku,
    required super.productType,
    required super.price,
    required super.availability,
    required super.numProductsSold,
    required super.revenueGenerated,
    required super.customerDemographics,
    required super.orderQuantities,
    required super.leadTimes,
    required super.stockLevels,
    required super.productionVolumes,
    required super.manufacturingLeadTime,
    required super.manufacturingCosts,
    required super.inspectionResults,
    required super.defectRates,
    required super.shippingTimes,
    required super.shippingCarriers,
    required super.shippingCosts,
    required super.transportationModes,
    required super.routes,
    required super.costs,
    required super.supplierName,
    required super.location,
    required super.recordHash,
  });

  factory ProductFullModel.fromJson(Map<String, dynamic> json) {
    return ProductFullModel(
      sku: json['sku'] as String,
      productType: json['product_type'] as String,
      price: (json['price'] as num).toDouble(),
      availability: (json['availability'] as num).toInt(),
      numProductsSold: (json['num_products_sold'] as num).toInt(),
      revenueGenerated: (json['revenue_generated'] as num).toDouble(),
      customerDemographics: json['customer_demographics'] as String,
      stockLevels: (json['stock_levels'] as num).toInt(),
      leadTimes: (json['lead_times'] as num).toInt(),
      orderQuantities: (json['order_quantities'] as num).toInt(),
      shippingTimes: (json['shipping_times'] as num).toInt(),
      shippingCarriers: json['shipping_carriers'] as String,
      shippingCosts: (json['shipping_costs'] as num).toDouble(),
      supplierName: json['supplier_name'] as String,
      location: json['location'] as String,
      productionVolumes: (json['production_volumes'] as num).toInt(),
      manufacturingLeadTime:
          (json['manufacturing_lead_time'] as num).toInt(),
      manufacturingCosts: (json['manufacturing_costs'] as num).toDouble(),
      inspectionResults: json['inspection_results'] as String,
      defectRates: (json['defect_rates'] as num).toDouble(),
      transportationModes: json['transportation_modes'] as String,
      routes: json['routes'] as String,
      costs: (json['costs'] as num).toDouble(),
      recordHash: json['record_hash'] as String?,
    );
  }
}

class TraceLogModel extends TraceLog {
  const TraceLogModel({
    required super.timestamp,
    required super.blockchainNetwork,
    required super.status,
    required super.txHash,
    required super.verified,
  });

  factory TraceLogModel.fromJson(Map<String, dynamic> json) {
    return TraceLogModel(
      timestamp: DateTime.parse(json['timestamp'] as String),
      blockchainNetwork: json['blockchain_network'] as String,
      status: json['status'] as String,
      txHash: json['tx_hash'] as String,
      verified: json['verified'] as bool?,
    );
  }
}


