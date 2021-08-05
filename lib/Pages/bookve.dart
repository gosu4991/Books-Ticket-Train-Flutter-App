import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

List t = [];
List<Gatau> data1 = [];
List<String> soghe = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
List<String> loaighe = [
  'ghế ngồi cứng không điều hòa',
  'ghế ngồi cứng điều hoà',
  'ghế ngồi mềm không điều hòa',
  'ghế ngồi mềm có điều hòa',
  'Giường cứng tầng 1 không điều hòa',
  'Giường cứng tầng 2 không điều hòa'
];
var currentSelectedValue;
var currentGatau;
var currentSoghe;
var currentloaighe;
final List<String> mt = [];
final List<String> ga = [];

class Mactau {
  final String mactau;

  Mactau({required this.mactau});

  factory Mactau.fromJson(Map<String, dynamic> json) {
    return Mactau(
      mactau: json['mactau'],
    );
  }
}

class Gatau {
  final String gadiden;

  Gatau({required this.gadiden});

  factory Gatau.fromJson(Map<String, dynamic> json) {
    return Gatau(
      gadiden: json['gadiden'],
    );
  }
}

List<Gatau> parseGatau(String responseBody) {
  final parsed1 = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed1.map<Gatau>((json) => Gatau.fromJson(json)).toSet().toList();
}

List<Mactau> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Mactau>((json) => Mactau.fromJson(json)).toList();
}

Future<List<Mactau>> getmactau() async {
  var response =
      await http.get(Uri.parse("http://127.0.0.1:8000/api/ttmactau"));
  List<Mactau> data = [];
  data = parsePhotos(response.body);
  for (int i = 0; i < data.length; i++) {
    mt.add(data[i].mactau);
  }
  //t.insert(0, {"data": 1, "message": mt});
  return parsePhotos(response.body);
}

Future<List<Gatau>> getgatau(String mactau) async {
  var response =
      await http.get(Uri.parse("http://127.0.0.1:8000/api/tracuuga/$mactau"));
  data1 = parseGatau(response.body);
  for (int i = 0; i < data1.length; i++) {
    ga.add(data1[i].gadiden);
  }
  return parseGatau(response.body);
}

class BookTickets extends StatefulWidget {
  @override
  _BookTicketsState createState() => _BookTicketsState();
}

class _BookTicketsState extends State<BookTickets> {
  TextEditingController hoten = TextEditingController();
  TextEditingController cmnd = TextEditingController();
  Future<List<Mactau>>? mactau;
  Future<List<Gatau>>? gatau;
  @override
  void initState() {
    super.initState();
    ga.clear();
    mactau = getmactau();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đặt vé tàu'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: 50,
          width: 50,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: HexColor("#F5F4F4"),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: FutureBuilder<List<Mactau>>(
                    future: mactau,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError)
                        print(snapshot.error);
                      else if (snapshot.hasData) {
                        return DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: currentSelectedValue,
                              iconSize: 15,
                              elevation: 16,
                              icon: const Icon(Icons.arrow_downward),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              hint: Center(
                                child: Text(
                                  "Chọn mác tàu",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  ga.clear();
                                  currentSelectedValue = newValue!;
                                  gatau = getgatau(currentSelectedValue);
                                  print(currentSelectedValue);
                                });
                              },
                              items: mt.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: HexColor("#F5F4F4"),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: FutureBuilder<List<Gatau>>(
                    future: gatau,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError)
                        print(snapshot.error);
                      else if (snapshot.hasData) {
                        return DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: currentGatau,
                              iconSize: 15,
                              elevation: 16,
                              icon: const Icon(Icons.arrow_downward),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              hint: Center(
                                child: Text(
                                  "Chọn ga đi - đến",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  currentGatau = newValue!;
                                  print(currentGatau);
                                });
                              },
                              items: ga.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Center(
                                    child: Text(
                                      value,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: HexColor("#F5F4F4"),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: currentSoghe,
                    iconSize: 15,
                    elevation: 16,
                    icon: const Icon(Icons.arrow_downward),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hint: Center(
                      child: Text(
                        "Chọn số ghế",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        currentSoghe = newValue!;
                      });
                    },
                    items: soghe.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ))
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: HexColor("#F5F4F4"),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: currentloaighe,
                    iconSize: 15,
                    elevation: 16,
                    icon: const Icon(Icons.arrow_downward),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hint: Center(
                      child: Text(
                        "Chọn loại ghế",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        currentloaighe = newValue!;
                      });
                    },
                    items: loaighe.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ))
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            child: TextFormField(
          textAlign: TextAlign.center,
          controller: hoten,
          keyboardType: TextInputType.name,
          style: TextStyle(
            color: Colors.black,
          ),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: "Nhập Họ tên",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(1.0),
              fontSize: 10,
            ),
          ),
        )),
        SizedBox(
          height: 15,
        ),
        Container(
            child: TextFormField(
          textAlign: TextAlign.center,
          controller: cmnd,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.black,
          ),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            hintText: "Nhập CMND",
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(1.0),
              fontSize: 10,
            ),
          ),
        )),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: FlatButton(
            child: Text('Đặt vé'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () {
              print("chức năng chưa hoàn thiện");
            },
          ),
        ),

        //======================================================== State
      ]),
    );
  }
}
