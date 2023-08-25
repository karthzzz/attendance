import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:flutter/material.dart';

class FacultyEditAttendance extends StatefulWidget {
  FacultyEditAttendance({
    super.key,
    required this.roll_number,
    required this.name,
    required this.subject,
    required this.periods,
  });

  final String roll_number;
  final String name;
  final List<String> periods;
  final String subject;

  @override
  State<FacultyEditAttendance> createState() => _FacultyEditAttendanceState();
}

class _FacultyEditAttendanceState extends State<FacultyEditAttendance> {
  bool? attendance = false;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    showAttendance();
    setAttendanceFaculty();
    super.initState();
  }

  void showAttendance() async {
    await retrieveAttendance(widget.roll_number, widget.periods[0])
        .then((value) {
      setState(() {
        attendance = value;
      });
    });
  }

  void updateAttendance(value1) async {
    if (widget.periods.length == 1) {
      await updateAttendanceForPeriodWays(
        widget.roll_number,
        widget.periods[0],
        value1,
      ).then((value) {
        setState(() {
          attendance = value;
        });
      });
    } else if (widget.periods.length > 1) {
      await updateAttendanceForListPeriods(
        widget.roll_number,
        widget.periods,
        value1,
      ).then((value) {
        setState(() {
          attendance = value;
        });
      });
    }
  }

  void setAttendanceFaculty() async {
    if (widget.periods.length == 1) {
      await createAttendanceForStudent(
        widget.roll_number,
        '${dateTime.day}-${dateTime.month}-${dateTime.year}',
        widget.periods[0],
        widget.subject,
        firebaseAuth.currentUser!.displayName!,
      );
    } else if (widget.periods.length > 1) {
      await createAttendanceForStudentEveryPeriods(
        widget.roll_number,
        '${dateTime.day}-${dateTime.month}-${dateTime.year}',
        widget.periods,
        widget.subject,
        firebaseAuth.currentUser!.displayName!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Colors.white,
              Colors.lightBlue,
              Colors.lightGreenAccent,
              Colors.lightBlueAccent,
            ]), // Dark background color
            borderRadius: BorderRadius.circular(10),
          ),
          child: CheckboxListTile(
            title: Text(widget.roll_number),
            subtitle: Text(widget.name),
            value: attendance,
            onChanged: (value) {
              updateAttendance(value);
            },
          )),
    );
  }
}
