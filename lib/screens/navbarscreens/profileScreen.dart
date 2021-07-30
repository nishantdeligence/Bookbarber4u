import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var email;
  var role;
  var name;
  var password;
  var profileImage;
  @override
  void initState() {
    super.initState();
    final Future<DocumentSnapshot<Map<String, dynamic>>> _auth =
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get();

    _auth.then((value) {
      email = value.data()['userEmail'];
      name = value.data()['userName'];
      password = value.data()['userPassword'];
      role = value.data()['role'];
      profileImage = value.data()['profile'];

      setState(() {
        email = value.data()['userEmail'];
        name = value.data()['userName'];
        password = value.data()['userPassword'];
        role = value.data()['role'];
        profileImage = value.data()['profile'];
        
      });
    });
    
    //print(FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser.uid).get());
  }

  File _image;
  String url;

  Future getImage(context) async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
      print('Image Path $_image');
    });

    String fileName = basename(_image.path);

    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('user_Images')
        .child(FirebaseAuth.instance.currentUser.uid + '_' + fileName);

    UploadTask up = firebaseStorageRef.putFile(_image);

    await up.whenComplete(() {
      print('DONE_____');
      firebaseStorageRef.getDownloadURL().then((value) {
        url = value;
        //print('test--------$value');
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'profile': url});
      });
    });
   
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          

          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 35,
                    letterSpacing: 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child:
                       (profileImage != null)
                          ? Image.network(profileImage)
                          :
                            (_image != null)
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/images/logo.png',
                                  fit: BoxFit.fill,
                                ),
                    ),
                  ),
                ),
              ),
              
              buildTextField('$name', 'Name', Icons.account_circle_rounded),              
              buildTextField('$email', 'Email', Icons.email_rounded),
              buildTextField('$role', 'Role', Icons.person),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 270, left: 184),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  getImage(context);
                  //uploadPic(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      String value, String descrptionText, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3.0,
        shadowColor: Color(0xff555555),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  iconData,
                  size: 40.0,
                  color: Color(0xff555555),
                ),
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    descrptionText,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff555555);
    Path path = Path()
      ..relativeLineTo(0, 200)
      ..quadraticBezierTo(size.width / 2, 295, size.width, 200)
      ..relativeLineTo(0, -200)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
