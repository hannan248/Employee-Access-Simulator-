import 'employee.dart';

class AccessResult {
  final Employee employee;
  final bool granted;
  final String reason;
  final int processOrder;

  const AccessResult({
    required this.employee,
    required this.granted,
    required this.reason,
    required this.processOrder,
  });

  factory AccessResult.granted({
    required Employee employee,
    required String room,
    required int processOrder,
  }) {
    return AccessResult(
      employee: employee,
      granted: true,
      reason: 'Access granted to $room',
      processOrder: processOrder,
    );
  }

  factory AccessResult.denied({
    required Employee employee,
    required String reason,
    required int processOrder,
  }) {
    return AccessResult(
      employee: employee,
      granted: false,
      reason: 'Denied: $reason',
      processOrder: processOrder,
    );
  }

  @override
  String toString() {
    return 'AccessResult{employee: ${employee.id}, granted: $granted, reason: $reason, processOrder: $processOrder}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AccessResult &&
              runtimeType == other.runtimeType &&
              employee == other.employee &&
              granted == other.granted &&
              reason == other.reason &&
              processOrder == other.processOrder;

  @override
  int get hashCode =>
      employee.hashCode ^ granted.hashCode ^ reason.hashCode ^ processOrder.hashCode;
}