// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ppms/global/globals.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

TextEditingController _previousTextController = TextEditingController();
bool _validateEmailT = false;

String? _validateEmail(String? value) {
  if (_validateEmailT) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String cnfPassword = '';

  final _formKey = GlobalKey<FormState>();
  bool emailVerified = false;
  TextEditingController _otpController = TextEditingController();
  bool mailSent = false;

  Future<void> sendEmail(String otp, String email) async {
    final response = await http.post(Uri.parse('$apiUrl/emails/send-email/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'subject': 'OTP for PPMS Email Verification',
          'message': 'Your OTP for sign up in PPMS is $otp.',
          'to': email,
        }));

    if (response.statusCode == 200) {
      print('Email sent successfully');
      setState(() {
        mailSent = true;
      });
    } else {
      print(response.body);
    }
  }

  void verify(String email) async {
    print(email);
    setState(() {
      mailSent = false;
    });
    Random random = Random();

    // Generate a random number between 0 to 999999
    int randomNum = random.nextInt(1000000);

    // Pad the random number with zeros to make it a six-digit number
    String sixDigitNum = randomNum.toString().padLeft(6, '0');

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    await sendEmail(sixDigitNum, email);

    Navigator.pop(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP sent to Mail'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter OTP',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter OTP';
              }
              return null;
            },
            controller: _otpController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                if (sixDigitNum == _otpController.text) {
                  setState(() {
                    emailVerified = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  _otpController.clear();
                  Navigator.of(context).pop();
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Wrong Otp'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 16.0,
            ),
            Text(
              'CREATE NEW ACCOUNT',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Already registered? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                'Login to continue',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Container(
                    width: 240.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: emailVerified
                                ? Icon(Icons.check)
                                : TextButton(
                                    onPressed: () => verify(email),
                                    child: Text('verify')),
                          ),
                          validator: _validateEmail,
                          onChanged: (value) {
                            setState(() {
                              email = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 32.0,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 240.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                          obscuringCharacter: '•',
                          onChanged: (value) {
                            setState(() {
                              password = value.toString();
                            });
                            setState(() {
                              _previousTextController.text = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 32.0,
                  ),
                  Container(
                    width: 240.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Re-type Password',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Re-type Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          obscureText: true,
                          obscuringCharacter: '•',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter valid password';
                            } else if (!identical(value, password)) {
                              print(value);
                              print('@');
                              print(password);
                              return 'password mismatch';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              cnfPassword = value.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 126, 203, 234)),
                onPressed: () {
                  setState(() {
                    _validateEmailT = true;
                  });
                  if (_formKey.currentState!.validate()) {
                    if (emailVerified) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Registration Successful'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Email Not verified'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
