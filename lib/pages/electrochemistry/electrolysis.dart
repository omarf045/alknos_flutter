import 'package:flutter/material.dart';

class ElectrolysisPage extends StatefulWidget {
  const ElectrolysisPage({super.key});

  @override
  _ElectrolysisPageState createState() => _ElectrolysisPageState();
}

class _ElectrolysisPageState extends State<ElectrolysisPage> {
  String selectedMassUnit = 'g';
  String selectedTimeUnit = 'seg';
  late String selectedCompound;
  TextEditingController massController = TextEditingController();
  TextEditingController currentController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController compoundController = TextEditingController();
  Map<String, dynamic> result = {};

  final List<String> massUnitOptions = ['g', 'kg', 'lb', 'oz', 'mg', 'ton'];
  final List<String> timeUnitOptions = ['seg', 'min', 'hrs'];

  bool isTimeFilled = false;
  bool isCurrentFilled = false;
  bool isMassFilled = false;
  bool isCompoundFilled = false;
  late bool showMassInput;
  late bool showCurrentInput;
  late bool showTimeInput;
  late bool showCompoundInput;

  @override
  Widget build(BuildContext context) {
    showMassInput = !(isTimeFilled && isCurrentFilled);
    showCurrentInput = !(isTimeFilled && isMassFilled);
    showTimeInput = !(isCurrentFilled && isMassFilled);
    showCompoundInput = !(isTimeFilled && isMassFilled && isCurrentFilled);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrolysis Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter compound:',
                style: TextStyle(fontSize: 18.0),
              ),
              TextField(
                controller: compoundController,
                onChanged: (value) {
                  setState(() {
                    selectedCompound = value;
                    isCompoundFilled = value.isNotEmpty;
                  });
                },
                enabled: showCompoundInput,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mass:',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          controller: massController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter mass',
                          ),
                          onChanged: (value) {
                            setState(() {
                              isMassFilled = value.isNotEmpty;
                            });
                          },
                          enabled: showMassInput,
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
                          'Unit:',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        DropdownButton<String>(
                          value: selectedMassUnit,
                          onChanged: (value) {
                            setState(() {
                              selectedMassUnit = value!;
                            });
                          },
                          items: massUnitOptions.map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
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
                    'Current:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextField(
                    controller: currentController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter current',
                    ),
                    onChanged: (value) {
                      setState(() {
                        isCurrentFilled = value.isNotEmpty;
                      });
                    },
                    enabled: showCurrentInput,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        TextField(
                          controller: timeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Enter time',
                          ),
                          onChanged: (value) {
                            setState(() {
                              isTimeFilled = value.isNotEmpty;
                            });
                          },
                          enabled: showTimeInput,
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
                          'Unit:',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        DropdownButton<String>(
                          value: selectedTimeUnit,
                          onChanged: (value) {
                            setState(() {
                              selectedTimeUnit = value!;
                            });
                          },
                          items: timeUnitOptions.map((unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  calculateElectrolysis();
                },
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 16.0),
              if (result.isNotEmpty)
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
                              'Compound',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Seconds',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Amps',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              'Grams',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Center(
                            child: Text(selectedCompound),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              result['seconds'].toStringAsFixed(2),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              result['amps'].toString(),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Text(
                              result['grams'].toStringAsFixed(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateElectrolysis() {
    if ((isTimeFilled && isCurrentFilled) ||
        (isTimeFilled && isMassFilled) ||
        (isCurrentFilled && isMassFilled)) {
      double mass = double.tryParse(massController.text) ?? 0;
      double current = double.tryParse(currentController.text) ?? 0;
      double time = double.tryParse(timeController.text) ?? 0;

      double seconds = _calculateSeconds(time, selectedTimeUnit);
      double grams = _calculateGrams(mass, selectedMassUnit);

      setState(() {
        result = {
          'compound': selectedCompound,
          'seconds': seconds,
          'amps': current,
          'grams': grams,
        };
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill at least two of the fields'),
        ),
      );
    }
  }

  double _calculateSeconds(double time, String unit) {
    switch (unit) {
      case 'seg':
        return time;
      case 'min':
        return time * 60;
      case 'hrs':
        return time * 3600;
      default:
        return 0;
    }
  }

  double _calculateGrams(double mass, String unit) {
    switch (unit) {
      case 'g':
        return mass;
      case 'kg':
        return mass * 1000;
      case 'lb':
        return mass * 453.592;
      case 'mg':
        return mass * 0.001;
      case 'ton':
        return mass * 1000000;
      case 'oz':
        return mass * 28.3495;
      default:
        return 0;
    }
  }
}
