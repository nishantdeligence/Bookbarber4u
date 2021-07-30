import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String password;
  final String email;
  final String role;
  final String profileImage;
  //final String phoneNumber;

  User(
      {this.id,
      this.name,
      this.password,
      this.email,
      this.role,
      this.profileImage
      //this.phoneNumber

      });
  factory User.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return User(
      id: doc['userId'],
      name: doc['userName'],
      password: doc['userPassword'],
      email: doc['userEmail'],
      role: doc['role'],
      profileImage: doc['profile'],
    );
  }
}
