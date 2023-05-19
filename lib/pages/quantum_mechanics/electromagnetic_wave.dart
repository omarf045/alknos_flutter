import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../widgets/drawer_widget.dart';
import 'package:iconsax/iconsax.dart';

class ElectromagneticWavePage extends StatefulWidget {
  const ElectromagneticWavePage({super.key});

  @override
  _ElectromagneticWavePageState createState() =>
      _ElectromagneticWavePageState();
}

class _ElectromagneticWavePageState extends State<ElectromagneticWavePage> {
  final _advancedDrawerController = AdvancedDrawerController();

  String selectedProperty = 'wavelength';
  TextEditingController valueController = TextEditingController();
  TextEditingController powerController = TextEditingController();
  List<Map<String, dynamic>> results = [];

  final List<String> propertyOptions = ['wavelength', 'frequency', 'energy'];

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
                'Electromagnetic Wave',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Value:',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            TextField(
                              controller: valueController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter value',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'x10^',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            TextField(
                              controller: powerController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Enter power',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select property:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      DropdownButton<String>(
                        value: selectedProperty,
                        onChanged: (value) {
                          setState(() {
                            selectedProperty = value!;
                          });
                        },
                        items: propertyOptions.map((property) {
                          return DropdownMenuItem<String>(
                            value: property,
                            child: Text(property),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (valueController.text.isNotEmpty &&
                          powerController.text.isNotEmpty) {
                        double value =
                            double.tryParse(valueController.text) ?? 0;
                        int power = int.tryParse(powerController.text) ?? 0;
                        Map<String, dynamic> result = {
                          'property': selectedProperty,
                          'value': value,
                          'power': power,
                          'wavelength': 0.0,
                          'frequency': 0.0,
                          'energy': 0.0,
                        };
                        switch (selectedProperty) {
                          case 'wavelength':
                            result['wavelength'] = value *
                                pow(10, power); // lambda = value * 10^power
                            result['frequency'] =
                                _calculateFrequency(result['wavelength']);
                            result['energy'] =
                                _calculateEnergy(result['frequency']);
                            break;
                          case 'frequency':
                            result['frequency'] =
                                value * pow(10, power); // f = value * 10^power
                            result['wavelength'] =
                                _calculateWavelength(result['frequency']);
                            result['energy'] =
                                _calculateEnergy(result['frequency']);
                            break;
                          case 'energy':
                            result['energy'] =
                                value * pow(10, power); // E = value * 10^power
                            result['frequency'] =
                                _calculateFrequency(result['energy']);
                            result['wavelength'] =
                                _calculateWavelength(result['frequency']);
                            break;
                          default:
                        }
                        setState(() {
                          results.add(result);
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                      }
                    },
                    child: const Text('Calculate'),
                  ),
                  const SizedBox(height: 16.0),
                  if (results.isNotEmpty)
                    Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          children: const [
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Wavelength',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Frequency',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Energy',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ...results.map((result) {
                          return TableRow(
                            children: [
                              TableCell(
                                child: Center(
                                  child: Text(
                                    '${result['wavelength'].toStringAsFixed(2)} m',
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    '${result['frequency'].toStringAsFixed(2)} Hz',
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    '${result['energy'].toStringAsFixed(2)} J',
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateFrequency(double wavelength) {
    return Constants.speedOfLight / wavelength;
  }

  double _calculateWavelength(double frequency) {
    return Constants.speedOfLight / frequency;
  }

  double _calculateEnergy(double frequency) {
    return Constants.planckConstant * frequency;
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}

class Constants {
  static const double speedOfLight = 299792458.0;
  static const double planckConstant = 6.62607015e-34;
}
