import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab3/map_screen.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final String location;

  Appointment({
    required this.title,
    required this.dateTime,
    required this.location,
  });
}

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

void _goToLocation(String location) async {
  // Assuming location is a string like "latitude,longitude".
  var uri = Uri.parse("google.navigation:q=$location&mode=d");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $uri';
  }
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
      '${appointment.title} at ${appointment.location} is scheduled for ${appointment.dateTime}',
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(appointments[index].title, textAlign: TextAlign.center),
                    subtitle: Text('${appointments[index].dateTime}\nLocation: ${appointments[index].location}', textAlign: TextAlign.center),
                  ),
                  ElevatedButton(
                    onPressed: () => _goToLocation(appointments[index].location),
                    child: Text('Go to location'),
                  ),
                ],
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
  String _appointmentLocation = 'Placeholder Location'; // Updated for simplicity

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

  // Placeholder function for map location picking
  Future<void> _pickLocation(BuildContext context) async {
    final LatLng? selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation != null) {
      // Use selectedLocation to update the location field or state
      setState(() {
        _appointmentLocation = "${selectedLocation.latitude}, ${selectedLocation.longitude}";
      });
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                initialValue: _appointmentLocation, // Display the picked or default location
                onSaved: (value) {
                  _appointmentLocation = value!;
                },
              ),
              ElevatedButton(
                onPressed: () => _pickLocation(context),
                child: Text('Pick Location on Map'),
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
              Navigator.of(context).pop(Appointment(title: _appointmentTitle, dateTime: _selectedDate, location: _appointmentLocation));
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
                    subtitle: Text('${_selectedAppointments[index].dateTime}\nLocation: ${_selectedAppointments[index].location}'),
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
