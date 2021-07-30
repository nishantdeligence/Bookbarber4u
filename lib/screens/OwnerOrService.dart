import 'package:barber/screens/Dashbord.dart';
import 'package:barber/screens/detailOwnerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OwnerOrService extends StatefulWidget {
  final Map<String, dynamic> userData;
  OwnerOrService(this.userData);
  @override
  _OwnerOrServiceState createState() => _OwnerOrServiceState();
}

class _OwnerOrServiceState extends State<OwnerOrService> {
  Future role() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(widget.userData);

    print('test with role-----');
    print(widget.userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 22.0),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Text(
                        'You Here For ? ',
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 25.0, top: 50.0),
                child: Text(
                  'You Can Select Any one :',
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                          width: 250.0,
                          height: 200,
                          child: GestureDetector(
                            onTap: () {
                              widget.userData.addAll({'role': 'saloonOwner'});                             
                              role();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailOwnerPage(widget.userData)));
                            },
                            child: Card(
                              elevation: 30.0,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/barberlogo.png',
                                      width: 104.0,
                                      height: 100,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      'I am a Saloon Owner',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                      SizedBox(height: 30.0),
                      SizedBox(
                        width: 250.0,
                        height: 200,
                        child: GestureDetector(
                          onTap: () {
                            widget.userData.addAll({'role': 'client'});                           
                            role();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard()));
                          },
                          child: Card(
                            elevation: 30.0,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset('assets/images/barberlogo.png',
                                      width: 104.0, height: 100),
                                  SizedBox(height: 20.0),
                                  Text(
                                    'I want Saloon Service',
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
