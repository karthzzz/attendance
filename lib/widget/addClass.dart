import 'package:attendance1/excel_file_operation/excel_retrieve_data_operation.dart';
import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/branches_page.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class Student {
  final String name;
  final String roll_number;
  final String section_id;
  final String year;
  final String branch_id;

  Student(
      this.name, this.roll_number, this.section_id, this.year, this.branch_id);
}

class FirebaseBranch extends StatefulWidget {
  const FirebaseBranch({super.key});

  @override
  State<FirebaseBranch> createState() => _FirebaseBranchState();
}

class _FirebaseBranchState extends State<FirebaseBranch> {
  String? _branch;
  String? _year;
  String? _section;
  final _nameController = TextEditingController();
  final _rollcontroller = TextEditingController();
  String _filePath = '';
  List<dynamic>? listOfStudents;

  void showSnackbarScreen(String e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          e,
          style: const TextStyle(fontSize: 25),
        ),
        actions: [
          FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const BranchesPage()));
              },
              icon: const Icon(Icons.emoji_nature_outlined),
              label: const Text("Okay"))
        ],
      ),
    );
  }

  // Future<List<String>> getStudentId() async {
  //   List<String> listOfStudentIds = [];

  //   // ignore: unused_local_variable
  //   database.child('attendance').onValue.listen((event) {
  //     DataSnapshot snapshot = event.snapshot;
  //     if (snapshot.value != null) {
  //       print(snapshot.value);
  //     }
  //   });
  //   return await listOfStudentIds;
  // }
  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
    await readExcel(_filePath).then((value) {
      setState(() {
        listOfStudents = value;
      });
    });
  }

  void enterTheDataIntoTheFirebase() async {
    for (var student in listOfStudents!) {
      await addBranchYearSectionFromExcel(
          Student(student[1], student[0], "Section-A", student[3], student[2]));
    }
    showSnackbarScreen("sucessfull the updation");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: _branch,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  hint: const Text("Enter branch"),
                  icon: const Icon(Icons.home_work_outlined),
                  items: ['CSE', 'DS', 'IT', 'ECE']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please enter";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _branch = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: _year,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  hint: const Text("Enter Year"),
                  icon: const Icon(Icons.calculate),
                  items: ['20KP', '21KP', '22KP', '23KP']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                  height: 20,
                ),
                DropdownButtonFormField(
                  value: _section,
                  hint: const Text("Enter Section"),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  icon: const Icon(Icons.group),
                  items: ['Section-A', 'Section-B']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
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
                  height: 10,
                ),
                Card(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          pickFile();
                        },
                        child: const Text("Add Excel file"),
                      )
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    // await addBranchYearSection(Student(
                    //     _nameController.text,
                    //     _rollcontroller.text,
                    //     _section.toString(),
                    //     _year.toString(),
                    //     _branch.toString()));
                    enterTheDataIntoTheFirebase();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text("Enter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
