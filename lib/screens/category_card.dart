import 'package:barber/models/category.dart';
import 'package:barber/screens/SaloonProfile.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({Key key, this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Saloon(category)));
      },
          child: Container(
        width: 70.0,
        margin: EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: category.color,
              child: Image.asset(
                category.icon,
                color: Colors.white,
                width: 25.0,
              ),
            ),
            Text(category.title, style: TextStyle(fontSize: 16.0)),           
            Text(''),
          ],
        ),
      ),
    );
  }
}
