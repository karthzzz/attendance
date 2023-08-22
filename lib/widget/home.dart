import 'package:attendance1/excel_file_operation/excel_retrieve_data_operation.dart';
import 'package:attendance1/widget/faculty/faculty_login.dart';
import 'package:attendance1/widget/faculty/faculty_register.dart';
import 'package:attendance1/widget/student_home.dart';
import 'package:flutter/material.dart';
 
import 'admin/admin.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NRIIT'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              label: 'Admin',
              icon: Icons.admin_panel_settings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Button(
                label: 'Faculty',
                icon: Icons.school,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FacultyLoginScreen(),
                    ),
                  );
                }),
            SizedBox(height: 20),
            Button(
                label: 'Student',
                icon: Icons.person,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentHome(),
                    ),
                  );
                  // Add navigation logic for Student
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
      icon: Icon(icon),
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
