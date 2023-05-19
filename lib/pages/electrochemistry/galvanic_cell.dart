import 'dart:convert';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../widgets/drawer_widget.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GalvanicCellPage extends StatefulWidget {
  const GalvanicCellPage({super.key});

  @override
  _GalvanicCellPageState createState() => _GalvanicCellPageState();
}

class _GalvanicCellPageState extends State<GalvanicCellPage> {
  final _advancedDrawerController = AdvancedDrawerController();

  final _electrodeOptions = ['Zn', 'Cu', 'Al', 'Au', 'Fe', 'Pb'];
  String _selectedElectrode1 = 'Zn';
  String _selectedElectrode2 = 'Cu';
  String? _imageBase64;

  Future<String?> _getImageBase64() async {
    String url = 'http://192.168.0.25:5050/api/v1.0/galvanic-cell';
    Map<String, dynamic> data = {
      'electrode1': _selectedElectrode1,
      'electrode2': _selectedElectrode2
    };
    try {
      final response = await Dio().post(
        url,
        data: data,
        options: Options(responseType: ResponseType.json),
      );
      final responseData = response.data as Map<String, dynamic>;
      return responseData['base64'] as String?;
    } catch (error) {
      return null;
    }
  }

  void _calculateGalvanicCell() async {
    // Call your calculation method here
    // Modify _imageBase64 with the response from the server
    final imageBase64 = await _getImageBase64();
    setState(() {
      _imageBase64 = imageBase64;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AdvancedDrawer(
        backdropColor: Colors.grey.shade900,
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade900,
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: const Offset(-20.0, 0.0),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        drawer: DrawerWidget(controller: _advancedDrawerController),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80,
            leading: IconButton(
              color: Colors.black,
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Iconsax.close_square : Iconsax.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                  iconSize: 25,
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey.shade700,
                  ))
            ],
            title: const Center(
              child: Text(
                'Galvanic Cell',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Electrode 1'),
                        DropdownButton<String>(
                          value: _selectedElectrode1,
                          items: _electrodeOptions
                              .map((electrode) => DropdownMenuItem(
                                    value: electrode,
                                    child: Text(electrode),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedElectrode1 = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Electrode 2'),
                        DropdownButton<String>(
                          value: _selectedElectrode2,
                          items: _electrodeOptions
                              .map((electrode) => DropdownMenuItem(
                                    value: electrode,
                                    child: Text(electrode),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedElectrode2 = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _calculateGalvanicCell,
                  child: const Text('Calculate'),
                ),
                const SizedBox(height: 20),
                _imageBase64 != null
                    ? Image.memory(
                        base64Decode(_imageBase64!),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
