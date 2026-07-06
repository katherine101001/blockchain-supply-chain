import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/domain/entities/product_scan.dart';

class SharedPreferencesService {
  static const String _recentScansKey = 'recent_scans';
  static const int _maxScansCount = 50; // Limit stored scans

  /// Get recent scans from local storage
  Future<List<ProductScan>> getRecentScans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scansJson = prefs.getStringList(_recentScansKey) ?? [];
      
      return scansJson
          .map((json) => _scanFromJson(jsonDecode(json)))
          .toList()
          ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt)); // Sort by newest first
    } catch (e) {
      return [];
    }
  }

  /// Save recent scans to local storage
  Future<void> saveRecentScans(List<ProductScan> scans) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Limit the number of scans to store
      final limitedScans = scans.take(_maxScansCount).toList();
      
      final scansJson = limitedScans
          .map((scan) => jsonEncode(_scanToJson(scan)))
          .toList();
      
      await prefs.setStringList(_recentScansKey, scansJson);
    } catch (e) {
      // Handle error silently for now
    }
  }

  /// Add a new scan to local storage
  Future<void> addScan(ProductScan scan) async {
    try {
      final currentScans = await getRecentScans();
      
      // Remove if scan with same SKU already exists (avoid duplicates)
      currentScans.removeWhere((existingScan) => existingScan.sku == scan.sku);
      
      // Add new scan at the beginning
      currentScans.insert(0, scan);
      
      await saveRecentScans(currentScans);
    } catch (e) {
      // Handle error silently for now
    }
  }

  /// Add a new scan by SKU (convenience method)
  Future<void> addScanBySku(String sku, {String? location}) async {
    final scan = ProductScan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sku: sku,
      scannedAt: DateTime.now(),
      location: location ?? 'Unknown',
      isVerified: true, // Assume verified for now
    );
    
    await addScan(scan);
  }

  /// Clear all recent scans
  Future<void> clearRecentScans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentScansKey);
    } catch (e) {
      // Handle error silently for now
    }
  }

  /// Convert ProductScan to JSON
  Map<String, dynamic> _scanToJson(ProductScan scan) {
    return {
      'id': scan.id,
      'sku': scan.sku,
      'scannedAt': scan.scannedAt.toIso8601String(),
      'location': scan.location,
      'isVerified': scan.isVerified,
    };
  }

  /// Convert JSON to ProductScan
  ProductScan _scanFromJson(Map<String, dynamic> json) {
    return ProductScan(
      id: json['id'] as String,
      sku: json['sku'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      location: json['location'] as String?,
      isVerified: json['isVerified'] as bool? ?? true,
    );
  }
}
