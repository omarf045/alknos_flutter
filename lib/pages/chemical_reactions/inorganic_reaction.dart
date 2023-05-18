import 'package:flutter/material.dart';

class InorganicReactionPage extends StatefulWidget {
  const InorganicReactionPage({Key? key}) : super(key: key);

  @override
  _InorganicReactionPageState createState() => _InorganicReactionPageState();
}

class _InorganicReactionPageState extends State<InorganicReactionPage> {
  TextEditingController reactant1Controller = TextEditingController();
  TextEditingController reactant2Controller = TextEditingController();
  String reaction = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inorganic Reaction Calculator'),
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
                          'Reactant 1:',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        TextField(
                          controller: reactant1Controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter reactant 1',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  const Text(
                    '+',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reactant 2:',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        TextField(
                          controller: reactant2Controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter reactant 2',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    reaction = calculateProducts();
                  });
                },
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Reaction: $reaction',
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String calculateProducts() {
    String reactant1 = reactant1Controller.text.trim();
    String reactant2 = reactant2Controller.text.trim();
    if (reactant1.isNotEmpty && reactant2.isNotEmpty) {
      return '$reactant1 + $reactant2 -> products';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return '';
    }
  }
}
