class InsufficientBalanceException implements Exception {
  final double availableBalance;
  final double requiredBalance;

  InsufficientBalanceException({
    required this.availableBalance,
    required this.requiredBalance,
  });

  @override
  String toString() {
    return 'Insufficient balance. only $availableBalance available, but $requiredBalance required.';
  }
}
