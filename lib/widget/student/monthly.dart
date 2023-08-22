import 'package:flutter/material.dart';

void main() {
  runApp(Monthly());
}

class Monthly extends StatelessWidget {
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
  String selectedMonth = 'January'; // Default selected month

  List<DataColumn> _getColumnHeaders() {
    final headers = ['Roll No', 'T-Present', 'T-Absent', 'AVG'];
    return headers
        .map((header) =>
            DataColumn(label: Text(header, style: TextStyle(fontSize: 16))))
        .toList();
  }

  List<DataRow> _getTableRows() {
    final rows = <DataRow>[];

    // Create fewer empty rows
    for (int i = 1; i <= 3; i++) {
      rows.add(DataRow(cells: [
        DataCell(Container(child: Center(child: Text('')))),
        DataCell(Container(child: Center(child: Text('')))),
        DataCell(Container(child: Center(child: Text('')))),
        DataCell(Container(child: Center(child: Text('')))),
      ]));
    }

    return rows;
  }

  void _onMonthChanged(String? newMonth) {
    if (newMonth != null) {
      setState(() {
        selectedMonth = newMonth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Roll Number Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Roll Number',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text(
                  'Month:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedMonth,
                  onChanged: _onMonthChanged,
                  items: <String>[
                    'January',
                    'February',
                    'March',
                    'April',
                    'May',
                    'June',
                    'July',
                    'August',
                    'September',
                    'October',
                    'November',
                    'December',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 30, // Adjust the spacing between columns
                columns: _getColumnHeaders(),
                rows: _getTableRows(),
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
