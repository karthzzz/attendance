 import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/student/day_to_day.dart';
import 'package:attendance1/widget/student/student_branch_list.dart';
import 'package:flutter/material.dart';

import 'monthly.dart';

void main() {
  runApp(MaterialApp(
    home: StudentHome(),
  ));
}

class StudentHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     void showSnackbarScreen(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
    return Scaffold(
      appBar: AppBar(
        title: Text('NRIIT'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: ShapeDecoration(shape: CircleBorder()),
                child: Image.network(firebaseAuth.currentUser!.photoURL!),
              ),
              Text(
                firebaseAuth.currentUser!.displayName!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                firebaseAuth.currentUser!.email!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              FilledButton.icon(
                  onPressed: () async {
                    final result = await signOut();
                    if (result) {
                      showSnackbarScreen("signOutSucessfull");
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => StudentHome()));
                    } else {
                      showSnackbarScreen("SignOut Rejected");
                    }
                  },
                  icon: const Icon(Icons.logout_outlined),
                  label: const Text("Log Out"))
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school,
                  size: 30,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Monthly(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              primary: Colors.green,
              minimumSize: const Size(250, 50),
            ),
            child: const Text(
              'Monthly Attendance',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentBranchesPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              backgroundColor: Colors.green,
              minimumSize: Size(250, 50),
            ),
            child: const Text(
              'Day-to-day Attendance',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
