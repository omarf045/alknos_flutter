import 'package:flutter/material.dart';
import 'username.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:dio/dio.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EmailPage(),
    ));

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  bool _isEmailValid = true;
  String _notValidEmailMessage = '';
  final TextEditingController _controller = TextEditingController();

  bool _checkIfEmailIsValid() {
    if (EmailValidator.validate(_controller.text)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _checkIfEmailExists() async {
    String url = 'http://192.168.0.25:5050/api/v1.0/user-exists';
    Map<String, dynamic> data = {'email': _controller.text};

    final response = await Dio().get(url, data: data);

    bool userExists = response.data['user_exists'];
    return userExists;
  }

  void _checkEmail() async {
    if (!_checkIfEmailIsValid()) {
      setState(() {
        _notValidEmailMessage = 'El correo electrónico no es válido.';
        _isEmailValid = false;
      });
    } else {
      bool emailExists = false;
      bool emailExistsResult = await _checkIfEmailExists();
      try {
        setState(() {
          emailExists = emailExistsResult;
        });
      } catch (error) {
        _notValidEmailMessage = 'Ocurrió un error.';
        setState(() {
          _isEmailValid = false;
        });
      }

      if (emailExists) {
        _notValidEmailMessage = 'El correo electrónico ya está en uso.';
        setState(() {
          _isEmailValid = false;
        });
      } else {
        setState(() {
          _isEmailValid = true;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UsernamePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Crea tu cuenta",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ingresa tu correo electrónico",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Ingresa el correo electrónico que usarás para tu cuenta.",
              style: TextStyle(
                  fontSize: 14, height: 1.5, color: Colors.grey.shade600),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: ((value) => {
                    setState(() {
                      _isEmailValid = true;
                    })
                  }),
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _isEmailValid = true;
                      });
                    },
                    icon: const Icon(
                      Icons.highlight_off,
                      color: Colors.black,
                    )),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: !_isEmailValid
                            ? Colors.red.shade700
                            : Colors.black)),
                hintText: "Correo electrónico",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            Visibility(
              visible: !_isEmailValid,
              child: Padding(
                padding: const EdgeInsets.only(
                    top:
                        12.0), // Añade 8 píxeles de padding en la parte superior
                child: Text(_notValidEmailMessage,
                    style: TextStyle(color: Colors.red.shade700)),
              ),
            ),
            const SizedBox(height: 30),
            MaterialButton(
              height: 48,
              minWidth: double.infinity,
              onPressed: _checkEmail,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: const Text(
                "Siguiente",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
