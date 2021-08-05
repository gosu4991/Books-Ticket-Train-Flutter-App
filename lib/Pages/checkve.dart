import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CheckVe {
  final int id;
  final String mactau;
  final String gadiden;
  final String hoten;
  final String cmnd;
  final String doituong;
  final String tenghe;
  final int sttghe;

  CheckVe(
      {required this.id,
      required this.mactau,
      required this.gadiden,
      required this.hoten,
      required this.cmnd,
      required this.doituong,
      required this.tenghe,
      required this.sttghe});

  factory CheckVe.fromJson(Map<String, dynamic> json) {
    return CheckVe(
      id: json['id'],
      mactau: json['mactau'],
      gadiden: json['gadiden'],
      hoten: json['hoten'],
      cmnd: json['cmnd'],
      tenghe: json['tenghe'],
      sttghe: json['sttghe'],
      doituong: json['doituong'],
    );
  }
}

class checkve extends StatefulWidget {
  @override
  _checkveState createState() => _checkveState();
}

final TextEditingController _controller = TextEditingController();
late final Future<CheckVe> futureAlbum;

Future<CheckVe> fetchGiaVe(String cmnd) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/tracuuve/$cmnd'),
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return CheckVe.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Lỗi');
  }
}

class _checkveState extends State<checkve> {
  bool visibile = false;
  Future<CheckVe>? _checkve;
  TextEditingController name = new TextEditingController();
  var ok = "";
  @override
  Widget build(context) {
    return Scaffold(
        body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(7),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: name,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Nhập cmnd',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onPressed: () async {
                    setState(() {
                      _checkve = fetchGiaVe(name.text);
                      if (_checkve != null) {
                        visibile = !visibile;
                      } else {
                        visibile = false;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Tra Cứu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
          visible: visibile,
          child: Center(
              child: FutureBuilder<CheckVe>(
            future: _checkve,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'ID',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Mác tàu',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Họ tên',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Ga đi - đến',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Loại ghế',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Số ghế',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'CMND',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Đối tượng',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: List.generate(
                        1,
                        (index) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(snapshot.data!.id.toString())),
                            DataCell(Text(snapshot.data!.mactau)),
                            DataCell(Text(snapshot.data!.hoten)),
                            DataCell(Text(snapshot.data!.gadiden)),
                            DataCell(Text(snapshot.data!.tenghe)),
                            DataCell(Text(snapshot.data!.sttghe.toString())),
                            DataCell(Text(snapshot.data!.cmnd)),
                            DataCell(Text(snapshot.data!.doituong)),
                          ],
                        ),
                      ),
                    ));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          )))
    ]));
  }
}
