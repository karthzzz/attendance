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
  DateTime selectedDate = DateTime.now();

  List<DataColumn> _getColumnHeaders() {
    final headers = ['Roll No', 'I', 'II', '...', 'Total'];
    return headers
        .map<DataColumn>((header) =>
            DataColumn(label: SizedBox(width: 50, child: Text(header))))
        .toList();
  }

  List<DataRow> _getTableRows() {
    final rows = <DataRow>[];

    // Create fewer empty rows
    for (int i = 1; i <= 5; i++) {
      rows.add(DataRow(cells: [
        DataCell(SizedBox(width: 50, child: Text(''))),
        for (int j = 1; j <= 2; j++)
          DataCell(SizedBox(width: 50, child: Text(''))),
        DataCell(SizedBox(width: 50, child: Text('...'))),
        DataCell(SizedBox(width: 50, child: Text(''))),
      ]));
    }

    return rows;
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
                  'Date:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 4, // Adjust the spacing between columns
                columns: _getColumnHeaders(),
                rows: _getTableRows(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
