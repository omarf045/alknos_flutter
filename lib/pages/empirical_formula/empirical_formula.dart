import 'package:flutter/material.dart';

class EmpiricalFormulaPage extends StatefulWidget {
  const EmpiricalFormulaPage({super.key});

  @override
  _EmpiricalFormulaPageState createState() => _EmpiricalFormulaPageState();
}

class _EmpiricalFormulaPageState extends State<EmpiricalFormulaPage> {
  // Variables para los elementos y porcentajes ingresados
  List<String> elementos = [];
  List<double> porcentajes = [];

  // Controladores de los campos de entrada
  final TextEditingController _porcentajeController = TextEditingController();

  // Lista de elementos disponibles
  List<String> elementosDisponibles = ['C', 'H', 'O', 'N', 'P', 'S'];

  // Elemento actualmente seleccionado
  String? elementoSeleccionado;

  // Función para agregar el elemento y el porcentaje a las listas
  void _agregarElemento() {
    if (elementoSeleccionado != null && _porcentajeController.text.isNotEmpty) {
      setState(() {
        elementos.add(elementoSeleccionado!);
        porcentajes.add(double.parse(_porcentajeController.text));
        _porcentajeController.clear();
        elementosDisponibles.remove(elementoSeleccionado);
        elementoSeleccionado = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the fields with valid data'),
        ),
      );
    }
  }

  // Función para borrar un elemento de las listas
  void _borrarElemento(int index) {
    setState(() {
      elementosDisponibles.add(elementos[index]);
      elementos.removeAt(index);
      porcentajes.removeAt(index);
    });
  }

  // Función para calcular la fórmula empírica
  String _calcularFormulaEmpirica() {
    // Cálculo de la suma de los porcentajes
    double sumaPorcentajes = porcentajes.fold(0, (a, b) => a + b);

    if (sumaPorcentajes == 100) {
      // Cálculo de la fórmula empírica
      String formulaEmpirica = "";
      for (int i = 0; i < elementos.length; i++) {
        int subindice = (porcentajes[i] / sumaPorcentajes * 100).round();
        formulaEmpirica += elementos[i] + subindice.toString();
      }
      return formulaEmpirica;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the fields with valid data'),
        ),
      );
      return "";
    }
  }

  @override
  void dispose() {
    _porcentajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de fórmula empírica'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de entrada de datos
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Elemento'),
                  DropdownButton<String>(
                    value: elementoSeleccionado,
                    items: elementosDisponibles.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      setState(() {
                        elementoSeleccionado = selected;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Porcentaje'),
                  TextField(
                    controller: _porcentajeController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _agregarElemento,
                    child: const Text('Agregar elemento'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Elementos y porcentajes ingresados:'),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: elementos.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${elementos[index]} ${porcentajes[index]}%',
                            ),
                          ),
                          IconButton(
                            onPressed: () => _borrarElemento(index),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Sección de cálculo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: elementos.isEmpty
                        ? null
                        : () {
                            String formulaEmpirica = _calcularFormulaEmpirica();
                            if (formulaEmpirica.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Fórmula empírica'),
                                    content: Text(formulaEmpirica),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                    child: const Text('Calcular fórmula empírica'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
