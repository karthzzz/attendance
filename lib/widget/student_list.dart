import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentList extends StatefulWidget {
  // ignore: non_constant_identifier_names
  StudentList({
    super.key,
    required this.roll_number,
    required this.name,
    required this.period,
  });
  final String roll_number;
  final String name;
  final String period;

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
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
            widget.roll_number, widget.period, value1)
        .then((value) {
      setState(() {
        attendance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Card(
                margin:const  EdgeInsets.all(4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(widget.name),
                  subtitle: Text(widget.roll_number),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
