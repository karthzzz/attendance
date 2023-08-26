import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Send SMS'),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _numbersController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> sendSMS(String numbers, String message) async {
    try {
      final SmsSender sender = SmsSender();
      final SmsMessage smsMessage = SmsMessage(numbers, message);

      await sender.sendSms(smsMessage);
      print("SMS sent successfully");
    } catch (error) {
      print("Error sending SMS: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _numbersController,
            decoration: InputDecoration(labelText: 'Phone Numbers (comma-separated)'),
          ),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(labelText: 'Message'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final numbers = _numbersController.text;
              final message = _messageController.text;
              sendSMS(numbers, message);
            },
            child: Text('Send SMS'),
          ),
        ],
      ),
    );
  }
}
