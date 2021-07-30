import 'package:cloud_firestore/cloud_firestore.dart';

class Saloon {
     
  final String saloonId;
  final String saloonName;
  final String saloonDescription;
  final String saloonLocation;
  final String saloonOpeningTime;
  final String saloonClosingTime;
  final String saloonOther;
  final Map saloonDays;
  final Map saloonServices;
  final Map saloonPictures;


  //final String phoneNumber;

  Saloon(
      {this.saloonId,
      this.saloonName,
      this.saloonDescription,
      this.saloonLocation,
      this.saloonOpeningTime,
      this.saloonClosingTime,
      this.saloonOther,
      this.saloonDays,
      this.saloonServices,
      this.saloonPictures,
      //this.phoneNumber

      });
  factory Saloon.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return Saloon(
      saloonId: doc['saloonId'],
      saloonName: doc['saloonName'],
      saloonDescription: doc['saloonDescription'],
      saloonLocation: doc['saloonLocation'],
      saloonOpeningTime: doc['saloonOpeningTime'],
      saloonClosingTime: doc['saloonClosingTime'],
      saloonOther: doc['saloonOther'],
      saloonDays: doc['saloonDays'],
      saloonServices: doc['saloonServices'],
      saloonPictures: doc['saloonPictures'],
      
    );
  }
}
