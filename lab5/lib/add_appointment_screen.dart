// add_appointment_screen.dart

import 'package:flutter/material.dart';

class Appointment {
  final String title;
  final String dateTime;

  Appointment({required this.title, required this.dateTime});
}

class AddAppointmentScreen extends StatefulWidget {
  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  DateTime? _selectedDateTime;
  final TextEditingController _subjectController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDateTime = combinedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Appointment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Subject:'),
            TextFormField(
              controller: _subjectController,
              // Subject input field
            ),
            SizedBox(height: 16),
            Text('Date and Time:'),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text(_selectedDateTime == null
                  ? 'Select Date and Time'
                  : _selectedDateTime.toString()),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create the appointment object
                if (_subjectController.text.isNotEmpty && _selectedDateTime != null) {
                  final newAppointment = Appointment(
                    title: _subjectController.text,
                    dateTime: 'Date: ${_selectedDateTime!.year}-${_selectedDateTime!.month}-${_selectedDateTime!.day}, Time: ${_selectedDateTime!.hour}:${_selectedDateTime!.minute}',
                  );
                  // Return the new appointment to the previous screen
                  Navigator.of(context).pop(newAppointment);
                }
              },
              child: Text('Save Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }
}
