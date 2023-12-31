import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/student/day_to_day.dart';
import 'package:attendance1/widget/student/student_home.dart';
import 'package:flutter/material.dart';

class StudentLoginRegister extends StatelessWidget{
  const StudentLoginRegister({super.key});
  
  @override
  Widget build(BuildContext context) {

      void showSnack(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Login'),
      ),
 
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: ShapeDecoration(shape: CircleBorder()),
              child: Image.network("https://sanantoniotreesurgeons.com/wp-content/uploads/2021/05/Illustration-of-Google-icon-on-transparent-background-PNG.png",),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                 final usercredenital = await signInWithGoogle();
                    if (usercredenital.user != null) {
                      showSnack("Sucessfull login");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) =>  StudentHome()
                        ),
                      );
                    } else {
                      showSnack("Login filed");
                    }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  
}