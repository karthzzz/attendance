import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:flutter/material.dart';

class StudentListForStudent extends StatefulWidget {
  StudentListForStudent({
    super.key,
    required this.roll_number,
    required this.name,
    required this.period,
  });

  final String roll_number;
  final String name;
  final String period;

  @override
  State<StudentListForStudent> createState() => _StudentListForStudentState();
}

class _StudentListForStudentState extends State<StudentListForStudent> {
  bool? attendance = false;

  @override
  void initState() {
    showAttendance();
    super.initState();
  }

  void showAttendance() async {
    await retrieveAttendance(widget.roll_number, widget.period).then((value) {
      setState(() {
        attendance = value;
      });
    });
  }

  void updateAttendance(value1) async {
    await updateAttendanceForPeriodWays(
      widget.roll_number,
      widget.period,
      value1,
    ).then((value) {
      setState(() {
        attendance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900], // Dark background color
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            widget.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            widget.roll_number,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          trailing: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: attendance == null
                ? SizedBox.shrink()
                : attendance!
                    ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                    : Icon(Icons.remove_circle, color: Colors.red, size: 20),
          ),
        ),
      ),
    );
  }
}
