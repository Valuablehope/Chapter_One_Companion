import 'models.dart';

SaleStatus _parseSaleStatus(String raw) {
  switch (raw) {
    case 'paid':
      return SaleStatus.paid;
    case 'open':
      return SaleStatus.open;
    case 'void':
    case 'refunded':
      return SaleStatus.voided;
    default:
      return SaleStatus.open;
  }
}

List<TopProduct> _parseTopProducts(dynamic json) {
  return (json as List<dynamic>? ?? [])
      .map((p) => TopProduct(
            name: p['name'] as String,
            unitsSold: (p['quantitySold'] as num).toInt(),
            revenue: (p['revenue'] as num?)?.toDouble() ?? 0,
          ))
      .toList();
}

class DashboardSnapshot {
  final double todaySalesTotal;
  final int todayTransactionCount;
  final List<TopProduct> topProducts;
  final List<LowStockItem> lowStockItems;
  final List<Sale> recentSales;
  final List<SalesSummaryPoint> weeklySummary;
  final List<TopProduct> topProductsWeek;
  final List<PaymentMethodTotal> paymentBreakdown;
  final DateTime generatedAt;

  const DashboardSnapshot({
    required this.todaySalesTotal,
    required this.todayTransactionCount,
    required this.topProducts,
    required this.lowStockItems,
    required this.recentSales,
    required this.weeklySummary,
    required this.topProductsWeek,
    required this.paymentBreakdown,
    required this.generatedAt,
  });

  double get averageTicket =>
      todayTransactionCount == 0 ? 0 : todaySalesTotal / todayTransactionCount;

  factory DashboardSnapshot.fromJson(Map<String, dynamic> json) {
    final lowStock = (json['lowStockItems'] as List<dynamic>? ?? [])
        .map((i) => LowStockItem(
              productId: i['name'] as String,
              productName: i['name'] as String,
              sku: '',
              qtyOnHand: (i['quantity'] as num).toInt(),
              minThreshold: (i['reorderLevel'] as num?)?.toInt() ?? 0,
            ))
        .toList();

    final sales = (json['recentSales'] as List<dynamic>? ?? [])
        .map((s) => Sale(
              id: s['id'] as String,
              receiptNumber: s['receiptNumber'] as String,
              customerName: s['customerName'] as String,
              total: (s['total'] as num).toDouble(),
              status: _parseSaleStatus(s['status'] as String),
              paymentMethod: s['paymentMethod'] as String,
              createdAt: DateTime.fromMillisecondsSinceEpoch((s['createdAt'] as num).toInt()),
              itemCount: (s['itemCount'] as num).toInt(),
            ))
        .toList();

    final weeklySummary = (json['weeklySummary'] as List<dynamic>? ?? [])
        .map((w) => SalesSummaryPoint(
              date: DateTime.parse(w['date'] as String),
              totalRevenue: (w['totalRevenue'] as num).toDouble(),
              transactionCount: (w['transactionCount'] as num).toInt(),
            ))
        .toList();

    final paymentRows = (json['paymentBreakdown'] as List<dynamic>? ?? [])
        .map((p) => (method: p['method'] as String, total: (p['totalAmount'] as num).toDouble()))
        .toList();
    final paymentTotalSum = paymentRows.fold<double>(0, (a, b) => a + b.total);
    final paymentBreakdown = paymentRows
        .map((p) => PaymentMethodTotal(
              method: p.method,
              total: p.total,
              share: paymentTotalSum == 0 ? 0 : p.total / paymentTotalSum,
            ))
        .toList();

    return DashboardSnapshot(
      todaySalesTotal: (json['todaySalesTotal'] as num?)?.toDouble() ?? 0,
      todayTransactionCount: (json['todayTransactionCount'] as num?)?.toInt() ?? 0,
      topProducts: _parseTopProducts(json['topProducts']),
      lowStockItems: lowStock,
      recentSales: sales,
      weeklySummary: weeklySummary,
      topProductsWeek: _parseTopProducts(json['topProductsWeek']),
      paymentBreakdown: paymentBreakdown,
      generatedAt: DateTime.fromMillisecondsSinceEpoch((json['generatedAt'] as num).toInt()),
    );
  }
}
