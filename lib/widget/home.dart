import 'package:attendance1/widget/admin/admin.dart';
import 'package:attendance1/widget/faculty/faculty_login.dart';
import 'package:attendance1/widget/faculty/faculty_register.dart';
import 'package:attendance1/widget/student/student_home.dart';
import 'package:attendance1/widget/student/student_login_register.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Route _createRoute() {
      return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          reverseTransitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.elasticInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation ),
              child: child,
            );
          });
    }

    final userColoScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NRIIT Attendance',
          style: TextStyle(color: userColoScheme.inverseSurface),
        ),
        elevation: 0, // Remove shadow from app bar
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context)
            .colorScheme
            .onPrimaryContainer, // Dark blue app bar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.tertiaryContainer,
            ],
          ),
        ), // Darker background color
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Hello, Attendees!',
              style: TextStyle(
                color: userColoScheme.onPrimaryContainer,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ButtonWithImage(
              label: 'Admin',
              icon: Icons.admin_panel_settings,
              color: const Color(0xFFE57373), // Light red button color
              onPressed: () {
                Navigator.push(context, _createRoute());
              },
            ),
            const SizedBox(height: 10),
            ButtonWithImage(
              label: 'Faculty',
              icon: Icons.school,
              color: const Color(0xFF81C784), // Light green button color
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacultyRegistrationScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ButtonWithImage(
              label: 'Student',
              icon: Icons.person,
              color: const Color(0xFF9575CD), // Light purple button color
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentLoginRegister(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWithImage extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const ButtonWithImage({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
