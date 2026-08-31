enum SaleStatus { paid, open, voided }

class StaffUser {
  final String userId;
  final String username;
  final String fullName;
  final String role; // admin | manager | cashier

  const StaffUser({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
  });
}

class SalesSummaryPoint {
  final DateTime date;
  final double totalRevenue;
  final int transactionCount;

  const SalesSummaryPoint({
    required this.date,
    required this.totalRevenue,
    required this.transactionCount,
  });
}

class Sale {
  final String id;
  final String receiptNumber;
  final String customerName;
  final double total;
  final SaleStatus status;
  final String paymentMethod;
  final DateTime createdAt;
  final int itemCount;

  const Sale({
    required this.id,
    required this.receiptNumber,
    required this.customerName,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.itemCount,
  });
}

class LowStockItem {
  final String productId;
  final String productName;
  final String sku;
  final int qtyOnHand;
  final int minThreshold;

  const LowStockItem({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.qtyOnHand,
    required this.minThreshold,
  });

  double get severity => minThreshold == 0 ? 0 : qtyOnHand / minThreshold;
}

class PaymentMethodTotal {
  final String method;
  final double total;
  final double share;

  const PaymentMethodTotal({required this.method, required this.total, required this.share});
}

class TopProduct {
  final String name;
  final int unitsSold;
  final double revenue;

  const TopProduct({required this.name, required this.unitsSold, required this.revenue});
}
