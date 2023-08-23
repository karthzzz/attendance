import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/model/modelClass.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:attendance1/widget/admin/admin.dart';
import 'package:attendance1/widget/faculty/faculty_student_list.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class FacultyBranchesPage extends StatefulWidget {
  const FacultyBranchesPage(
      {super.key,
      required this.name,
      required this.email,
      required this.imageUrl});
  final String name;
  final String email;
  final String imageUrl;

  @override
  State<FacultyBranchesPage> createState() => _FacultyBranchesPageState();
}

class _FacultyBranchesPageState extends State<FacultyBranchesPage> {
  List<Branch> presentBranches = [];
  List<String> presentDates = [];
  String dateDropDown = "";
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isRefresh = false;

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
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: ShapeDecoration(shape: CircleBorder()),
                child: Image.network(widget.imageUrl),
              ),
              Text(
                widget.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                widget.email,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
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
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isRefresh = true;
          });
          await retrieveBranches().then((value) {
            setState(() {
              presentBranches = value;
            });
          });
          return Future<void>.delayed(const Duration(seconds: 3), () {
            setState(() {
              isRefresh = false;
            });
          });
        },
        key: refreshIndicatorKey,
        strokeWidth: 10,
        color: Colors.lightBlue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  if (!isRefresh)
                    ...presentBranches.map((e) => FacultyBranchButton(
                          name: e.name,
                          facultyName: widget.name,
                        ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacultyBranchButton extends StatefulWidget {
  final String name;
  final String facultyName;

  const FacultyBranchButton({
    required this.name,
    required this.facultyName,
  });

  @override
  State<FacultyBranchButton> createState() => _FacultyBranchButtonState();
}

class _FacultyBranchButtonState extends State<FacultyBranchButton> {
  String? _year = "";
  String? _section = "";
  List<String> listOfYears = [];
  List<String> listOfSections = [];
  List<String> listOfSubjects = [];
  List<Student> listOfStudents = [];
  List<String> selectedYear = [];
  List<String> selectedSubject = [];
  List<String> selecedSection = [];
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    retrieveYearsOfList();
    retrieveSectionsOfList();
    retrieveSubjects();
    super.initState();
  }

  void retrieveSubjects() async {
    print("Hello ");
    await retrieveSubjectsFromTeacher(
      widget.facultyName,
    ).then((value) {
      setState(() {
        listOfSubjects = value;
      });
    });
     
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
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      enableDrag: true,
      elevation: 4,
      context: context,
      builder: (ctx) {
        return RefreshIndicator(
          onRefresh: () async {
            await retrieveSubjectsFromTeacher(
              widget.name,
            ).then((value) {
              setState(() {
                listOfSubjects = value;
              });
            });
          },

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownMultiSelect(
                  options: listOfYears,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Select Year"),
                  validator: (selectedOptions) {
                    if (selectedOptions == null) {
                      return "Invaild";
                    }
                    return "ok";
                  },
                  selectedValues: selectedYear,
                  onChanged: (p0) {
                    setState(() {
                      selectedYear = p0;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownMultiSelect(
                  options: listOfSections,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Select Subject"),
                  validator: (selectedOptions) {
                    if (selectedOptions == null) {
                      return "Invaild";
                    }
                    return "ok";
                  },
                  selectedValues: selecedSection,
                  onChanged: (p0) {
                    setState(() {
                      selectedSubject = p0;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropDownMultiSelect(
                  options: listOfSubjects,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Select subject"),
                  validator: (selectedOptions) {
                    if (selectedOptions == null) {
                      return "Invaild";
                    }
                    return "ok";
                  },
                  selectedValues: selecedSection,
                  onChanged: (p0) {
                    setState(() {
                      selecedSection = p0;
                    });
                  },
                ),
              ),
              // DropdownButtonFormField(
              //   value: _section,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              //   hint: const Text("Enter Section"),
              //   icon: const Icon(Icons.home_work_outlined),
              //   items: listOfYears
              //       .map(
              //         (e) => DropdownMenuItem(
              //           value: e,
              //           child: Text(e),
              //         ),
              //       )
              //       .toList(),
              //   validator: (value) {
              //     if (value == null) {
              //       return "Please enter";
              //     }
              //     return null;
              //   },
              //   onChanged: (value) {
              //     setState(() {
              //       _section = value;
              //     });
              //   },
              // ),
              FilledButton(
                onPressed: () {
                  retrieveStudentForFaculty();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => FacultyStudentList(
                      subject: selectedSubject[0],
                      teacherName: widget.name,
                      date:
                          '${dateTime.day}-${dateTime.month}-${dateTime.year}',
                      branch: branchName,
                      section: selecedSection[0],
                      year: selectedYear[0],
                    ),
                  ));
                },
                child: const Text("Enter"),
              )
            ],
          ),
        );
      },
    );
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
