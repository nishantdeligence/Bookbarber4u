import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  final String getDateTime;

  Notifications({this.getDateTime});
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    //_getData();
    _makeMatches();
  }

  CollectionReference docRef =
      FirebaseFirestore.instance.collection('Notifications');
  CollectionReference docRefUsers =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference docRefOwnership =
      FirebaseFirestore.instance.collection('Ownership');
  CollectionReference refAppointments =
      FirebaseFirestore.instance.collection('Appointments');

  var requestedBy;
  var sendedFor;
  _makeMatches() {
    docRef.snapshots().listen((data) {
      data.docs.forEach((element) {
        // print(element['requestedBy']);
        // print('test---');
        // print(element['sendedFor']);
        docRefUsers
            .doc('${element['requestedBy']}')
            .snapshots()
            .listen((data1) {
          docRefUsers
              .doc('${element['sendedFor']}')
              .snapshots()
              .listen((event1) {
            print('test---');
            //print(event1.data());
            requestedBy = data1.data();
            sendedFor = event1.data();
            if (mounted) setState(() {});
            //print(requestedBy['userId']);

            // if(data1.data()){

            // }

            //  docRefUsers
            //     .doc('${element['requestedBy']}')
            //     .collection('Matches')
            //     .doc('${element['sendedFor']}')
            //     .set({

            //     });
          });
        });
      });
    });
  }

  // _makeMatches() async {
  //   var user = _firebaseAuth.currentUser;
  //   //print(user.uid);
  //   return docRef.snapshots().listen((data) async {
  //     data.docs.forEach((element) {
  //       print(element['requestedBy']);
  //       print('test---');
  //       print(element['sendedFor']);

  //       docRefUsers
  //           .doc('${element['requestedBy']}')
  //           .snapshots()
  //           .listen((data1) async {
  //         await docRefUsers
  //             .doc('${element['requestedBy']}')
  //             .collection('Matches')
  //             .doc('${element['sendedFor']}')
  //             .set({});

  //         print(data1.data());
  //         //    print('test---');
  //         // print(element['sendedFor']);
  //       });
  //     });
  //   });
  // }

//   List sendedForData = [];
//   List requestedByData = [];

//   Future _getData() async {
//     // QuerySnapshot snap = await FirebaseFirestore.instance
//     //     .collection('Notifications')
//     //     .orderBy("timestamp", descending: true)
//     //     .get();

//     // List ss = snap.docs;
//     // //print(ss[0]['notificationId']);

// var element2 ;
//     QuerySnapshot snap2 = await FirebaseFirestore.instance
//         .collection('Notifications')
//         .orderBy("timestamp", descending: true)
//         .get().then((QuerySnapshot value) async {
//           value.docs.forEach((element) {
//             if(element["sendedFor"] == FirebaseAuth.instance.currentUser.uid){
//                element2 = element.data();
//               print('yess');
//               sendedForData.add(element2);
//               //return element['sendedFor'];
//             }
//             if(element["requestedBy"] == FirebaseAuth.instance.currentUser.uid) {
//               print('no');
//               requestedByData.add(element);
//             }
//             print('data');
//           });
//           print(element2);

