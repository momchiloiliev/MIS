import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colloquiums and Exams',
      home: AppointmentsScreen(),
    );
  }
}

class Appointment {
  final String title;
  final DateTime dateTime;

  Appointment({required this.title, required this.dateTime});
}

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Appointment> appointments = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(Appointment appointment) async {
    var androidDetails = AndroidNotificationDetails(
      'appointment_id',
      'Appointment Notifications',
      channelDescription: 'Notification channel for appointment reminders',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSDetails = IOSNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.schedule(
      appointment.hashCode,
      'Appointment Reminder',
      '${appointment.title} is scheduled for ${appointment.dateTime}',
      appointment.dateTime,
      platformDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colloquiums and Exams'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newAppointment = await showDialog<Appointment>(
                context: context,
                builder: (BuildContext context) {
                  return AddAppointmentDialog();
                },
              );

              if (newAppointment != null) {
                setState(() {
                  appointments.add(newAppointment);
                  _scheduleNotification(newAppointment);
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => ExamCalendarDialog(appointments: appointments),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return Card(
            child: Center(
              child: ListTile(
                title: Text(appointments[index].title, textAlign: TextAlign.center),
                subtitle: Text('${appointments[index].dateTime}', textAlign: TextAlign.center),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddAppointmentDialog extends StatefulWidget {
  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  String _appointmentTitle = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Appointment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Appointment Title'),
                onSaved: (value) {
                  _appointmentTitle = value!;
                },
              ),
              ListTile(
                title: Text("Date & Time: ${_selectedDate.toLocal()}".split('.')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _pickDateTime(context),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text('Add'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(Appointment(title: _appointmentTitle, dateTime: _selectedDate));
            }
          },
        ),
      ],
    );
  }
}

class ExamCalendarDialog extends StatefulWidget {
  final List<Appointment> appointments;

  ExamCalendarDialog({required this.appointments});

  @override
  _ExamCalendarDialogState createState() => _ExamCalendarDialogState();
}

class _ExamCalendarDialogState extends State<ExamCalendarDialog> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Appointment> _selectedAppointments = [];

  @override
  void initState() {
    super.initState();
    _selectedAppointments = _getAppointmentsForDay(_selectedDay);
  }

  List<Appointment> _getAppointmentsForDay(DateTime day) {
    return widget.appointments.where((appointment) {
      return day.year == appointment.dateTime.year &&
          day.month == appointment.dateTime.month &&
          day.day == appointment.dateTime.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedAppointments = _getAppointmentsForDay(selectedDay);
                });
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedAppointments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_selectedAppointments[index].title),
                    subtitle: Text('${_selectedAppointments[index].dateTime}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
