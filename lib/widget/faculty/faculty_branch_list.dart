import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/model/modelClass.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:attendance1/widget/admin/admin.dart';
import 'package:attendance1/widget/list_of_student.dart';
import 'package:flutter/material.dart';

class FacultyBranchesPage extends StatefulWidget {
  const FacultyBranchesPage({super.key});

  @override
  State<FacultyBranchesPage> createState() => _FacultyBranchesPageState();
}

class _FacultyBranchesPageState extends State<FacultyBranchesPage> {
  List<Branch> presentBranches = [];
  List<String> presentDates = [];
  String dateDropDown = "";

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
      bottomSheet: Row(
        children: [
          FilledButton.icon(
              onPressed: () async {
                final result = await signOut();
                if (result) {
                  showSnackbarScreen("signOutSucessfull");
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => LoginPage()));
                } else {
                  showSnackbarScreen("SignOut Rejected");
                }
              },
              icon: Icon(Icons.logout_outlined),
              label: const Text("Log Out"))
        ],
      ),
      appBar: AppBar(
        title: const Text('BRANCHES'),
        actions: [
          FilledButton(
            onPressed: () async {
              await database.set({});
              showSnackbarScreen("clear is successfull");
            },
            child: const Text("Clear"),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ...presentBranches.map((e) => FacultyBranchButton(
                      name: e.name,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FirebaseBranch(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Update'),
            ),
          ),
        ],
      ),
    );
  }
}

class FacultyBranchButton extends StatefulWidget {
  final String name;

  const FacultyBranchButton({
    required this.name,
  });

  @override
  State<FacultyBranchButton> createState() => _FacultyBranchButtonState();
}

class _FacultyBranchButtonState extends State<FacultyBranchButton> {
  String? _year = "";
  String? _section = "";
  List<String> listOfYears = [];
  List<String> listOfSections = [];
  List<Student> listOfStudents = [];
  @override
  void initState() {
    retrieveYearsOfList();
    retrieveSectionsOfList();
    super.initState();
  }

  void retrieveStudentForFaculty() async {
    await retrieveStudentsFromBranchSectionAndYear(
      widget.name,
      _section!,
      _year!,
    ).then((value) {
      setState(() {
        listOfStudents = value;
      });
    });
  }

  void retrieveYearsOfList() async {
    await retrieveYears().then((value) {
      setState(() {
        listOfYears = value;
      });
    });
  }

  void retrieveSectionsOfList() async {
    await retrieveSections().then((value) {
      setState(() {
        listOfSections = value;
      });
    });
  }

  void showAlearDailgo(String branchName) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text("Choose section"),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField(
                      value: _year,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text("Enter Year"),
                      icon: const Icon(Icons.home_work_outlined),
                      items: listOfYears
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Please enter";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _year = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField(
                      value: _section,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      hint: const Text("Enter Section"),
                      icon: const Icon(Icons.home_work_outlined),
                      items: listOfSections
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Please enter";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _section = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FilledButton(
                      onPressed: () {
                         retrieveStudentForFaculty();
                         Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> ));
                      },
                      child: const Text("Enter"),
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {
          showAlearDailgo(widget.name);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          textStyle: const TextStyle(fontSize: 20, color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business),
                const SizedBox(width: 10),
                Text(widget.name),
              ],
            ),
            IconButton(
              onPressed: () {
                // Add action for delete
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
