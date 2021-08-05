import 'package:datvetau/Pages/bookve.dart';
import 'package:datvetau/Pages/checkve.dart';
import 'package:datvetau/Pages/infogatau.dart';
import 'package:datvetau/Pages/infoghe.dart';
import 'package:datvetau/Pages/sidebarmenu.dart';
import 'package:flutter/material.dart';
import 'package:datvetau/contentOnboarding/carditem.dart';

import 'Chatbot.dart';

class Mainpage extends StatefulWidget {
  Mainpage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sidebarmenu(),
      appBar: AppBar(
        title: Text("Vé tàu hỏa "),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Flexible(
              child: Image(
            image: AssetImage('assets/bannertau.jpg'),
          )),
          SizedBox(
            height: 15,
          ),
          Container(
            height: 79,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                CategoryCard(
                    IconButton(
                      icon: Image.asset('assets/thongtingatau.jpg'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => infogatau(),
                            ));
                      },
                    ),
                    "Thông tin ga tàu"),
                CategoryCard(
                    IconButton(
                        icon: Image.asset('assets/giaghe.jpg'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => infoghe(),
                              ));
                        }),
                    "Giá ghế"),
                CategoryCard(
                    IconButton(
                        icon: Image.asset('assets/checkve.jpg'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => checkve(),
                              ));
                        }),
                    "Kiểm tra vé"),
                CategoryCard(
                    IconButton(
                        icon: Image.asset('assets/datve.jpg'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookTickets(),
                              ));
                        }),
                    "Đặt vé"),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          const Divider(
            height: 10,
            color: Colors.red,
            thickness: 2,
            indent: 5,
            endIndent: 5,
          ),
          Column(children: [
            Text(
              "Đại lý vé tàu hỗ trợ 24h",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ]),
          SizedBox(
            height: 7,
          ),
          Flexible(
              child: Image(
            image: AssetImage('assets/bannertet.jpg'),
          )),
          SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "cung cấp dịch vụ vé tàu nhanh nhất tiện lợi nhất cho bạn mỗi ngày, chúng tôi sẽ giúp bạn có một dịch vụ đặt vé tàu nhanh chóng, tiết kiệm thời gian đi lại, luôn luôn hỗ trợ đến 22h tất cả các ngày trong tuần.",
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              )),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[100],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chatbot tư vấn',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Mainpage(),
                    ));
                break;
              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UI(),
                    ));
                break;
            }
          }),
    );
  }
}
