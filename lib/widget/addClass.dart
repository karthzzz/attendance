import 'package:attendance1/excel_file_operation/excel_retrieve_data_operation.dart';
import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Student {
  final String name;
  final String roll_number;
  final String section_id;
  final String year;
  final String branch_id;

  Student(this.name, this.roll_number, this.section_id, this.year, this.branch_id);
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
  FilePickerResult? resultPicker;
  List<dynamic>? listOfStudents;

  void showSnackbarScreen(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          message,
          style: const TextStyle(fontSize: 25),
        ),
        actions: [
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const BranchesPage()));
            },
            icon: const Icon(Icons.emoji_nature_outlined),
            label: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
        resultPicker = result;
      });
    }
    await readExcel(_filePath).then((value) {
      setState(() {
        listOfStudents = value;
      });
    });
  }

  void enterDataIntoFirebase() async {
    for (var student in listOfStudents!) {
      await addBranchYearSectionFromExcel(Student(student[1], student[0], "Section-A", student[3], student[2]));
    }
    showSnackbarScreen("Data update successful");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        backgroundColor: Color(0xFF1E2C3A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              children: [
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _branch,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintStyle: TextStyle(color: Colors.grey), // Hint text color
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE57373)), // Border color when focused
                    ),
                  ),
                  hint: const Text("Select Branch"),
                  icon: const Icon(Icons.home_work_outlined),
                  items: ['CSE', 'DS', 'IT', 'ECE']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _branch = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _year,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintStyle: TextStyle(color: Colors.grey), // Hint text color
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE57373)), // Border color when focused
                    ),
                  ),
                  hint: const Text("Select Year"),
                  icon: const Icon(Icons.calculate),
                  items: ['20KP', '21KP', '22KP', '23KP']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _year = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  value: _section,
                  hint: const Text("Select Section"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintStyle: TextStyle(color: Colors.grey), // Hint text color
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE57373)), // Border color when focused
                    ),
                  ),
                  icon: const Icon(Icons.group),
                  items: ['Section-A', 'Section-B']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return "Please select";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _section = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          pickFile();
                        },
                        child: _filePath.isEmpty
                            ? Text("Add Excel file")
                            : Text(resultPicker!.names.first.toString()),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    enterDataIntoFirebase();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text("Enter"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFE57373),
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
