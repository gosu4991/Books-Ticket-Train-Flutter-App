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

class GaTau {
  late final String gadiden;
  late final int culy;
  late final String giodi;
  late final String gioden;
  late final String mactau;

  GaTau({
    required this.gadiden,
    required this.culy,
    required this.giodi,
    required this.gioden,
    required this.mactau,
  });

  factory GaTau.fromJson(Map<String, dynamic> json) {
    return GaTau(
      gadiden: json['gadiden'] as String,
      culy: json['culy'] as int,
      giodi: json['giodi'] as String,
      gioden: json['gioden'] as String,
      mactau: json['mactau'] as String,
    );
  }
}

class infogatau extends StatefulWidget {
  @override
  _infogatauState createState() => _infogatauState();
}

class _infogatauState extends State<infogatau> {
  String url =
      'http://610769331f34870017437b9a.mockapi.io/api/thongtingatau/ttga';
  List<GaTau> parseGiaGhe(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GaTau>((json) => GaTau.fromJson(json)).toList();
  }

  Future<List<GaTau>> fetchGiaGhe(http.Client client) async {
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
        gatau = value;
        usersFiltered = gatau;
      });
    });
  }

  List<GaTau> gatau = [];
  List<GaTau> usersFiltered = [];
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
                      hintText: 'Nhập ga cần tìm', border: InputBorder.none),
                  onChanged: (value) {
                    setState(() {
                      _searchResult = value;
                      usersFiltered = gatau
                          .where((user) =>
                              user.gadiden.contains(_searchResult) ||
                              user.mactau.contains(_searchResult) ||
                              user.culy.toString().contains(_searchResult))
                          .toList();
                    });
                  }),
              trailing: new IconButton(
                icon: new Icon(Icons.cancel),
                onPressed: () {
                  setState(() {
                    controller.clear();
                    _searchResult = '';
                    usersFiltered = gatau;
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
                    'Ga đi - đến',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Khoảng cách',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Giờ khởi hành',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Giờ đến',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Mã tàu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: List.generate(
                usersFiltered.length,
                (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(usersFiltered[index].gadiden)),
                    DataCell(Text(usersFiltered[index].culy.toString())),
                    DataCell(Text(usersFiltered[index].giodi)),
                    DataCell(Text(usersFiltered[index].gioden.toString())),
                    DataCell(Text(usersFiltered[index].mactau)),
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
