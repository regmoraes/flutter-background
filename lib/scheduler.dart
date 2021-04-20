import 'package:workmanager/workmanager.dart';

void scheduleJob() {
  Workmanager.registerOneOffTask(
    "background-task-id",
    "schedule",
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresCharging: true,
    ),
  );
}
