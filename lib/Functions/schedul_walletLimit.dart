import 'package:workmanager/workmanager.dart';

void scheduleMonthlyReset() {
  Workmanager().registerPeriodicTask(
    "walletReset", // Unique task identifier
    "resetWalletTask",
    frequency: const Duration(days: 30), // Approximate periodic task
    initialDelay:
        calculateInitialDelay(), // Ensures it starts on the first day of the month
    inputData: {"limit": 200000}, // Optional input data
  );
}

Duration calculateInitialDelay() {
  final now = DateTime.now();
  final firstOfNextMonth = DateTime(now.year, now.month + 1, 1);
  return firstOfNextMonth.difference(now);
}
