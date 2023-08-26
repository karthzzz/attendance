import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'ATTENDANCE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ROLL NUMBER')),
                  DataColumn(label: Text('PRESENT')),
                  DataColumn(label: Text('ABSENT')),
                  DataColumn(label: Text('TOTAL')),
                ],
                rows: List<DataRow>.generate(
                  10, // Replace with your desired number of rows
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('Roll $index')),
                      DataCell(Text('0')), // Replace with your initial data
                      DataCell(Text('0')), // Replace with your initial data
                      DataCell(Text('0')), // Replace with your initial data
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Add action for 'SEND SMS' button
              },
              child: Text('SEND SMS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: TextStyle(fontSize: 20, color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
