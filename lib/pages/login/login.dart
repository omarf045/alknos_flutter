import 'dart:async';

import 'package:alknos_v1/pages/chemical_reactions/stoichiometry.dart';
import 'package:alknos_v1/pages/register/email.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ));

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int activeIndex = 0;
  late String token;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        activeIndex++;
        if (activeIndex == 4) activeIndex = 0;
      });
    });

    super.initState();
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<String?> _fetchAuthToken() async {
    String url = 'http://192.168.0.25:5050/api/v1.0/login';
    Map<String, dynamic> data = {
      'username': _usernameController.text,
      'password': _passwordController.text
    };
    try {
      final response = await Dio().post(url, data: data);
      return response.data['token'] as String?;
    } catch (error) {
      return null;
    }
  }

  Future<String?> _fetchUsername() async {
    String url = 'http://192.168.0.25:5050/api/v1.0/get-details';
    Options options = Options(headers: {'Authorization': 'Token $token'});

    try {
      final response = await Dio().get(url, options: options);
      return response.data['username'] as String?;
    } catch (error) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 350,
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: activeIndex == 0 ? 1 : 0,
                    duration: const Duration(
                      seconds: 1,
                    ),
                    curve: Curves.linear,
                    child: Image.network(
                      'https://ouch-cdn2.icons8.com/As6ct-Fovab32SIyMatjsqIaIjM9Jg1PblII8YAtBtQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNTg4/LzNmMDU5Mzc0LTky/OTQtNDk5MC1hZGY2/LTA2YTkyMDZhNWZl/NC5zdmc.png',
                      height: 400,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: activeIndex == 1 ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    child: Image.network(
                      'https://ouch-cdn2.icons8.com/vSx9H3yP2D4DgVoaFPbE4HVf6M4Phd-8uRjBZBnl83g/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNC84/MzcwMTY5OS1kYmU1/LTQ1ZmEtYmQ1Ny04/NTFmNTNjMTlkNTcu/c3Zn.png',
                      height: 400,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: activeIndex == 2 ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    child: Image.network(
                      'https://ouch-cdn2.icons8.com/fv7W4YUUpGVcNhmKcDGZp6pF1-IDEyCjSjtBB8-Kp_0/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMTUv/ZjUzYTU4NDAtNjBl/Yy00ZWRhLWE1YWIt/ZGM1MWJmYjBiYjI2/LnN2Zw.png',
                      height: 400,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedOpacity(
                    opacity: activeIndex == 3 ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.linear,
                    child: Image.network(
                      'https://ouch-cdn2.icons8.com/AVdOMf5ui4B7JJrNzYULVwT1z8NlGmlRYZTtg1F6z9E/rs:fit:784:767/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvOTY5/L2NlMTY1MWM5LTRl/ZjUtNGRmZi05MjQ3/LWYzNGQ1MzhiOTQ0/Mi5zdmc.png',
                      height: 400,
                    ),
                  ),
                )
              ]),
            ),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _usernameController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Usuario',
                hintText: 'Nombre de usuario',
                labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                prefixIcon: const Icon(
                  Iconsax.user,
                  color: Colors.black,
                  size: 18,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              obscureText: true,
              controller: _passwordController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Contraseña',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Iconsax.key,
                  color: Colors.black,
                  size: 18,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '¿Olvidaste tu constraseña?',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () {
                _fetchAuthToken().then((value) {
                  if (value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cannot login with provided credentials'),
                      ),
                    );
                  } else {
                    saveToken(value);
                    setState(() {
                      token = value;
                    });
                    _fetchUsername().then((value) {
                      saveUsername(value as String);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const StoichiometryPage()),
                      );
                    });
                  }
                });
              },
              height: 48,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Iniciar Sesión",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¿Aún no tienes una cuenta?',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmailPage()),
                    );
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
