import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../../widgets/drawer_widget.dart';
import 'package:iconsax/iconsax.dart';

class EmpiricalFormulaPage extends StatefulWidget {
  const EmpiricalFormulaPage({Key? key});

  @override
  _EmpiricalFormulaPageState createState() => _EmpiricalFormulaPageState();
}

class _EmpiricalFormulaPageState extends State<EmpiricalFormulaPage> {
  final _advancedDrawerController = AdvancedDrawerController();

  // Variables for entered elements and percentages
  List<String> elements = [];
  List<double> percentages = [];

  // Controllers for input fields
  final TextEditingController _percentageController = TextEditingController();

  // List of available elements
  List<String> originalAvailableElements = ['C', 'H', 'O', 'N', 'P', 'S'];
  List<String> availableElements = ['C', 'H', 'O', 'N', 'P', 'S'];

  // Currently selected element
  String? selectedElement;

  // Calculated empirical formula
  String? empiricalFormula;

  Future<String> _fetchEmpiricalFormula() async {
    List<Map<String, dynamic>> elementsList = [];
    for (int i = 0; i < elements.length; i++) {
      Map<String, dynamic> elementMap = {};
      elementMap['symbol'] = elements[i];
      elementMap['percentage'] = percentages[i];
      elementsList.add(elementMap);
    }

    Map<String, dynamic> data = {'elements': elementsList};
    String url = 'http://192.168.0.25:8000/api/v1.0/empirical-formula';

    final response = await Dio().post(url, data: data);
    return response.data['empirical_formula'];
  }

  // Function to add element and percentage to lists
  void _addElement() {
    if (selectedElement != null && _percentageController.text.isNotEmpty) {
      setState(() {
        elements.add(selectedElement!);
        percentages.add(double.parse(_percentageController.text));
        _percentageController.clear();
        availableElements.remove(selectedElement);
        selectedElement = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the fields with valid data'),
        ),
      );
    }
  }

  // Function to delete an element from the lists
  void _deleteElement(int index) {
    setState(() {
      availableElements.add(elements[index]);
      elements.removeAt(index);
      percentages.removeAt(index);
    });
  }

  // Function to calculate the empirical formula
  void _calculateEmpiricalFormula() {
    // Calculation of the sum of percentages
    double sumPercentages = percentages.fold(0, (a, b) => a + b);

    if (sumPercentages == 100) {
      // Calculation of empirical formula
      _fetchEmpiricalFormula().then((value) {
        setState(() {
          empiricalFormula = value;
          availableElements = List.from(originalAvailableElements);
          elements.clear();
          percentages.clear();
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the fields with valid data'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _percentageController.dispose();
    super.dispose();
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
                'Empirical Formula',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input data section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Element'),
                      DropdownButton<String>(
                        value: selectedElement,
                        items: availableElements.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (selected) {
                          setState(() {
                            selectedElement = selected;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text('Percentage'),
                      TextField(
                        controller: _percentageController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addElement,
                        child: const Text('Add element'),
                      ),
                      const SizedBox(height: 16),
                      const Text('Entered elements and percentages:'),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: elements.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${elements[index]} ${percentages[index]}%',
                                ),
                              ),
                              IconButton(
                                onPressed: () => _deleteElement(index),
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Calculation section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: elements.isEmpty
                            ? null
                            : _calculateEmpiricalFormula,
                        child: const Text('Calculate empirical formula'),
                      ),
                      if (empiricalFormula != null) ...[
                        const SizedBox(height: 16),
                        Text('Empirical formula: $empiricalFormula'),
                      ],
                    ],
                  ),
                ),
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
