import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:datvetau/Pages/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

List t = [];
List<Gatau> data1 = [];
List<String> soghe = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
List<String> doituong = ['trẻ em', 'người lớn'];

var currentmactau;
var currentGatau;
var currentSoghe;
var currentloaighe;
var currentdoituong;
final List<String> mt = [];
final List<String> ga = [];
final List<String> gg = [];

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

class GiaGhe {
  late final int idghe;
  late final String tenghe;

  GiaGhe({
    required this.idghe,
    required this.tenghe,
  });

  factory GiaGhe.fromJson(Map<String, dynamic> json) {
    return GiaGhe(
      idghe: json['idghe'] as int,
      tenghe: json['tenghe'] as String,
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

List<GiaGhe> parseGiaGhe(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<GiaGhe>((json) => GiaGhe.fromJson(json)).toList();
}

Future<List<GiaGhe>> getgiaghe() async {
  var response = await http.get(Uri.parse(
      "https://610769331f34870017437b9a.mockapi.io/api/thongtingatau/ttghe"));
  List<GiaGhe> data = [];
  data = parseGiaGhe(utf8.decode(response.bodyBytes));
  for (int i = 0; i < data.length; i++) {
    gg.add(data[i].idghe.toString());
  }
  //t.insert(0, {"data": 1, "message": mt});
  return parseGiaGhe(utf8.decode(response.bodyBytes));
}

Future<http.Response> datve(String mactau, String gadiden, int sttghe,
    int id_ghe, String hoten, String cmnd, String doituong) {
  return http.post(
    Uri.parse('http://127.0.0.1:8000/api/datve'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'mactau': mactau,
      'gadiden': gadiden,
      'sttghe': sttghe,
      'id_ghe': id_ghe,
      'hoten': hoten,
      'cmnd': cmnd,
      'doituong': doituong,
    }),
  );
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
  Future<List<GiaGhe>>? giaghe;
  @override
  void initState() {
    super.initState();
    ga.clear();
    mactau = getmactau();
    giaghe = getgiaghe();
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
                  child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: currentmactau,
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
                        currentmactau = newValue!;
                        gatau = getgatau(currentmactau);
                      });
                    },
                    items: <String>['SE1', 'SE2', 'TN1', 'TN2']
                        .map((String value) {
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
                child: FutureBuilder<List<GiaGhe>>(
                    future: giaghe,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError)
                        print(snapshot.error);
                      else if (snapshot.hasData) {
                        return DropdownButtonHideUnderline(
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
                                  print(currentloaighe);
                                });
                              },
                              items: gg.map((value) {
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
                    value: currentdoituong,
                    iconSize: 15,
                    elevation: 16,
                    icon: const Icon(Icons.arrow_downward),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hint: Center(
                      child: Text(
                        "Chọn đối tượng",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        currentdoituong = newValue!;
                      });
                    },
                    items: doituong.map((String value) {
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
          margin: EdgeInsets.all(20),
          child: FlatButton(
            child: Text('Đặt vé'),
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () async {
              datve(
                  currentmactau,
                  currentGatau,
                  int.parse(currentSoghe),
                  int.parse(currentloaighe),
                  hoten.text,
                  cmnd.text,
                  currentdoituong);
              if (datve != null) {
                Fluttertoast.showToast(
                    msg: "Đặt vé thành công, chuyển về trang chủ sau 3s",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Timer(Duration(seconds: 3), () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Mainpage(),
                  ));
                });
              } else {
                Fluttertoast.showToast(
                    msg: "Đặt vé thất bại",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          ),
        ),

        //======================================================== State
      ]),
    );
  }
}
