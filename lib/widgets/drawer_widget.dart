import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  final AdvancedDrawerController controller;
  const DrawerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String username = "";

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    return username as String;
  }

  _loadUsername() async {
    String name = await getUsername();
    setState(() {
      username = name;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 80.0,
                  height: 80.0,
                  margin: const EdgeInsets.only(
                    left: 20,
                    top: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/images/empty-avatar.png')),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  username,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              Divider(
                color: Colors.grey.shade800,
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/stoichiometry', context);
                },
                leading: const Icon(Iconsax.home),
                title: const Text('Stoichiometry'),
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/limiting-reagent', context);
                },
                leading: const Icon(Iconsax.chart_2),
                title: const Text('Limiting Reagent'),
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/electrolysis', context);
                },
                leading: const Icon(Iconsax.profile_2user),
                title: const Text('Electrolysis'),
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/galvanic-cell', context);
                },
                leading: const Icon(Iconsax.profile_2user),
                title: const Text('Galvanic Cell'),
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/empirical-formula', context);
                },
                leading: const Icon(Iconsax.profile_2user),
                title: const Text('Empirical Formula'),
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/compound-query', context);
                },
                leading: const Icon(Iconsax.profile_2user),
                title: const Text('Compound Query'),
              ),
              ListTile(
                onTap: () {
                  _handleNavigateTo('/electromagnetic-waves', context);
                },
                leading: const Icon(Iconsax.profile_2user),
                title: const Text('Electromagnetic Waves'),
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(color: Colors.grey.shade800),
              /*
              ListTile(
                onTap: () {},
                leading: const Icon(Iconsax.setting_2),
                title: const Text('Settings'),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Iconsax.support),
                title: const Text('Support'),
              ),
              */
              ListTile(
                onTap: () {
                  _handleLogout();
                },
                leading: const Icon(Iconsax.logout),
                title: const Text('Cerrar sesión'),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigateTo(String route, BuildContext context) {
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.of(context).pushNamed(route);
    } else {
      widget.controller.hideDrawer();
    }
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}
