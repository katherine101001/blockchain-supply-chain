import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String sku;
  final String productType;
  final double price;
  final int availability;

  const Product({
    required this.sku,
    required this.productType,
    required this.price,
    required this.availability,
  });

  @override
  List<Object?> get props => [sku, productType, price, availability];
}

class ProductFull extends Equatable {
  final String sku;
  final String productType;
  final double price;
  final int availability;

  // Sales & demand
  final int numProductsSold;
  final double revenueGenerated;
  final String customerDemographics;
  final int orderQuantities;
  final int leadTimes;

  // Inventory & supply
  final int stockLevels;
  final int productionVolumes;
  final int manufacturingLeadTime;
  final double manufacturingCosts;

  // Quality & risk
  final String inspectionResults;
  final double defectRates;

  // Logistics
  final int shippingTimes;
  final String shippingCarriers;
  final double shippingCosts;
  final String transportationModes;
  final String routes;
  final double costs;

  // Supplier / meta
  final String supplierName;
  final String location;

  // Blockchain
  final String? recordHash;

  const ProductFull({
    required this.sku,
    required this.productType,
    required this.price,
    required this.availability,
    required this.numProductsSold,
    required this.revenueGenerated,
    required this.customerDemographics,
    required this.orderQuantities,
    required this.leadTimes,
    required this.stockLevels,
    required this.productionVolumes,
    required this.manufacturingLeadTime,
    required this.manufacturingCosts,
    required this.inspectionResults,
    required this.defectRates,
    required this.shippingTimes,
    required this.shippingCarriers,
    required this.shippingCosts,
    required this.transportationModes,
    required this.routes,
    required this.costs,
    required this.supplierName,
    required this.location,
    required this.recordHash,
  });

  @override
  List<Object?> get props => [
        sku,
        productType,
        price,
        availability,
        numProductsSold,
        revenueGenerated,
        customerDemographics,
        orderQuantities,
        leadTimes,
        stockLevels,
        productionVolumes,
        manufacturingLeadTime,
        manufacturingCosts,
        inspectionResults,
        defectRates,
        shippingTimes,
        shippingCarriers,
        shippingCosts,
        transportationModes,
        routes,
        costs,
        supplierName,
        location,
        recordHash,
      ];
}


