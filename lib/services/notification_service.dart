import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    //For The Basic Functionality of Notification we will use the simple map launcher as our notification logo
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(); //for ios with same logic as above

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  } // <--- THE INIT METHOD ENDS HERE

  Future<void> scheduleTodoNotification({
    required int id,
    required String title,
    required DateTime deadline,
  }) async {
    final scheduledDate = tz.TZDateTime.from(
      deadline.subtract(const Duration(hours: 1)),
      tz.local,
    );

    //if statment helps us to avoid sending notifications in the past
    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    // Define the details for the notification
    await _notificationsPlugin.zonedSchedule(
      id,
      'Todo Reminder!',
      'Your task "$title" is due in one hour.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel_id',
          'Todo Reminders',
          channelDescription: 'Channel for Todo app reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Method to cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}