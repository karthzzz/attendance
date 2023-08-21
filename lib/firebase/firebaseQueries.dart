 

import 'package:attendance1/model/modelClass.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();

final database = FirebaseDatabase.instance
    .refFromURL('https://fir-auth-dc1f8-default-rtdb.firebaseio.com/');

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<List<Branch>> retrieveBranches() async {
  final branchDatabase = database.child('/branches');
  final branchData = await branchDatabase.once();
  final branchList = branchData.snapshot.value as Map;
  final List<Branch> branches = [];
  branchList.forEach((key, value) {
    branches.add(Branch(value['name']));
  });
  return branches;
}

Future<List<Student>> retrieveStudents(String branch, String section) async {
  final studentDatabase = database.child('students');
  final studentData1 =
      await studentDatabase.orderByChild('section_id').equalTo(section).once();
  final studentList = studentData1.snapshot.value as Map;
  final List<Student> students = [];
  studentList.forEach((key, value) {
    if (value['branch_id'] == branch) {
      students.add(
        Student(
          value['name'],
          value['roll_number'],
          value['section_id'],
          value['year'],
          value['branch_id'],
        ),
      );
    }
  });
  return students;
}

Future<bool> retrieveAttendance(String roll_number, String period) async {
  DateTime dateTime = DateTime.now();
  final dateAttendanceDatabase = await database
      .child('attendance')
      .child('${dateTime.day}-${dateTime.month}-${dateTime.year}')
      .orderByChild(roll_number)
      .once();
  final result = dateAttendanceDatabase.snapshot.value as Map;
  bool? attendance;
  result.forEach((key, value) {
    if (key == roll_number) {
      attendance = value[period];
    }
  });
  return attendance!;
}

Future<bool> updateAttendanceForPeriodWays(
    String roll_number, String period, bool changedValue) async {
  print(roll_number);
  DateTime dateTime = DateTime.now();
  final dateAttendanceDatabase = await database
      .child('attendance')
      .child('${dateTime.day}-${dateTime.month}-${dateTime.year}')
      .child(roll_number)
      .update({period: changedValue});
  final dateAttendanceDatabase1 = await database
      .child('attendance')
      .child('${dateTime.day}-${dateTime.month}-${dateTime.year}')
      .orderByChild(roll_number)
      .once();
  final result = dateAttendanceDatabase1.snapshot.value as Map;
  bool? attendance;
  result.forEach((key, value) {
    if (key == roll_number) {
      attendance = value[period];
    }
  });

  return attendance!;
}

Future<List<String>> showDatesForBranch() async {
  List<String> datesList = [];
  final datesDatabaseEvent = await database.child('attendance').once();
  if (datesDatabaseEvent.snapshot.value != null) {
    final dates = datesDatabaseEvent.snapshot.value as Map;
    dates.forEach((key, value) {
      datesList.add(key);
      print(value);
    });
  } else {
    print("No any value");
  }

  return datesList;
}

Future<bool> getAttendanceForDate(
  String roll_number,
  String period,
  String date,
) async {
  final dateAttendanceDatabase = await database
      .child('attendance')
      .child(date)
      .orderByChild(roll_number)
      .once();
  final result = dateAttendanceDatabase.snapshot.value as Map;
  var attendance = false;
  result.forEach((key, value) {
    attendance = value[period];
  });
  return attendance;
}


Future<bool> addBranchYearSectionFromExcel(Student student ) async {
    final branchDataBase = database.child('/branches/${student.branch_id}');
    await branchDataBase.set({'name': '${student.branch_id}'});

    final sectionDatabase = database.child("/secions/${student.section_id}/${student.branch_id}");
    await sectionDatabase.set({
      "brach_id": student.branch_id,
      'name': student.section_id,
    });

    final studentDatabase = database.child('/students/${student.roll_number}');
    await studentDatabase.set({
      'name': student.name,
      'roll_number': student.roll_number,
      'section_id': student.section_id,
      'year': student.year,
      'branch_id' : student.branch_id,
    });
     
    final dataTime = DateTime.now();
    final attendanceDatabase = database.child(
        '/attendance/${dataTime.day}-${dataTime.month}-${dataTime.year}/${student.roll_number}');

    final Map<dynamic,  bool> tempAttendence = {};
    for (var i = 1; i < 9; i++) {
      tempAttendence.addAll({'period$i': false});
    }
    await attendanceDatabase.set(tempAttendence);
    return true;
  }





 