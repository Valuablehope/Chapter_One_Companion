import 'models.dart';

class DashboardSnapshot {
  final double todaySalesTotal;
  final int todayTransactionCount;
  final List<TopProduct> topProducts;
  final List<LowStockItem> lowStockItems;
  final DateTime generatedAt;

  const DashboardSnapshot({
    required this.todaySalesTotal,
    required this.todayTransactionCount,
    required this.topProducts,
    required this.lowStockItems,
    required this.generatedAt,
  });

  double get averageTicket =>
      todayTransactionCount == 0 ? 0 : todaySalesTotal / todayTransactionCount;

  factory DashboardSnapshot.fromJson(Map<String, dynamic> json) {
    final products = (json['topProducts'] as List<dynamic>? ?? [])
        .map((p) => TopProduct(
              name: p['name'] as String,
              unitsSold: (p['quantitySold'] as num).toInt(),
              revenue: (p['revenue'] as num?)?.toDouble() ?? 0,
            ))
        .toList();

    final lowStock = (json['lowStockItems'] as List<dynamic>? ?? [])
        .map((i) => LowStockItem(
              productId: i['name'] as String,
              productName: i['name'] as String,
              sku: '',
              qtyOnHand: (i['quantity'] as num).toInt(),
              minThreshold: (i['reorderLevel'] as num?)?.toInt() ?? 0,
            ))
        .toList();

    return DashboardSnapshot(
      todaySalesTotal: (json['todaySalesTotal'] as num?)?.toDouble() ?? 0,
      todayTransactionCount: (json['todayTransactionCount'] as num?)?.toInt() ?? 0,
      topProducts: products,
      lowStockItems: lowStock,
      generatedAt: DateTime.fromMillisecondsSinceEpoch((json['generatedAt'] as num).toInt()),
    );
  }
}
