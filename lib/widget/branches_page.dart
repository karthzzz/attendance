import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/model/modelClass.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:attendance1/widget/list_of_student.dart';
import 'package:flutter/material.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'BRANCHES',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                ...presentBranches.map((e) => BranchButton(
                      name: e.name,
                      date: dateDropDown,
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

class BranchButton extends StatefulWidget {
  final String name;

  const BranchButton({
    required this.name,
    required this.date,
  });

  final String date;
  @override
  State<BranchButton> createState() => _BranchButtonState();
}

class _BranchButtonState extends State<BranchButton> {
  void showAlearDailgo(String branchName) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Choose section"),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => ListOfStudent(
                                    branch: branchName,
                                    section: "Section-A",
                                    date: widget.date,
                                  )));
                        },
                        child: const Text("Section-A")),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ListOfStudent(
                                branch: branchName,
                                section: 'Section-B',
                                date: widget.date,
                              ),
                            ),
                          );
                        },
                        child: const Text("Section-B")),
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
