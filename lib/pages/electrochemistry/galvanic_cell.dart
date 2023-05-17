import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GalvanicCellPage extends StatefulWidget {
  const GalvanicCellPage({super.key});

  @override
  _GalvanicCellPageState createState() => _GalvanicCellPageState();
}

class _GalvanicCellPageState extends State<GalvanicCellPage> {
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
      print(error.toString());
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galvanic Cell'),
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
    );
  }
}
