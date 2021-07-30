import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Appointment extends StatefulWidget {
  final index;
  Appointment(
    this.index,
  );

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
 
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};
  var _userReview = '';
  var _userRating = '';
  var _requestedBy = '';
  var _sendedFor = '';
  var _requestedDateAndTime = '';
  var _requestedService = '';

  userSignUp(snap) async {
   
    _requestedBy = snap['requestedBy'];
    _sendedFor = snap['sendedFor'];
    _requestedDateAndTime = snap['requestedDateAndTime'];
    _requestedService = snap['requestedService'];

    final valid = _formKey.currentState.validate();

    if (valid) {
      _formKey.currentState.save();

      try {
        await Firebase.initializeApp();

        userData.addAll({
          'userReview': _userReview.trim(),
          'userRating': _userRating.trim(),
          'requestedBy': _requestedBy,
          'sendedFor': _sendedFor,
          'requestedDateAndTime': _requestedDateAndTime,
          'requestedService': _requestedService,
          'timestamp': DateTime.now(),
        });

        await FirebaseFirestore.instance.collection('Reviews').add(userData);

        print(userData);

        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  final collectionReference =
      FirebaseFirestore.instance.collection("Appointments");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.indigo[50],
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 8.0),
                        Text(
                          "Appointments",
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.315,
                
                padding: EdgeInsets.all(20.0),
                child: StreamBuilder(
                  stream: collectionReference
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      QuerySnapshot s = snapshot.data;
                      if (s.docs.isEmpty == true) {
                        return Center(
                          child: Container(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                    }
                    return Container(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          var snap = snapshot.data.docs[index];
                          DateTime dateTime =
                              DateTime.parse(snap['requestedDateAndTime']);

                          
                          if (snap["sendedFor"] ==
                              FirebaseAuth.instance.currentUser.uid) {
                            return Card(
                              color: snap['requestAcceptedStatus'] == "accepted"
                                  ? Colors.green[100]
                                  : snap['requestAcceptedStatus'] == "rejected"
                                      ? Colors.red[100]
                                      : Colors.yellow[100],
                              child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {},
                                child: Container(
                                  height: 200,
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      snap['requestAcceptedStatus'] ==
                                              "accepted"
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.green[600],
                                              size: 50.0,
                                            )
                                          : snap['requestAcceptedStatus'] ==
                                                  "rejected"
                                              ? Icon(
                                                  Icons.error,
                                                  color: Colors.red[600],
                                                  size: 50.0,
                                                )
                                              : snap['requestAcceptedStatus'] ==
                                                      "completed"
                                                  ? Icon(
                                                      Icons.done,
                                                      color: Colors.blue[600],
                                                      size: 50.0,
                                                    )
                                                  : Icon(
                                                      Icons.pending,
                                                      color: Colors.yellow[600],
                                                      size: 50.0,
                                                    ),
                                      snap['requestAcceptedStatus'] ==
                                              "accepted"
                                          ? Text(
                                              'You have Confirmed ',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : snap['requestAcceptedStatus'] ==
                                                  "rejected"
                                              ? Text(
                                                  'You have Rejected ',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              : snap['requestAcceptedStatus'] ==
                                                      "completed"
                                                  ? Text(
                                                      'You have Completed ',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      'You have Pending ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                      snap['requestAcceptedStatus'] ==
                                              "accepted"
                                          ? Text(
                                              'Appointment ',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : snap['requestAcceptedStatus'] ==
                                                  "rejected"
                                              ? Text(
                                                  'Appointment',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              : snap['requestAcceptedStatus'] ==
                                                      "completed"
                                                  ? Text(
                                                      'Appointment',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      'Appointment ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      snap['requestAcceptedStatus'] ==
                                              "accepted"
                                          ? Text(
                                              'Booking For : ${snap['requestedService']}',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          : snap['requestAcceptedStatus'] ==
                                                  "rejected"
                                              ? Text(
                                                  'Booking For : ${snap['requestedService']}',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                )
                                              : snap['requestAcceptedStatus'] ==
                                                      "completed"
                                                  ? Text(
                                                      'Booking For : ${snap['requestedService']}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )
                                                  : Text(
                                                      'Booking For : ${snap['requestedService']}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                      snap['requestAcceptedStatus'] ==
                                              "accepted"
                                          ? Text(
                                              'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          : snap['requestAcceptedStatus'] ==
                                                  "rejected"
                                              ? Text(
                                                  'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                )
                                              : snap['requestAcceptedStatus'] ==
                                                      "completed"
                                                  ? Text(
                                                      'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )
                                                  : Text(
                                                      'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snap["requestedBy"] ==
                              FirebaseAuth.instance.currentUser.uid) {
                            return Card(
                              child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  if (snap["requestAcceptedStatus"] ==
                                      "completed") {
                                    // FirebaseFirestore.instance.collection('Reviews').snapshots().listen((value) {
                                    //   value.docs.forEach((element) {
                                    //     if(element.data()['requestedService'] == snap['requestedService'] && element.data()['requestedDateAndTime'] == snap['requestedDateAndTime']){
                                    //       return showDialog(context: context, builder: (_)=> AlertDialog(
                                    //         title : Text('You have Given the review'),
                                    //         content: Text('Thanks for Giving you Review'), 
                                    //         actions: [
                                    //           TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('back')),
                                    //         ],
                                    //       ));
                                    //     }
                                        
                                    //    });                                     
                                    // });
                                    return showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            Text('Write Review About Service'),
                                        content: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3.5,
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              children: [
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 100,
                                                  child: TextFormField(
                                                    maxLength: 100,
                                                    maxLines: 5,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 14.0),
                                                      hintText:
                                                          "Enter Your Review",
                                                    ),
                                                    onSaved: (value) {
                                                      _userReview = value;
                                                    },
                                                    validator: (value) {
                                                      return (value.isEmpty ||
                                                              value.length < 10)
                                                          ? "Please enter at least 10 characters"
                                                          : null;
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  // decoration:,
                                                  height: 60,
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 14.0),
                                                      hintText:
                                                          "Enter Rating out of (1-5) ",
                                                    ),
                                                    onChanged: (value) {
                                                      _userRating = value;
                                                    },
                                                    validator: (value) {
                                                      return (value.isEmpty)
                                                          ? 'Please enter rating'
                                                          : null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(height: 10.0),
                                                Container(
                                                  height: 40,
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        userSignUp(snap),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          80.0)),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                    ),
                                                    child: Ink(
                                                      decoration:
                                                          const BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              Color(0xFF0D47A1),
                                                              Color(0xFF1976D2),
                                                              Color(0xFF42A5F5),
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    80.0)),
                                                      ),
                                                      child: Container(
                                                        constraints:
                                                            const BoxConstraints(
                                                                minWidth: 88.0,
                                                                minHeight:
                                                                    36.0), // min sizes for Material buttons
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text(
                                                          'Submit',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 200,
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: snap["requestAcceptedStatus"] ==
                                            "accepted"
                                        ? [
                                            Icon(
                                              Icons.done,
                                              color: Colors.green,
                                              size: 50.0,
                                            ),
                                            Text(
                                              'Your Appointment Request',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              'Accepted',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Divider(
                                              color: Colors.black,
                                            ),
                                            Text(
                                              'Booking For : ${snap['requestedService']}',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ]
                                        : snap["requestAcceptedStatus"] ==
                                                "rejected"
                                            ? [
                                                Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 50.0,
                                                ),
                                                Text(
                                                  'Your Appointment Request',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  'Rejected',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  'Booking For : ${snap['requestedService']}',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ]
                                            : snap["requestAcceptedStatus"] ==
                                                    "completed"
                                                ? [
                                                    Icon(
                                                      Icons.done,
                                                      color: Colors.blue,
                                                      size: 50.0,
                                                    ),
                                                    Text(
                                                      'Your Appointment Request',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      'Completed',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                      'Give Review By OnTap',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      'Booking For : ${snap['requestedService']}',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ]
                                                : [
                                                    Icon(
                                                      Icons.pending,
                                                      color: Colors.yellow[700],
                                                      size: 50.0,
                                                    ),
                                                    Text(
                                                      'Your Appointment Request',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      'Inprogress',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Divider(
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                      'Booking For : ${snap['requestedService']}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      'Schedule : ${dateTime.year}-${dateTime.month}-${dateTime.day} at ${dateTime.hour}:${dateTime.minute}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
