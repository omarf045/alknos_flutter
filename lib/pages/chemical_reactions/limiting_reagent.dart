import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LimitingReagentPage extends StatefulWidget {
  const LimitingReagentPage({Key? key}) : super(key: key);

  @override
  _LimitingReagentPageState createState() => _LimitingReagentPageState();
}

class _LimitingReagentPageState extends State<LimitingReagentPage> {
  // Variables para los compuestos reactantes y productos
  List<String> reactants = [];
  List<String> products = [];

  // Controladores de los campos de entrada
  final TextEditingController _reactantController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _reagent1Controller = TextEditingController();
  final TextEditingController _reagent2Controller = TextEditingController();

  // Lista de unidades de masa disponibles
  List<String> massUnits = ['grams', 'moles', 'molecules'];

  // Unidad de masa actualmente seleccionada
  String? massUnitSelected;

  // Cantidad ingresada del compuesto seleccionado
  double? reagent1Quantity;
  double? reagent2Quantity;

  // Formula balanceada de la reaccion quimica
  String? balancedFormula;

  // Resultados de la estequiometria
  String? limitingReagentResult;

  // Función para agregar un compuesto reactante
  void _addReactant() {
    if (_reactantController.text.isNotEmpty) {
      setState(() {
        reactants.add(_reactantController.text);
        _reactantController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid compound'),
        ),
      );
    }
  }

  // Función para borrar un compuesto reactante
  void _deleteReactant(int index) {
    setState(() {
      reactants.removeAt(index);
    });
  }

  // Función para agregar un compuesto producto
  void _addProduct() {
    if (_productController.text.isNotEmpty) {
      setState(() {
        products.add(_productController.text);
        _productController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid compound'),
        ),
      );
    }
  }

  // Función para borrar un compuesto producto
  void _deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  // Función para balancear la ecuación química
  void _balanceEquation() {
    _fetchBalancedFormula().then((value) {
      setState(() {
        balancedFormula = value;
      });
    });
  }

  Future<String> _fetchLimitingReagent() async {
    // Agregar variable reaction
    String reaction = '${reactants.join(' + ')} --> ${products.join(' + ')}';
    String url = 'http://192.168.0.25:5050/api/v1.0/limiting-reagent';
    Map<String, dynamic> data = {
      'reaction': reaction,
      'unit': massUnitSelected,
      'reagent1': reagent1Quantity,
      'reagent2': reagent2Quantity
    };

    final response = await Dio().post(url, data: data);

    return response.data['limiting_reagent'];
  }

  Future<String> _fetchBalancedFormula() async {
    // Agregar variable reaction
    String reaction = '${reactants.join(' + ')} --> ${products.join(' + ')}';

    String url = 'http://192.168.0.25:5050/api/v1.0/balance-reaction';
    Map<String, dynamic> data = {'reaction': reaction};

    final response = await Dio().post(url, data: data);

    return response.data['reaction'];
  }

  // Función para calcular la estequiometría
  void _calculateLimitingReagent() {
    if (_reagent1Controller.text.isNotEmpty &&
        _reagent2Controller.text.isNotEmpty &&
        massUnitSelected != null) {
      _fetchLimitingReagent().then((value) {
        setState(() {
          limitingReagentResult = value;
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields with valid data'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _reactantController.dispose();
    _productController.dispose();
    _reagent1Controller.dispose();
    _reagent2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Limiting Reagent Calculator'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de compuestos reactantes
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Reactants'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _reactantController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a compound',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _addReactant,
                    child: const Text('Add reactant'),
                  ),
                  const SizedBox(height: 12),
                  const Text('Compounds added:'),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: reactants.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              reactants[index],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteReactant(index),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Sección de compuestos productos
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Products'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _productController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a compound',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _addProduct,
                    child: const Text('Add product'),
                  ),
                  const SizedBox(height: 12),
                  const Text('Compounds added:'),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              products[index],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deleteProduct(index),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Sección de balanceo de ecuación química
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed:
                        balancedFormula == null ? _balanceEquation : null,
                    child: const Text('Balance equation'),
                  ),
                  if (balancedFormula != null)
                    const SizedBox(height: 16)
                  else
                    const SizedBox.shrink(),
                  if (balancedFormula != null)
                    Text(
                      'Balanced equation: $balancedFormula',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
// Sección de cálculo de reactivo limitante
            if (balancedFormula != null) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Limiting Reagent'),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: massUnitSelected,
                      items: massUnits.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          massUnitSelected = selected;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reagent1Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter reagent 1 quantity',
                      ),
                      onChanged: (value) {
                        setState(() {
                          reagent1Quantity = double.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _reagent2Controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter reagent 2 quantity',
                      ),
                      onChanged: (value) {
                        setState(() {
                          reagent2Quantity = double.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculateLimitingReagent,
                      child: const Text('Calculate'),
                    ),
                    const SizedBox(height: 16),
                    if (limitingReagentResult != null)
                      Text(
                        'The limiting reagent is $limitingReagentResult',
                      ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
