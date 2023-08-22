import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:attendance1/widget/faculty/faculty_branch_list.dart';
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
  final _facultyNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<String> selectedSubjects =  [];

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
      _facultyNameController.text,
      selectedSubjects,
      _emailController.text,
      _passwordController.text,
    );
    if (result) {
      showSnack("Sucess in creating faculty");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const BranchesPage()));
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
              TextFormField(
                controller: _facultyNameController,
                decoration: const InputDecoration(
                  labelText: 'Faculty Name',
                ),
              ),
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
                  final result = await signWithEmailAndPassword(
                      _emailController.text, _passwordController.text);

                  if (result) {
                    showSnack("Sucess");
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => FacultyBranchesPage()));
                  } else {
                    showSnack("Failed");
                  }
                  showFacultySubjectInDataBase();
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
