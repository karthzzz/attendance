import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:attendance1/widget/faculty/faculty_branch_list.dart';
import 'package:flutter/material.dart';

class FacultyLoginScreen extends StatefulWidget {
  @override
  State<FacultyLoginScreen> createState() => _FacultyLoginScreenState();
}

class _FacultyLoginScreenState extends State<FacultyLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final result = await  createWithEmailAndPassword(
                      _emailController.text, _passwordController.text);

                  if (result) {
                    showSnack("Sucess");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => FacultyBranchesPage(
                          imageUrl: firebaseAuth.currentUser!.photoURL!,
                              email: firebaseAuth.currentUser!.email!,
                              name: firebaseAuth.currentUser!.displayName!,
                            )));
                  } else {
                    showSnack("Failed");
                  }
                },
                child: Text('Login'),
              ),
              const SizedBox(
                height: 20,
              ),
              FilledButton(
                  onPressed: () async {
                    final usercredenital = await signInWithGoogle();
                    if (usercredenital.user != null) {
                      showSnack("Sucessfull login");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => FacultyBranchesPage(
                             imageUrl: firebaseAuth.currentUser!.photoURL!,
                            email: firebaseAuth.currentUser!.email!,
                            name: firebaseAuth.currentUser!.displayName!,
                          ),
                        ),
                      );
                    } else {
                      showSnack("Login filed");
                    }
                  },
                  child: Text("Google"))
            ],
          ),
        ),
      ),
    );
  }
}
