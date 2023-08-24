import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/model/modelClass.dart';
import 'package:attendance1/widget/admin/admin.dart';
import 'package:attendance1/widget/student/list_of_student_for_students.dart';
import 'package:flutter/material.dart';

class StudentBranchesPage extends StatefulWidget {
  const StudentBranchesPage({super.key});

  @override
  State<StudentBranchesPage> createState() => _StudentBranchesPageState();
}

class _StudentBranchesPageState extends State<StudentBranchesPage> {
  List<Branch> presentBranches = [];
  List<String> presentDates = [];
  String dateDropDown = '';
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  void showSnackbarScreen(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    showDetails();
    showDates();
    super.initState();
  }

  void showDetails() async {
    await retrieveBranches().then((value) {
      setState(() {
        presentBranches = value;
      });
    });
  }

  void showDates() async {
    await showDatesForBranch().then((value) {
      setState(() {
        presentDates = value;
      });
    });
    print(presentDates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BRANCHES'),
        elevation: 0,
        backgroundColor: const Color(0xFF1E2C3A),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await retrieveBranches().then((value) {
            setState(() {
              presentBranches = value;
            });
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        key: refreshIndicatorKey,
        strokeWidth: 10,
        color: Colors.lightBlue,
        child: Container(
          color: Color(0xFF15202B),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    ...presentBranches.map((e) => BranchButtonForStudent(
                          name: e.name,
                          date: dateDropDown,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await signOut();
          if (result) {
            showSnackbarScreen('Sign Out Successful');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => LoginPage()));
          } else {
            showSnackbarScreen('Sign Out Rejected');
          }
        },
        label: const Text('Log Out'),
        icon: Icon(Icons.logout_outlined),
        backgroundColor: Color(0xFFE57373),
      ),
    );
  }
}

class BranchButtonForStudent extends StatefulWidget {
  final String name;

  const BranchButtonForStudent({
    required this.name,
    required this.date,
  });

  final String date;
  @override
  State<BranchButtonForStudent> createState() => _BranchButtonForStudentState();
}

class _BranchButtonForStudentState extends State<BranchButtonForStudent> {
  void showAlertDialog(String branchName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Choose Section',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF1E2C3A),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ListOfStudentForStudents(
                      branch: branchName,
                      section: 'Section-A',
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE57373),
                  textStyle: TextStyle(fontSize: 16, color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Section-A'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ListOfStudentForStudents(
                        branch: branchName,
                        section: 'Section-B',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFE57373),
                  textStyle: TextStyle(fontSize: 16, color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Section-B'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          showAlertDialog(widget.name);
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFFE57373),
          textStyle: const TextStyle(fontSize: 16, color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business, color: Colors.white),
                const SizedBox(width: 10),
                Text(widget.name, style: TextStyle(color: Colors.white)),
              ],
            ),
            IconButton(
              onPressed: () {
                // Add action for delete
              },
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
