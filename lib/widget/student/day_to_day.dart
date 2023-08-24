import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DaytoDay());
}

class DaytoDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roll Number Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Student> presentStudent = [];
  DateTime selectedDate = DateTime.now();
  List<String> listAttendance = [];

  @override
  void initState() {
    retrieveStudents();
    retrieveAttendanceForPeriod("period1");
    super.initState();
  }

  void retrieveStudents() async {
    await retrieveStudentsOnly().then((value) {
      setState(() {
        presentStudent = value;
      });
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void retrieveAttendanceForPeriod(String period) async {
    for (var student in presentStudent) {
      await retrieveAttendance(student.roll_number, period).then((value) {
        setState(() {
          listAttendance.add(value.toString());
        });
      });
    }
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Number Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search Roll Number',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text(
                    'Date:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20.0),
              //create the data table in flutter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'Roll Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Period1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: presentStudent
                      .map(
                        (student) => DataRow(
                          cells: [
                            DataCell(
                              Text(
                                student.roll_number,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                listAttendance[count++],
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
