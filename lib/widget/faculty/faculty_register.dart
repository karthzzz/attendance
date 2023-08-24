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
  List<String> subjects = [
  "Communicative English",
  "Mathematics – I",
  "Applied Chemistry",
  "Programming for Problem Solving using C",
  "Computer Engineering Workshop",
  "English Communication Skills Laboratory",
  "Applied Chemistry Lab",
  "Programming for Problem Solving using C Lab",
  "Mathematics – II",
  "Applied Physics",
  "Digital Logic Design",
  "Python Programming",
  "Data Structures",
  "Applied Physics Lab",
  "Python Programming Lab",
  "Data Structures Lab",
  "Mathematics III",
  "Mathematical Foundations of Computer Science",
  "Fundamentals of Data Science",
  "Object Oriented Programming with Java",
  "Database Management Systems",
  "Fundamentals of Data Science Lab",
  "Object Oriented Programming with Java Lab",
  "Database Management Systems Lab",
  "Mobile App Development",
  "Essence of Indian Traditional Knowledge",
  "Probability and Statistics",
  "Computer Organization",
  "Data Warehousing and Mining",
  "Formal Languages and Automata Theory",
  "Managerial Economics and Financial Accountancy",
  "R Programming Lab",
  "Data Mining using Python Lab",
  "Web Application Development Lab",
  "MongoDB",
  "Computer Networks",
  "Big Data Analytics",
  "Design and Analysis of Algorithms",
  "Professional Elective-II",
  "Open Elective-II",
  "Computer Networks Lab",
  "Big Data Analytics Lab",
  "Deep Learning with TensorFlow",
  "Skill Oriented Course - IV",
  "Professional Elective-III",
  "Professional Elective-IV",
  "Professional Elective-V",
  "Open Elective-III",
  "Universal Human Values 2: Understanding Harmony",
  "Major Project Work, Seminar Internship"
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
      backgroundColor: Colors.lightBlue[50],
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