//                     return ;
//         });
//    var ss2 = snap2.docs;
//    print(ss2);
//   }
  var time;
  var userdata;
  var timedata;
  var userdatareq;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Notifications",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search...",
          //       hintStyle: TextStyle(color: Colors.grey.shade600),
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: Colors.grey.shade600,
          //         size: 20,
          //       ),
          //       filled: true,
          //       fillColor: Colors.grey.shade100,
          //       contentPadding: EdgeInsets.all(8),
          //       enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(20),
          //           borderSide: BorderSide(color: Colors.grey.shade100)),
          //     ),
          //   ),
          // ),
          Container(
            height: MediaQuery.of(context).size.height / 1.35,
            width: double.infinity,
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Notifications')
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

                  //print(snapshot.data.docs);
                  return Container(
                    child: ListView.builder(
                        padding: EdgeInsets.all(18.0),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var snap = snapshot.data.docs[index];
                          var timestamp = DateTime.parse(
                              snap['timestamp'].toDate().toString());

                          // Saloon Owner has got the request from client
                          if (snap['sendedFor'] ==
                              FirebaseAuth.instance.currentUser.uid) {
                            //print('SendedFor data');

                            return Container(
                                child: Card(
                              color: snap['status'] == "accepted"
                                  ? Colors.indigo[100]
                                  : snap['status'] == "rejected"
                                      ? Colors.red[100]
                                      : Colors.yellow[100],
                              //Colors.yellow[100],
                              child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  refAppointments
                                      .doc(snap['notificationId'])
                                      .snapshots()
                                      .listen((data) {
                                    print('test---1');
                                    time = data.data();
                                    //print(time);
                                  });

                                  docRefUsers
                                      .doc(snap['requestedBy'])
                                      .snapshots()
                                      .listen((data) {
                                    print('test---2');
                                    userdata = data.data();
                                    //print(userdata['userName']);
                                  });
                                  if (userdata != null) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                            'Do you want to book this Appointment ?'),
                                        content: Wrap(
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      userdata['userName'] !=
                                                              null
                                                          ? 'Client Name : ${userdata['userName']}'
                                                          : '',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.6)),
                                                  Text(
                                                      userdata['userEmail'] !=
                                                              null
                                                          ? 'Client Email : ${userdata['userEmail']}'
                                                          : '',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.6)),
                                                  Text(
                                                      'Booking For : ${time['requestedService'] ?? ''}',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.6)),
                                                  Text(
                                                    'Scheduling For : ${DateTime.parse(time['requestedDateAndTime']).year}-${DateTime.parse(time['requestedDateAndTime']).month}-${DateTime.parse(time['requestedDateAndTime']).day} at ${DateTime.parse(time['requestedDateAndTime']).hour}:${DateTime.parse(time['requestedDateAndTime']).minute}',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.6),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          Container(
                                            child: Wrap(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        //print(snap['notificationId']);
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Notifications')
                                                            .doc(snap[
                                                                'notificationId'])
                                                            .update({
                                                          'status': 'accepted'
                                                        }).then((value) async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Appointments')
                                                              .doc(snap[
                                                                  'notificationId'])
                                                              .update({
                                                            'requestAcceptedStatus':
                                                                'accepted'
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Accept',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        //print(snap['notificationId']);

                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Notifications')
                                                            .doc(snap[
                                                                'notificationId'])
                                                            .update({
                                                          'status': 'rejected'
                                                        }).then((value) async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Appointments')
                                                              .doc(snap[
                                                                  'notificationId'])
                                                              .update({
                                                            'requestAcceptedStatus':
                                                                'rejected'
                                                          });
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Back',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .yellow[700],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // for completed status
                                          snap['status'] == "accepted"
                                              ? Center(
                                                  child: TextButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'Notifications')
                                                        .doc(snap[
                                                            'notificationId'])
                                                        .update({
                                                      'status': 'completed'
                                                    }).then((value) async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Appointments')
                                                          .doc(snap[
                                                              'notificationId'])
                                                          .update({
                                                        'requestAcceptedStatus':
                                                            'completed'
                                                      });
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    'Completed',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ))
                                              : Container(),
                                        ],
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
                                    children: [
                                      snap['status'] == "accepted"
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.green[600],
                                              size: 50.0,
                                            )
                                          : snap['status'] == "rejected"
                                              ? Icon(
                                                  Icons.error,
                                                  color: Colors.red[600],
                                                  size: 50.0,
                                                )
                                              : snap['status'] == "completed"
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
                                      snap['status'] == "accepted"
                                          ? Text(
                                              'You have Booking request !',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : snap['status'] == "rejected"
                                              ? Text(
                                                  'You have Booking request !',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              : snap['status'] == "completed"
                                                  ? Text(
                                                      'You have Booking request !',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      'You have Booking request !',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                      snap['status'] == "accepted"
                                          ? Text(
                                              'Confirmed',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : snap['status'] == "rejected"
                                              ? Text(
                                                  'Rejected',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              : snap['status'] == "completed"
                                                  ? Text(
                                                      'Completed',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      'Pending',
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
                                      snap['status'] == "accepted"
                                          ? Text(
                                              'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          : snap['status'] == "rejected"
                                              ? Text(
                                                  'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                )
                                              : snap['status'] == "completed"
                                                  ? Text(
                                                      'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )
                                                  : Text(
                                                      'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
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
                            ));
                          }
                          // if Users/saloon Owner has requested to take saloon service from other Saloon
                          if (snap['requestedBy'] ==
                              FirebaseAuth.instance.currentUser.uid) {
                            //print('requestedBy data');

                            return Container(
                                child: Card(
                              color: Colors.blue[100],
                              child: InkWell(
                                splashColor: Colors.black,
                                onTap: () {
                                  refAppointments
                                      .doc(snap['notificationId'])
                                      .snapshots()
                                      .listen((data) {
                                    print('test---3');
                                    timedata = data.data();
                                    //print(timedata);
                                  });

                                  docRefOwnership
                                      .doc(snap['sendedFor'])
                                      .snapshots()
                                      .listen((data) {
                                    print('test---4');
                                    userdatareq = data.data();
                                    //print(userdatareq['userName']);
                                  });

                                  if (userdatareq != null) {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Your Booking Details!'),
                                        content: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userdatareq['saloonName'] !=
                                                        null
                                                    ? 'Saloon Name : ${userdatareq['saloonName']}'
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.6),
                                              ),
                                              Text(
                                                userdatareq['saloonName'] !=
                                                        null
                                                    ? 'Saloon Location : ${userdatareq['saloonLocation'] ?? ''}'
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.6),
                                              ),
                                              Text(
                                                'Booking For : ${timedata['requestedService']} ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.6),
                                              ),
                                              Text(
                                                'Scheduling For : ${DateTime.parse(timedata['requestedDateAndTime']).year}-${DateTime.parse(timedata['requestedDateAndTime']).month}-${DateTime.parse(timedata['requestedDateAndTime']).day} at ${DateTime.parse(timedata['requestedDateAndTime']).hour}:${DateTime.parse(timedata['requestedDateAndTime']).minute}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.6),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Back',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ],
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
                                    children: [
                                      snap['status'] == "accepted"
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.green[600],
                                              size: 50.0,
                                            )
                                          : snap['status'] == "rejected"
                                              ? Icon(
                                                  Icons.error,
                                                  color: Colors.red[600],
                                                  size: 50.0,
                                                )
                                              : snap['status'] == "completed"
                                                  ? Icon(
                                                      Icons.done,
                                                      color: Colors.blue[600],
                                                      size: 50.0,
                                                    )
                                                  : Icon(
                                                      Icons.pending,
                                                      color: Colors.yellow[800],
                                                      size: 50.0,
                                                    ),
                                      snap['status'] == "accepted"
                                          ? Text(
                                              'Your Booking Accepted',
                                              style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : snap['status'] == "rejected"
                                              ? Text(
                                                  'Your Booking Rejected',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                )
                                              : snap['status'] == "completed"
                                                  ? Text(
                                                      'Your Booking Completed',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.blue[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    )
                                                  : Text(
                                                      'Your Booking Request Inprogress',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      snap['status'] == "accepted"
                                          ? Text(
                                              'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                              style: TextStyle(
                                                  color: Colors.green[600],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            )
                                          : snap['status'] == "rejected"
                                              ? Text(
                                                  'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                                  style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                )
                                              : snap['status'] == "completed"
                                                  ? Text(
                                                      'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    )
                                                  : Text(
                                                      'Booked on : ${timestamp.year}-${timestamp.month}-${timestamp.day}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          }

                          print('data');
                          return Container();
                        }),
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
