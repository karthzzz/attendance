import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:attendance1/widget/student_list.dart';
import 'package:flutter/material.dart';

class ListOfStudent extends StatefulWidget {
  const ListOfStudent({
    super.key,
    required this.section,
    required this.branch,
     
  });

  final String section;
  final String branch;
   

  @override
  State<ListOfStudent> createState() => _ListOfStudentState();
}

class _ListOfStudentState extends State<ListOfStudent> {
  List<Student> presentStudent = [];
  bool attandencesList = false;
  String period = 'period1';
  Widget? content;
  bool isChangePeriod = false;

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
    print(presentStudent);
  }

  @override
  Widget build(BuildContext context) {
    if (isChangePeriod) {
      Future.delayed(Duration(seconds: 2));
      isChangePeriod = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.branch} - ${widget.section}"),
        actions: [
          DropdownButton(
            value: period,
            hint: const Text("Enter branch"),
            icon: const Icon(Icons.home_work_outlined),
            items: [
              "period1",
              "period2",
              "period3",
              "period4",
              "period5",
              "period6",
              "period7",
              "period8"
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (value) {
              setState(() {
                period = value!;
                isChangePeriod = true;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white10, Colors.lightBlue, Colors.green])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isChangePeriod)
                CircularProgressIndicator()
              else
                ...presentStudent.map(
                  (e) => StudentList(
                      roll_number: e.roll_number,
                      name: e.name,
                      period: period,
                      key: GlobalKey()),
                )
            ],
          ),
        ),
      ),
    );
  }
}
