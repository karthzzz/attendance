import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PostAttendancePage(branch: 'Sample Branch'),
  ));
}

class PostAttendancePage extends StatefulWidget {
  final String branch;

  PostAttendancePage({required this.branch});

  @override
  _PostAttendancePageState createState() => _PostAttendancePageState();
}

class _PostAttendancePageState extends State<PostAttendancePage> {
  String selectedHour = '1';
  String selectedSubject = 'Java'; // Default subject
  DateTime selectedDate = DateTime.now();

  List<String> attendanceStatus = ['P', 'P', 'P']; // Default attendance status

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  List<TableRow> generateTableRows() {
    List<TableRow> rows = [];
    for (int i = 1; i <= 3; i++) {
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('Roll $i'),
              ),
            ),
            TableCell(
              child: Radio(
                value: 'P',
                groupValue: attendanceStatus[i - 1],
                onChanged: (value) {
                  setState(() {
                    attendanceStatus[i - 1] = value as String;
                  });
                },
              ),
            ),
            TableCell(
              child: Radio(
                value: 'A',
                groupValue: attendanceStatus[i - 1],
                onChanged: (value) {
                  setState(() {
                    attendanceStatus[i - 1] = value as String;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.branch} Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date:',
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                "${selectedDate.toLocal()}".split(' ')[0],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Hour:',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(
              value: selectedHour,
              onChanged: (newValue) {
                setState(() {
                  selectedHour = newValue!;
                });
              },
              items: List.generate(8, (index) {
                return DropdownMenuItem(
                  value: (index + 1).toString(),
                  child: Text('Hour ${index + 1}'),
                );
              }),
            ),
            SizedBox(height: 20),
            Text(
              'Subject:',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(
              value: selectedSubject,
              onChanged: (newValue) {
                setState(() {
                  selectedSubject = newValue!;
                });
              },
              items: [
                'Java',
                'Python',
                'C',
                'C++',
                'DS',
                // Add more subjects here
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Roll No',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'P',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'A',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ...generateTableRows(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
