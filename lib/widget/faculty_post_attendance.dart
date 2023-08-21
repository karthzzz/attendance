import 'package:flutter/material.dart';
import 'post_attendance.dart'; // Replace 'sample.dart' with the correct import path for your 'post_attendance_page.dart'

void main() => runApp(MaterialApp(
      home: FacultyPostAttendance(),
    ));

class FacultyPostAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Attendance'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school,
                  size: 30,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  'Faculty',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Button(label: 'Post 20KP IT Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 20KP DS Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 21KP IT Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 21KP DS-A Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 21KP DS-B Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 22KP IT Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 22KP DS-A Attendance', width: 250),
            SizedBox(height: 20),
            Button(label: 'Post 22KP DS-B Attendance', width: 250),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final double? width;

  const Button({Key? key, required this.label, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostAttendancePage(branch: label)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        fixedSize: Size(width ?? 200, 50),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
