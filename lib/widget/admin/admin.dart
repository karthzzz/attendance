import 'package:attendance1/firebase/firebaseQueries.dart';
import 'package:attendance1/widget/admin/admin_branch_page.dart';
import 'package:attendance1/widget/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void showSnack(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                message,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Register Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ADMIN',
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _passwordController,
              decoration:const InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              final result = await signWithEmailAndPassword(_emailController.text, _passwordController.text);
              if(result){
                showSnack("Sucess");
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (ctx) => BranchesPage()));
              }
              else{
                showSnack("Failed");
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              textStyle: const TextStyle(fontSize: 20, color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
            child: const Text('Login'),
          ),
           
           
        ],
      ),
    );
  }
}
