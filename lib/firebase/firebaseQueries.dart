import 'package:attendance1/model/modelClass.dart';
import 'package:attendance1/widget/addClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignIn = GoogleSignIn();
final firebaseAuth = FirebaseAuth.instance;

Future<bool> signOut() async {
  await firebaseAuth.signOut();
  return true;
}

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

Future<Object> createWithEmailAndPassword(String email, String passowrd) async {
  UserCredential? credential;
  try {
    credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: passowrd,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
  if (credential != null) {
    print(credential);
    return credential;
  }
  return true;
}

Future<bool> signWithEmailAndPassword(String email, String password) async {
  UserCredential? credential;
  try {
    credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      return false;
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      return false;
    }
  }

  if (credential!.user != null) {
    print(credential);
    return true;
  }

  return false;
}

Future<List<Branch>> retrieveBranches() async {
  final branchDatabase = database.child('/branches');
  final branchData = await branchDatabase.once();
  final branchList = branchData.snapshot.value as Map;
  final List<Branch> branches = [];
  branchList.forEach((key, value) {
    branches.add(Branch(value['name']));
  });
  print(branches);
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

Future<bool> addBranchYearSectionFromExcel(Student student) async {
  final branchDataBase = database.child('/branches/${student.branch_id}');
  await branchDataBase.set({'name': '${student.branch_id}'});

  final sectionDatabase =
      database.child("/sections/${student.section_id}/${student.branch_id}");
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
    'branch_id': student.branch_id,
  });

  final dataTime = DateTime.now();
  final attendanceDatabase = database.child(
      '/attendance/${dataTime.day}-${dataTime.month}-${dataTime.year}/${student.roll_number}');

  final Map<dynamic, bool> tempAttendence = {};
  for (var i = 1; i < 9; i++) {
    tempAttendence.addAll({'period$i': false});
  }
  final yearDataBase = database.child('years/${student.year}');
  await yearDataBase.set({'name': student.year});
  await attendanceDatabase.set(tempAttendence);
  return true;
}

Future<bool> createStduentIdAndFacultyIdAttendance(
  String period,
  String date,
  String roll_number,
  String subject,
  String teacher,
) async {
  final attendanceDatabase = database.child('/attendance/$date-$roll_number');
  attendanceDatabase.set({
    'student_Id': roll_number,
    'date': date,
  });

  final attendancePeriodDatabase =
      database.child('/attendance/$date-$roll_number/$period');
  attendancePeriodDatabase.set({
    'subject': subject,
    'teacher': teacher,
    'attendance': false,
  });
  return true;
}

Future<bool> createFaculty(String facultyName, List<String> subjects,
    String email, String password) async {
  final subjectDatabase = database.child('subject');

  for (var i = 0; i < subjects.length; i++) {
    await subjectDatabase.child(subjects[i]).set({
      'name': subjects[i],
    });
  }
  final facultyDatabase = database.child('/faculty/$facultyName');
  await facultyDatabase.set({
    'facultyName': facultyName,
    'subjects': subjects,
  });
  return true;
}

Future<List<String>> retrieveYears() async {
  final yearDataBase = await database.child('years').orderByKey().once();
  final years = yearDataBase.snapshot.value as Map;
  List<String> yearsList = [];
  years.forEach(
    (key, value) {
      yearsList.add(key);
    },
  );

  return yearsList;
}

Future<List<String>> retrieveSections() async {
  final sectionDataBase = await database.child('sections').orderByKey().once();
  final years = sectionDataBase.snapshot.value as Map;
  List<String> sectionList = [];
  years.forEach(
    (key, value) {
      sectionList.add(key);
      print(key);
    },
  );
  print(sectionList);

  return sectionList;
}




Future<List<Student>> retrieveStudentsFromBranchSectionAndYear(
    String branch, String section, String year) async {
  final studentDatabase = database.child('students');
  final studentData1 =
      await studentDatabase.orderByChild('section_id').equalTo(section).once();
  final studentList = studentData1.snapshot.value as Map;
  final List<Student> students = [];
  studentList.forEach((key, value) {
    if (value['branch_id'] == branch) {
      if (value['year'] == year) {
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
    }
  });
  return students;
}
