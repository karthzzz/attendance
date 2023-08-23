 import 'package:flutter/material.dart';
import 'faculty_post_attendance.dart'; // Import the faculty_post_attendance.dart file
 // Import the faculty_edit_attendance.dart file

class FacultyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Home'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
                label: 'Post Attendance',
                icon: Icons.calendar_today,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FacultyPostAttendance()),
                  );
                }),
            SizedBox(height: 20),
            Button(
                label: 'Edit Attendance',
                icon: Icons.edit,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Center(child: Text("Madan"),)),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const Button(
      {Key? key, required this.label, required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        fixedSize: Size(200, 50),
      ),
    );
  }
}
