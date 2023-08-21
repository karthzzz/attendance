import 'package:flutter/material.dart';
import 'post_attendance.dart'; // Import the PostAttendancePage class from the appropriate file

class FacultyEditAttendance extends StatelessWidget {
  void _navigateToAttendancePage(BuildContext context, String branch) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostAttendancePage(branch: branch),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance'),
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
            Button(
              label: 'Edit 20KP IT Attendance',
              width: 250,
              onTap: () {
                _navigateToAttendancePage(context, '20KP IT');
              },
            ),
            SizedBox(height: 20),
            Button(
              label: 'Edit 20KP DS Attendance',
              width: 250,
              onTap: () {
                _navigateToAttendancePage(context, '20KP DS');
              },
            ),
            SizedBox(height: 20),
            Button(
              label: 'Edit 21KP IT Attendance',
              width: 250,
              onTap: () {
                _navigateToAttendancePage(context, '21KP IT');
              },
            ),
            SizedBox(height: 20),
            Button(
              label: 'Edit 21KP DS Attendance',
              width: 250,
              onTap: () {
                _navigateToAttendancePage(context, '21KP DS');
              },
            ),
            // Add more buttons here...
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final double width;
  final VoidCallback onTap;

  const Button(
      {Key? key, required this.label, required this.width, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        fixedSize: Size(width, 50),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
