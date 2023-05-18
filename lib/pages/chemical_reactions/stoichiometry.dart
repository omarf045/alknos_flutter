import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class StoichiometryPage extends StatefulWidget {
  const StoichiometryPage({Key? key}) : super(key: key);

  @override
  _StoichiometryPageState createState() => _StoichiometryPageState();
}

class _StoichiometryPageState extends State<StoichiometryPage> {
  // Variables para los compuestos reactantes y productos
  List<String> reactants = [];
  List<String> products = [];

  // Controladores de los campos de entrada
  final TextEditingController _reactantController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Lista de unidades de masa disponibles
  List<String> massUnits = ['grams', 'moles', 'molecules'];

  // Unidad de masa actualmente seleccionada
  String? massUnitSelected;

  // Compuesto actualmente seleccionado
  String? compoundSelected;

  // Cantidad ingresada del compuesto seleccionado
  double? quantitySelected;

  // Formula balanceada de la reaccion quimica
  String? balancedFormula;

  // Resultados de la estequiometria
  List<dynamic> stoichiometryResults = [];

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

  Future<List<dynamic>> _fetchStoichiometryData() async {
    // Agregar variable reaction
    String reaction = '${reactants.join(' + ')} --> ${products.join(' + ')}';
    int position = 0;

    if (balancedFormula != null) {
      List<String> compounds = reactants + products;
      position = compounds.indexOf(compoundSelected!) + 1;
    }

    String url = 'http://192.168.0.25:5050/api/v1.0/calculate-stoichiometry';
    Map<String, dynamic> data = {
      'reaction': reaction,
      'unit': massUnitSelected,
      'quantity': quantitySelected,
      'position': position
    };
    List<dynamic> responseData = [];

    final response = await Dio().post(url, data: data);
    setState(() {
      responseData = response.data;
    });

    return responseData;
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
  void _calculateStoichiometry() {
    if (compoundSelected != null &&
        massUnitSelected != null &&
        quantitySelected != null) {
      // TODO: Implementar la función de cálculo de estequiometría

      _fetchStoichiometryData().then((value) {
        setState(() {
          stoichiometryResults = value;
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
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stoichiometry Calculator'),
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
            // Sección de cálculo de estequiometría
            if (balancedFormula != null) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Stoichiometry'),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: compoundSelected,
                      items: [...reactants, ...products].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (selected) {
                        setState(() {
                          compoundSelected = selected;
                        });
                      },
                    ),
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
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter a quantity',
                      ),
                      onChanged: (value) {
                        setState(() {
                          quantitySelected = double.tryParse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _calculateStoichiometry,
                      child: const Text('Calculate'),
                    ),
                    const SizedBox(height: 16),
                    if (stoichiometryResults.isNotEmpty)
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
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    'Moles',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    'Molecules',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Text(
                                    'Grams',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...stoichiometryResults.map((result) {
                            return TableRow(
                              children: [
                                TableCell(
                                  child: Text(
                                    result['compound'],
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    '${result['moles']}',
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    '${result['molecules']}',
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    '${result['grams']}',
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
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
