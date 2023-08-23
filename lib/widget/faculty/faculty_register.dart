import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:attendance1/widget/faculty/faculty_branch_list.dart';
import 'package:attendance1/widget/faculty/faculty_login.dart';
import 'package:flutter/material.dart';

class FacultyRegistrationScreen extends StatefulWidget {
  @override
  State<FacultyRegistrationScreen> createState() =>
      _FacultyRegistrationScreenState();
}

class _FacultyRegistrationScreenState extends State<FacultyRegistrationScreen> {
  final List<String> subjects = [
    'Math',
    'Science',
    'History',
    'English',
    'Art'
  ];
 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<String> selectedSubjects = [];

  void showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showFacultySubjectInDataBase() async {
    final result = await createFaculty(
      firebaseAuth.currentUser!.displayName!,
      selectedSubjects,
      _emailController.text,
      _passwordController.text,
    );
    if (result) {
      showSnack("Sucess in creating faculty");
    } else {
      showSnack("Failed in creating faculty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Faculty Registration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               
              const SizedBox(height: 16),
              ...subjects.map((subject) {
                return CheckboxListTile(
                  title: Text(subject),
                  value: selectedSubjects.contains(subject),
                  onChanged: (value) {
                    setState(() {
                      if (value!) {
                        selectedSubjects.add(subject);
                      } else {
                        selectedSubjects.remove(subject);
                      }
                    });
                  },
                );
              }).toList(),
              const SizedBox(height: 16),
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
                    showFacultySubjectInDataBase();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => FacultyBranchesPage(
                              email: firebaseAuth.currentUser!.email!,
                              name: firebaseAuth.currentUser!.displayName!,
                              imageUrl: firebaseAuth.currentUser!.photoURL!,
                            )));
                  } else {
                    showSnack("Failed");
                  }
                },
                child: Text('Register'),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => FacultyLoginScreen()));
                },
                child: const Text('Already have an account? Login here'),
              ),
              FilledButton(
                  onPressed: () async {
                    final usercredenital = await signInWithGoogle();
                    if (usercredenital.user != null) {
                      showSnack("Sucessfull register");
                      showFacultySubjectInDataBase();
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
                      showSnack("register filed");
                    }
                  },
                  child: const Text("Google"))
            ],
          ),
        ),
      ),
    );
  }
}
