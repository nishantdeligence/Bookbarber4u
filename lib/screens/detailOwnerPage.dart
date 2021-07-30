import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'Dashbord.dart';

class DetailOwnerPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  DetailOwnerPage(this.userData);
  @override
  _DetailOwnerPageState createState() => _DetailOwnerPageState();
}

class _DetailOwnerPageState extends State<DetailOwnerPage> {
  Map<String, dynamic> saloonData = {};
  final _formKey = GlobalKey<FormState>();
  var _saloonName = '';
  var _saloonDescription = '';
  var _saloonLocation = '';
  var _saloonOther = '';
  var _saloonOpeningTime;
  var _saloonClosingTime;
  var _saloonServices = [];
  var _saloonDays = [];
  TextEditingController timeOpen = TextEditingController();
  TextEditingController timeClose = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saloonServices = [];
    _saloonDays = [];
  }

  Future details() async {
    final valid = _formKey.currentState.validate();
    if (valid) {
      _formKey.currentState.save();

      // Map _saloonDaysmap = {for (var item in _saloonDays) '$item': '$item'};
      // Map _saloonServicesmap = {
      //   for (var item in _saloonServices) '$item': '$item'
      // };

      saloonData.addAll({
        'saloonName': _saloonName.trim(),
        'saloonDescription': _saloonDescription.trim(),
        'saloonLocation': _saloonLocation.trim(),
        'saloonDays': _saloonDays,
        'saloonOpeningTime': _saloonOpeningTime.format(context).trim(),
        'saloonClosingTime': _saloonClosingTime.format(context).trim(),
        'saloonId': FirebaseAuth.instance.currentUser.uid,
        'saloonOther': _saloonOther.trim(),
        'saloonServices': _saloonServices,
        'saloonPictures': 'null',
        'saloonRating': '0',
        'timestamp': DateTime.now(),
      });
      await FirebaseFirestore.instance
          .collection('Ownership')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set(saloonData);          
          

      print('saloonData ---- $saloonData');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
          child: Column(
            children: [
              Text(
                'You Entered As A Saloon Owner',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Please fill these details',
                style: TextStyle(fontSize: 20.0),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: TextFormField(
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              hintText: 'eg. Haircut store',
                              helperText: 'Saloon Name',
                              labelStyle: TextStyle(color: Colors.black),
                              icon: Icon(
                                Icons.account_circle_rounded,
                                color: Colors.black,
                              ),
                              border: InputBorder.none),
                          onChanged: (value) {
                            _saloonName = value;
                          },
                          validator: (value) {
                            return (value.isEmpty)
                                ? 'Please enter a saloon name'
                                : null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: TextFormField(
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              hintText:
                                  'eg. This store is established in late 1950s. we are providing saloon and spa services',
                              helperText: 'Saloon Description',
                              labelStyle: TextStyle(color: Colors.black),
                              icon: Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              border: InputBorder.none),
                          onChanged: (value) {
                            _saloonDescription = value;
                          },
                          validator: (value) {
                            return (value.isEmpty)
                                ? 'Please enter a saloon description'
                                : null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        child: TextFormField(
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              hintText:
                                  'eg. 106 & 107, 1st Floor, District Center, Janakpuri, New Delhi 110058',
                              helperText: 'Saloon Address',
                              labelStyle: TextStyle(color: Colors.black),
                              icon: Icon(
                                Icons.location_on_rounded,
                                color: Colors.black,
                              ),
                              border: InputBorder.none),
                          onChanged: (value) {
                            _saloonLocation = value;
                          },
                          validator: (value) {
                            return (value.isEmpty)
                                ? 'Please enter a saloon address'
                                : null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: MultiSelectFormField(
                            autovalidate: false,
                            chipBackGroundColor: Colors.blue,
                            chipLabelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            dialogTextStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                            checkBoxActiveColor: Colors.blue,
                            checkBoxCheckColor: Colors.white,
                            dialogShapeBorder: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            title: Text(
                              "Select Days",
                              style: TextStyle(fontSize: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.length == 0) {
                                return 'Please select one or more days';
                              }
                              return null;
                            },
                            dataSource: [
                              {
                                "display": "Monday",
                                "value": "Monday",
                              },
                              {
                                "display": "Tuesday",
                                "value": "Tuesday",
                              },
                              {
                                "display": "Wednesday",
                                "value": "Wednesday",
                              },
                              {
                                "display": "Thusday",
                                "value": "Thusday",
                              },
                              {
                                "display": "Friday",
                                "value": "Friday",
                              },
                              {
                                "display": "Saturday",
                                "value": "Saturday",
                              },
                              {
                                "display": "Sunday",
                                "value": "Sunday",
                              },
                            ],
                            textField: 'display',
                            valueField: 'value',
                            okButtonLabel: 'OK',
                            cancelButtonLabel: 'CANCEL',
                            hintWidget: Text('Please choose days'),
                            initialValue: _saloonDays,
                            onSaved: (value) {
                              if (value == null) return;
                              setState(() {
                                _saloonDays = value;
                                //print(_saloonDays);
                              });
                            }),
                      ),

                      Container(
                        child: TextFormField(
                          controller: timeOpen,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            hintText: 'eg. 12:00',
                            helperText: 'Saloon Opening Timing',
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              Icons.access_time_filled,
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                          ),
                          onTap: () async {
                            TimeOfDay time = TimeOfDay.now();
                            
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            TimeOfDay picked = await showTimePicker(
                                context: context, initialTime: time);
                            if (picked != null && picked != time) {
                              timeOpen.text = picked.toString();
                              setState(() {
                                time = picked;
                                _saloonOpeningTime = time;
                              });
                              Text('Time ${time.hour} : ${time.minute}');
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a saloon opening';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),

                      Container(
                        child: TextFormField(
                          controller: timeClose,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            hintText: 'eg. 22:00',
                            helperText: 'Saloon Closing Timing',
                            labelStyle: TextStyle(color: Colors.black),
                            icon: Icon(
                              Icons.access_time_filled,
                              color: Colors.black,
                            ),
                            border: InputBorder.none,
                          ),
                          onTap: () async {
                            TimeOfDay time = TimeOfDay.now();
                            
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            TimeOfDay picked = await showTimePicker(
                                context: context, initialTime: time);
                            if (picked != null && picked != time) {
                              timeClose.text = picked.toString();
                              setState(() {
                                time = picked;
                                _saloonClosingTime = time;
                              });
                              Text('Time ${time.hour} : ${time.minute}');
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a saloon closing';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: TextFormField(
                          maxLines: 4,
                          minLines: 1,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10.0),
                              hintText:
                                  'eg. this is all about any other information you want to tell to you customer',
                              helperText: 'Any Other Information',
                              labelStyle: TextStyle(color: Colors.black),
                              icon: Icon(
                                Icons.info_rounded,
                                color: Colors.black,
                              ),
                              border: InputBorder.none),
                          onChanged: (value) {
                            _saloonOther = value;
                          },
                          validator: (value) {
                            return (value.isEmpty)
                                ? 'Please enter any other information'
                                : null;
                          },
                        ),
                      ),
                     
                      Container(
                       
                        padding: EdgeInsets.all(16),
                        child: MultiSelectFormField(
                          autovalidate: false,
                          chipBackGroundColor: Colors.blue,
                          chipLabelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          dialogTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          checkBoxActiveColor: Colors.blue,
                          checkBoxCheckColor: Colors.white,
                          dialogShapeBorder: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          title: Text(
                            "Saloon's Services",
                            style: TextStyle(fontSize: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.length == 0) {
                              return 'Please select one or more saloon services';
                            }
                            return null;
                          },
                          dataSource: [
                            {
                              "display": "Haircut",
                              "value": "Haircut",
                            },
                            {
                              "display": "Parlour",
                              "value": "Parlour",
                            },
                            {
                              "display": "Shampoo",
                              "value": "Shampoo",
                            },
                            {
                              "display": "Spa",
                              "value": "Spa",
                            },
                            {
                              "display": "Hairdye",
                              "value": "Hairdye",
                            },
                            {
                              "display": "Massage",
                              "value": "Massage",
                            },
                            {
                              "display": "Shaving",
                              "value": "Shaving",
                            },
                            {
                              "display": "Facial",
                              "value": "Facial",
                            },
                          ],
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          hintWidget: Text('Please choose saloon services'),
                          initialValue: _saloonServices,
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              _saloonServices = value;
                              //print(_saloonServices);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 25.0),
              Container(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    details();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    padding: const EdgeInsets.all(0.0),
                  ),
                  child: Ink(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                          minWidth: 88.0,
                          minHeight: 36.0), 
                      alignment: Alignment.center,
                      child: const Text(
                        'All Set ',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
