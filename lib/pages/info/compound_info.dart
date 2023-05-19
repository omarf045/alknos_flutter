import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CompoundInformationPage extends StatefulWidget {
  final int cid; // <-- Add the variable here

  const CompoundInformationPage({Key? key, required this.cid})
      : super(key: key);

  @override
  _CompoundInformationPageState createState() =>
      _CompoundInformationPageState();
}

class _CompoundInformationPageState extends State<CompoundInformationPage> {
  List<dynamic> compoundData = [];

  @override
  void initState() {
    super.initState();

    _getCompoundInformation(widget.cid).then((value) {
      setState(() {
        compoundData = value;
      });
    });
  }

  Future<List<dynamic>> _getCompoundInformation(int cid) async {
    String url = 'http://192.168.0.25:8000/api/v1.0/compound-information';
    Map<String, dynamic> data = {'cid': cid};
    List<dynamic> responseData = [];

    final response = await Dio().post(url, data: data);
    setState(() {
      responseData = response.data;
    });

    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compound Information'),
      ),
      body: ListView.builder(
        itemCount: compoundData.length,
        itemBuilder: (context, index) {
          final data = compoundData[index];

          return ExpansionTile(
            title: Text(data['name']),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.containsKey('value'))
                      Text(
                        'Value: ${data['value']}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    if (data.containsKey('url'))
                      Image.network(
                        data['url'],
                        height: 200.0,
                      ),
                    if (data.containsKey('description'))
                      Text(
                        'Description: ${data['description']}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
