import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;

 CustomListTile({Key key, this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.black, fontSize: 18.0),),
          // GestureDetector(
          //   child: Text(
          //     "view all",
          //      style: TextStyle(
          //        color: Colors.blue),
          //        ),
          //        onTap: (){},
          //        )
        ],
      ),
      
    );
  }
}