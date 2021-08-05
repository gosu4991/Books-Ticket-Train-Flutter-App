import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:datvetau/providers/gatau.dart';
import 'package:json_table/json_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class GiaGhe {
  late final int idghe;
  late final String maghe;
  late final String tenghe;
  late final int giaghe;

  GiaGhe({
    required this.idghe,
    required this.maghe,
    required this.tenghe,
    required this.giaghe,
  });

  factory GiaGhe.fromJson(Map<String, dynamic> json) {
    return GiaGhe(
      idghe: json['idghe'] as int,
      maghe: json['maghe'] as String,
      tenghe: json['tenghe'] as String,
      giaghe: json['giaghe'] as int,
    );
  }
}

class infoghe extends StatefulWidget {
  @override
  _infogheState createState() => _infogheState();
}

class _infogheState extends State<infoghe> {
  String url =
      'http://610769331f34870017437b9a.mockapi.io/api/thongtingatau/ttghe';
  List<GiaGhe> parseGiaGhe(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<GiaGhe>((json) => GiaGhe.fromJson(json)).toList();
  }

  Future<List<GiaGhe>> fetchGiaGhe(http.Client client) async {
    final response = await client.get(Uri.parse(url));

    // Use the compute function to run parsePhotos in a separate isolate.
    return parseGiaGhe(utf8.decode(response.bodyBytes));
  }

// A function that converts a response body into a List<Photo>.
  @override
  void initState() {
    super.initState();
    fetchGiaGhe(http.Client()).then((value) {
      setState(() {
        giaghe = value;
        usersFiltered = giaghe;
      });
    });
  }

  List<GiaGhe> giaghe = [];
  List<GiaGhe> usersFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: new ListTile(
              leading: new Icon(Icons.search),
              title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      hintText: 'Nhập loại ghế cần tìm',
                      border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      _searchResult = value;
                      usersFiltered = giaghe
                          .where((user) =>
                              user.maghe.contains(_searchResult) ||
                              user.tenghe.contains(_searchResult) ||
                              user.giaghe.toString().contains(_searchResult))
                          .toList();
                    });
                  }),
              trailing: new IconButton(
                icon: new Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    controller.clear();
                    _searchResult = '';
                    usersFiltered = giaghe;
                  });
                },
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'id ghế',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'mã ghế',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'tên ghế',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'giá ghế',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(
                usersFiltered.length,
                (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(usersFiltered[index].idghe.toString())),
                    DataCell(Text(usersFiltered[index].maghe)),
                    DataCell(Text(usersFiltered[index].tenghe)),
                    DataCell(Text(usersFiltered[index].giaghe.toString())),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
