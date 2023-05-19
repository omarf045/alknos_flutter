import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:iconsax/iconsax.dart';

class CompoundQueryPage extends StatefulWidget {
  const CompoundQueryPage({Key? key}) : super(key: key);

  @override
  _CompoundQueryPageState createState() => _CompoundQueryPageState();
}

class _CompoundQueryPageState extends State<CompoundQueryPage> {
  int selectedTool = 0;
  List<dynamic> compounds = [];
  bool _isMenuVisible = false;
  final TextEditingController _searchController = TextEditingController();

  _handleSearchPressed() {
    _getCompounds(_searchController.text).then((value) {
      setState(() {
        compounds = value;
      });
    });
  }

  Future<List<dynamic>> _getCompounds(String query) async {
    String url = 'http://192.168.0.25:5050/api/v1.0/compound-query';
    Map<String, dynamic> data = {'query': query};
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          leading: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: IconButton(
              color: Colors.black,
              onPressed: () {
                setState(() {
                  _isMenuVisible = !_isMenuVisible;
                });
              },
              icon: _isMenuVisible
                  ? const Icon(Iconsax.close_square)
                  : const Icon(Iconsax.menu),
              key: ValueKey<bool>(_isMenuVisible),
            ),
          ),
          actions: [
            IconButton(
                iconSize: 25,
                onPressed: _handleSearchPressed,
                icon: Icon(
                  Icons.search,
                  color: Colors.grey.shade700,
                ))
          ],
          title: SizedBox(
            height: 45,
            child: TextField(
              controller: _searchController,
              maxLines: 1,
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none),
                hintText: "Busca un compuesto quimico",
                hintStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              FadeInDown(
                from: 50,
                child: Text(
                  "Resultados de tu busqueda: ",
                  style:
                      TextStyle(color: Colors.blueGrey.shade400, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //SizedBox(
              //  height: MediaQuery.of(context).size.height * 0.5,
              Expanded(
                child: ListView.builder(
                  itemCount: compounds.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTool = index;
                        });
                      },
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 100),
                        child: AnimatedContainer(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 20),
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: selectedTool == index
                                      ? Colors.blue
                                      : Colors.white.withOpacity(0),
                                  width: 2),
                              boxShadow: [
                                selectedTool == index
                                    ? BoxShadow(
                                        color: Colors.blue.shade100,
                                        offset: const Offset(0, 3),
                                        blurRadius: 10)
                                    : BoxShadow(
                                        color: Colors.grey.shade200,
                                        offset: const Offset(0, 3),
                                        blurRadius: 10)
                              ]),
                          child: Row(
                            children: [
                              Image.network(
                                compounds[index]['2d_thumbnail'],
                                width: 75,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      compounds[index]['common_name'],
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${compounds[index]['iupac_name']}",
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Formula molecular: ${compounds[index]['molecular_formula']}",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Peso molecular: ${compounds[index]['molecular_weight']} g/mol",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
