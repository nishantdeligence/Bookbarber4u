import 'package:barber/screens/Dashbord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAlertTwo extends StatefulWidget {
  final String saloonId;
  final String saloonService;

  CustomAlertTwo(this.saloonId, this.saloonService);

  @override
  _CustomAlertTwoState createState() => _CustomAlertTwoState();
}

class _CustomAlertTwoState extends State<CustomAlertTwo> {
  DateTime dateTime = DateTime.now();

  _getAppointment(DateTime getDateTime) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) async {
      if ('${widget.saloonId}' == '${value.data()['userId']}') {
        print("User can't select their own saloon for services.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User can't select their own saloon for services."),
            action: SnackBarAction(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Dashboard()));
                },
                label: 'Change saloon')));
      } else {
        await FirebaseFirestore.instance.collection('Appointments').add({
          'sendedFor': '${widget.saloonId}',
          'requestedService': '${widget.saloonService}',
          'requestedDateAndTime': '$getDateTime',
          'requestedBy': '${value.data()['userId']}',
          'requestAcceptedStatus': 'null',
          'timestamp': DateTime.now(),
        }).then((value2) async {
          DocumentSnapshot docSnap = await value2.get();
          var appointmentDocId = docSnap.reference.id;
          print(appointmentDocId);
          await FirebaseFirestore.instance
              .collection('Notifications')
              .doc(appointmentDocId)
              .set({
            'requestedBy': '${value.data()['userId']}',
            'sendedFor': '${widget.saloonId}',
            'notificationId': '$appointmentDocId',
            'status': 'null',
            'timestamp': DateTime.now(),
          }).then(
            (value3) => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Dashboard())),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0, left: 20.0),
        child: Column(
          children: [
            Text(
              "Please Select Date and Time",
              style: TextStyle(fontSize: 22.0),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: CupertinoDatePicker(
                use24hFormat: true,
                initialDateTime: dateTime,
                minimumDate: dateTime,
                onDateTimeChanged: (datenowTime) {
                  setState(() {
                    dateTime = datenowTime;
                  });
                },
              ),
            ),
            ElevatedButton(
                child: Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo[200],
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text("The Date and time you selected is :- "),
                      content: Text(
                        'Date: ${dateTime.day}/${dateTime.month}/${dateTime.year}\nTime: ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              DateTime getDateTime = dateTime;

                              _getAppointment(getDateTime);
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                      elevation: 30.0,
                      backgroundColor: Colors.indigo[100],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
