import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colloquiums and Exams'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newAppointment = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddAppointmentDialog();
                },
              );

              if (newAppointment != null) {
                setState(() {
                  appointments.add(newAppointment);
                });
              }
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: appointments.length,
        itemBuilder: (BuildContext context, int index) {
          return AppointmentCard(appointment: appointments[index]);
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
  late String appointmentTitle;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Appointment'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Appointment Name'),
            onChanged: (value) {
              appointmentTitle = value;
            },
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Text('Date: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}'),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Text('Time: ${selectedTime.format(context)}'),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text('Select Time'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(
              Appointment(
                title: appointmentTitle,
                dateTime: DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                ),
              ),
            );
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appointment.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text('Date: ${appointment.dateTime.day}-${appointment.dateTime.month}-${appointment.dateTime.year}'),
            Text('Time: ${appointment.dateTime.hour}:${appointment.dateTime.minute}'),
          ],
        ),
      ),
    );
  }
}
