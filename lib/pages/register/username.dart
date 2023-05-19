import 'package:alknos_v1/pages/register/password.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UsernamePage(),
    ));

class LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

class UsernamePage extends StatefulWidget {
  const UsernamePage({Key? key}) : super(key: key);

  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  bool _isUsernameValid = true;
  String _notValidUsernameMessage = '';
  final TextEditingController _controller = TextEditingController();

  bool _isUsernameEightCharacters = false;
  bool _hasUsernameOneNumber = false;
  bool _hasNotUsernameSpecialCharacters = false;

  onUsernameChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final specialCharactersExp = RegExp(r'^[a-z0-9]+$');

    setState(() {
      _isUsernameValid = true;

      _isUsernameEightCharacters = false;
      if (password.length >= 8) _isUsernameEightCharacters = true;

      _hasUsernameOneNumber = false;
      if (numericRegex.hasMatch(password)) _hasUsernameOneNumber = true;

      _hasNotUsernameSpecialCharacters = false;
      _hasNotUsernameSpecialCharacters =
          _controller.text.contains(specialCharactersExp);
    });
  }

  bool _checkIfUsernameIsValid() {
    if (_isUsernameEightCharacters &&
        _hasUsernameOneNumber &&
        _hasNotUsernameSpecialCharacters) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _checkIfUsernameExists() async {
    String url = 'http://192.168.0.25:5050/api/v1.0/user-exists';
    Map<String, dynamic> data = {'username': _controller.text};

    final response = await Dio().get(url, data: data);

    bool userExists = response.data['user_exists'];
    return userExists;
  }

  void _checkUsername() async {
    if (!_checkIfUsernameIsValid()) {
      setState(() {
        _notValidUsernameMessage = 'El nombre de usuario no es válido.';
        _isUsernameValid = false;
      });
    } else {
      bool emailExists = false;
      bool emailExistsResult = await _checkIfUsernameExists();
      try {
        setState(() {
          emailExists = emailExistsResult;
        });
      } catch (error) {
        _notValidUsernameMessage = 'Ocurrió un error.';
        setState(() {
          _isUsernameValid = false;
        });
      }

      if (emailExists) {
        _notValidUsernameMessage = 'El nombre de usuario ya está en uso.';
        setState(() {
          _isUsernameValid = false;
        });
      } else {
        setState(() {
          _isUsernameValid = true;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PasswordPage()),
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
              "Crea un nombre de usuario",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Elige un nombre de usuario para tu nueva cuenta. Puedes cambiarlo cuando quieras.",
              style: TextStyle(
                  fontSize: 16, height: 1.5, color: Colors.grey.shade600),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              inputFormatters: [LowercaseTextFormatter()],
              onChanged: (username) => onUsernameChanged(username),
              controller: _controller,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _isUsernameValid = true;
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
                        color: !_isUsernameValid
                            ? Colors.red.shade700
                            : Colors.black)),
                hintText: "Nombre de usuario",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            Visibility(
              visible: !_isUsernameValid,
              child: Padding(
                padding: const EdgeInsets.only(
                    top:
                        12.0), // Añade 8 píxeles de padding en la parte superior
                child: Text(_notValidUsernameMessage,
                    style: TextStyle(color: Colors.red.shade700)),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isUsernameEightCharacters
                          ? Colors.green
                          : Colors.transparent,
                      border: _isUsernameEightCharacters
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Contiene al menos 8 carácteres")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _hasUsernameOneNumber
                          ? Colors.green
                          : Colors.transparent,
                      border: _hasUsernameOneNumber
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Contiene al menos 1 número")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _hasNotUsernameSpecialCharacters
                          ? Colors.green
                          : Colors.transparent,
                      border: _hasNotUsernameSpecialCharacters
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("No contiene caracteres especiales")
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              height: 48,
              minWidth: double.infinity,
              onPressed: _checkUsername,
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
