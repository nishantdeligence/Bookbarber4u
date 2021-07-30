/*

import 'package:barber/screens/SaloonProfile.dart';
import 'package:barber/models/barbershoplist.dart';
import 'package:flutter/material.dart';

class BarbershopCard extends StatelessWidget {
  final Barbershop barbershop;

  BarbershopCard({Key key, this.barbershop});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SaloonProfile()));
      },
      child: Container(
        width: 200.0,
       
        margin: EdgeInsets.only(left: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                image: DecorationImage(
                  image: AssetImage(barbershop.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 140.0,
                  child: Text(
                    barbershop.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.star,
                  size: 15.0,
                  color: Colors.yellow,
                ),
                Text(
                  barbershop.rating,
                ),
              ],
            ),
            Text(
              barbershop.address,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
*/