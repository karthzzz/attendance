import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Route _createRoute(dynamic str) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => str,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0.0);
          const end = Offset.zero;
          const curve = Curves.decelerate;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  void showSnack(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        elevation: 3,
        title: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        elevation: 0,
        
      ),
      body: Container(
         
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ADMIN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await signWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (result) {
                  showSnack("Success");
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacement(_createRoute(BranchesPage()));
                } else {
                  showSnack("Failed");
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton(
                onPressed: () async {
                  final usercredenital = await signInWithGoogle();
                  if (usercredenital.user != null) {
                    showSnack("Sucessfull login");
                    Navigator.of(context)
                        .pushReplacement(_createRoute(BranchesPage()));
                  } else {
                    showSnack("Login filed");
                  }
                },
                child: const Text("Google"))
          ],
        ),
      ),
    );
  }
}
