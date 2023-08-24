import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/faculty/faculty_edit_attendance.dart';
import 'package:attendance1/widget/student_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class FacultyStudentList extends StatefulWidget {
  const FacultyStudentList({
    super.key,
    required this.branch,
    required this.section,
    required this.year,
    required this.subject,
    required this.teacherName,
    required this.date,
  });

  final String subject;
  final String teacherName;
  final String date;
  final String branch;
  final String section;
  final String year;

  @override
  State<FacultyStudentList> createState() => _FacultyStudentListState();
}

class _FacultyStudentListState extends State<FacultyStudentList> {
  String period = "period1";
  var selectPeriod = ['period1'];
  var listOfPeriod = [
    'period1',
    'period2',
    'period3',
    'period4',
    'period5',
    'period6',
    'period7',
    'period8',
  ];
  bool isChangePeriod = false;
  var presentStudent = [];
  @override
  void initState() {
    showStudents(widget.section, widget.branch);
     
    super.initState();
  }

  void showStudents(String section, String branch) async {
    await retrieveStudents(branch, section).then(
      (value) => setState(
        () {
          presentStudent = value;
        },
      ),
    );
  }

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.branch} - ${widget.section}'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white10, Colors.lightBlue, Colors.green])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropDownMultiSelect(
                options: listOfPeriod,
                validator: (selectedOptions) {
                  if (selectedOptions == null) {
                    return "Invaild";
                  }
                  return "ok";
                },
                selectedValues: selectPeriod,
                onChanged: (p0) {
                  setState(() {
                    selectPeriod = p0;
                  });
                },
              ),
              if (isChangePeriod)
                CircularProgressIndicator()
              else
                ...presentStudent.map(
                  (e) => FacultyEditAttendance(
                      roll_number: e.roll_number,
                      name: e.name,
                      subject: widget.subject,
                      period: selectPeriod[0],
                      key: GlobalKey()),
                )
            ],
          ),
        ),
      ),
    );
  }
}
