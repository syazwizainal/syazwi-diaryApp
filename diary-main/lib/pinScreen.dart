import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'homepage.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({Key? key}) : super(key: key);

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final String correctPin = "1234"; // Replace with your desired correct pin
  String enteredPin = "";
  bool error = false;

  void _onPinSubmitted(String pin) {
    setState(() {
      enteredPin = pin;
    });

    if (enteredPin == correctPin) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      setState(() {
        error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security Pin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please Enter Pin 1234',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            error
                ? const Text('Incorrect pin. Please Try again.')
                : Container(),
            PinCodeTextField(
              highlight: true,
              pinBoxHeight: 64,
              pinBoxWidth: 64,
              highlightColor: Colors.blue,
              defaultBorderColor: Colors.grey,
              hasTextBorderColor: Colors.green,
              maxLength: 4,
              maskCharacter: "*",
              pinBoxDecoration:
                  ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
              onDone: _onPinSubmitted,
            ),
          ],
        ),
      ),
    );
  }
}
