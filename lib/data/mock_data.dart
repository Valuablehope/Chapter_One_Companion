import '../models/models.dart';

/// Sample data standing in for the real Chapter One API
/// (GET /api/reports/sales/summary, /api/sales, /api/reports/inventory/low-stock, etc.)
/// so this prototype's screens can be reviewed without a running backend.
class MockData {
  MockData._();

  static const currentUser = StaffUser(
    userId: 'u-001',
    username: 'a.taleb',
    fullName: 'Ali Taleb',
    role: 'manager',
  );

  static DateTime _daysAgo(int d) => DateTime.now().subtract(Duration(days: d));

  static List<SalesSummaryPoint> weeklySummary() {
    final base = [420.0, 610.0, 380.0, 705.0, 890.0, 1180.0, 940.0];
    return List.generate(7, (i) {
      final dayIndex = 6 - i;
      return SalesSummaryPoint(
        date: _daysAgo(dayIndex),
        totalRevenue: base[i],
        transactionCount: 12 + i * 3,
      );
    });
  }

  static double get todayRevenue => weeklySummary().last.totalRevenue;
  static int get todayTransactions => weeklySummary().last.transactionCount;
  static double get weekRevenue => weeklySummary().fold(0.0, (a, b) => a + b.totalRevenue);

  static List<Sale> recentSales() => [
        Sale(
          id: 's-1042',
          receiptNumber: 'RCP-1042',
          customerName: 'Walk-in Customer',
          total: 84.50,
          status: SaleStatus.paid,
          paymentMethod: 'Card',
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
          itemCount: 5,
        ),
        Sale(
          id: 's-1041',
          receiptNumber: 'RCP-1041',
          customerName: 'Sara Haddad',
          total: 212.00,
          status: SaleStatus.paid,
          paymentMethod: 'Cash',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 4)),
          itemCount: 11,
        ),
        Sale(
          id: 's-1040',
          receiptNumber: 'RCP-1040',
          customerName: 'Walk-in Customer',
          total: 36.25,
          status: SaleStatus.voided,
          paymentMethod: 'Card',
          createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
          itemCount: 2,
        ),
        Sale(
          id: 's-1039',
          receiptNumber: 'RCP-1039',
          customerName: 'Omar Fares',
          total: 158.75,
          status: SaleStatus.paid,
          paymentMethod: 'Card',
          createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 45)),
          itemCount: 8,
        ),
        Sale(
          id: 's-1038',
          receiptNumber: 'RCP-1038',
          customerName: 'Walk-in Customer',
          total: 19.00,
          status: SaleStatus.open,
          paymentMethod: '—',
          createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 10)),
          itemCount: 1,
        ),
        Sale(
          id: 's-1037',
          receiptNumber: 'RCP-1037',
          customerName: 'Lea Boutros',
          total: 402.10,
          status: SaleStatus.paid,
          paymentMethod: 'Cash',
          createdAt: DateTime.now().subtract(const Duration(hours: 6, minutes: 2)),
          itemCount: 14,
        ),
      ];

  static List<LowStockItem> lowStock() => const [
        LowStockItem(productId: 'p-01', productName: 'House Blend Coffee 250g', sku: 'CF-250-HB', qtyOnHand: 2, minThreshold: 15),
        LowStockItem(productId: 'p-02', productName: 'Oat Milk 1L', sku: 'DR-OAT-1L', qtyOnHand: 4, minThreshold: 20),
        LowStockItem(productId: 'p-03', productName: 'Paper Cups 12oz (Sleeve)', sku: 'PK-CUP-12', qtyOnHand: 6, minThreshold: 10),
        LowStockItem(productId: 'p-04', productName: 'Almond Croissant', sku: 'BK-CRO-ALM', qtyOnHand: 3, minThreshold: 12),
        LowStockItem(productId: 'p-05', productName: 'Vanilla Syrup 750ml', sku: 'SY-VAN-750', qtyOnHand: 1, minThreshold: 8),
        LowStockItem(productId: 'p-06', productName: 'Napkins (Pack of 100)', sku: 'PK-NAP-100', qtyOnHand: 9, minThreshold: 10),
      ];

  static List<PaymentMethodTotal> paymentBreakdown() => const [
        PaymentMethodTotal(method: 'Card', total: 2840.50, share: 0.62),
        PaymentMethodTotal(method: 'Cash', total: 1420.25, share: 0.31),
        PaymentMethodTotal(method: 'Other', total: 320.00, share: 0.07),
      ];

  static List<TopProduct> topProducts() => const [
        TopProduct(name: 'Cappuccino', unitsSold: 142, revenue: 710.00),
        TopProduct(name: 'House Blend Coffee 250g', unitsSold: 88, revenue: 792.00),
        TopProduct(name: 'Almond Croissant', unitsSold: 76, revenue: 342.00),
        TopProduct(name: 'Iced Latte', unitsSold: 64, revenue: 384.00),
        TopProduct(name: 'Oat Milk 1L', unitsSold: 51, revenue: 204.00),
      ];
}
