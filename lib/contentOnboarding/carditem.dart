import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final IconButton icon;
  final String name;

  CategoryCard(this.icon, this.name);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.blueGrey)],
          ),
          width: 55,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                icon,
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Text(name, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))
    ]);
  }
}
