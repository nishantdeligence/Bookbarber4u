import 'package:barber/screens/OwnerOrService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> userData = {};
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';

  Future userSignUp() async {
    final valid = _formKey.currentState.validate();

    if (valid) {
      _formKey.currentState.save();

      try {
        await Firebase.initializeApp();
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _userEmail.trim(),
              password: _userPassword.trim(),
            )
            .then((value) => print('The User Acount has been created.'));

        String uid = FirebaseAuth.instance.currentUser.uid;
        userData.addAll({
          'userName': _userName.trim(),
          'userEmail': _userEmail.trim(),
          'userPassword': _userPassword.trim(),
          'userId': uid,
          'profile': '',
          'timestamp': DateTime.now(),
        });

        print(userData);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OwnerOrService(userData)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The password provided is too weak.'),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.'),
          ));
          print('The account already exists for that email.');
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The email address is not valid'),
          ));
          print('The email address is not valid.');
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Column(children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/barber.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.width * 0.1,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(Icons.verified_user,
                                  color: Colors.black),
                              hintText: "Enter Your Name",
                            ),
                            onSaved: (value) {
                              _userName = value;
                            },
                            validator: (value) {
                              return (value.isEmpty || value.length < 2)
                                  ? "Please enter at least 2 characters"
                                  : null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,                         
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.black),
                              hintText: "Enter Your Email",
                            ),
                            onChanged: (value) {
                              _userEmail = value;
                            },
                            validator: (value) {
                              return (value.isEmpty || !value.contains('@'))
                                  ? 'Please enter a valid email address'
                                  : null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          child: TextFormField(
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(top: 14.0),
                                prefixIcon:
                                    Icon(Icons.lock, color: Colors.black),
                                hintText: "Enter Your Password",
                              ),
                              onChanged: (value) {
                                _userPassword = value;
                              },
                              validator: (value) {
                                return (value.isEmpty || value.length < 6)
                                    ? "Please enter at least 6 characters"
                                    : null;
                              }),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => userSignUp(),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 88.0,
                                    minHeight:
                                        36.0), 
                                alignment: Alignment.center,
                                child: const Text(
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
