import 'package:flutter/material.dart';
import 'package:tugasakhir/services/timezone_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhir/login_folder/register_screen.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTimezone = 'WIB';
  DateTime _selectedDateTime = DateTime.now();
  final TimezoneService _timezoneService = TimezoneService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(DateTime dailyAnimeWatchTime) async {
    if (dailyAnimeWatchTime.weekday != DateTime.saturday) {
      // If not, find the next Saturday
      dailyAnimeWatchTime = dailyAnimeWatchTime.add(Duration(days: DateTime.saturday - dailyAnimeWatchTime.weekday));
    }

    // Schedule the notification for the next Saturday at the selected time
    final tz.TZDateTime scheduledDateTime = tz.TZDateTime(tz.local, dailyAnimeWatchTime.year,
        dailyAnimeWatchTime.month, dailyAnimeWatchTime.day, dailyAnimeWatchTime.hour, dailyAnimeWatchTime.minute);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Anime Reminder',
      'It\'s time for your daily anime watch!',
      scheduledDateTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'anime_channel',
          'Anime Channel',
          'Channel for anime notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'Scheduled notification',
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement your logout logic here
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notifications Screen',
              style: TextStyle(color: const Color.fromARGB(255, 100, 125, 145), fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedTimezone,
              onChanged: (value) {
                setState(() {
                  _selectedTimezone = value!;
                });
              },
              items: ['WIB', 'WITA', 'WIT', 'London', 'JST']
                  .map((timezone) => DropdownMenuItem<String>(
                        value: timezone,
                        child: Text(timezone),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            Text('Selected Timezone: $_selectedTimezone'),
            SizedBox(height: 10),
            Text('Selected Date & Time: ${_selectedDateTime.toString()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: _selectedDateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                    ).then((selectedTime) {
                      if (selectedTime != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                        _scheduleNotification(_selectedDateTime);
                      }
                    });
                  }
                });
              },
              child: Text('Select Date & Time'),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Time: ${_timezoneService.convertToTimezone(_selectedDateTime, _selectedTimezone)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
