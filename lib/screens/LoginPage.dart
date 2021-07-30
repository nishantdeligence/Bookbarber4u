import 'package:barber/screens/Dashbord.dart';
import 'package:barber/screens/Forgetpasswordpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'SignUPpage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, dynamic> userData = {};
  final _formKey = GlobalKey<FormState>();
  var _userPassword = '';
  var _userEmail = '';

  Future userLogin() async {
    final valid = _formKey.currentState.validate();

    if (valid) {
      _formKey.currentState.save();

      try {
        await Firebase.initializeApp();
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _userEmail.trim(),
              password: _userPassword.trim(),
            )
            .then((value) => print('The User Acount has been LoggedIn.'));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Dashboard()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The password is invalid for the given email.'),
          ));
          print('The password is invalid for the given email.');
        } else if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account does not exists for that email.'),
          ));
          print('The account does not exists for that email.');
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The email address is not valid.'),
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
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 10,
                        width: 110,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 130,
                        width: 70,
                        height: 160,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text(
                              "BookBarber4U",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Container(
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
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
                                keyboardType: TextInputType.emailAddress,
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
                                  return (value.isEmpty)
                                      ? 'Please enter a valid password'
                                      : null;
                                },
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () => userLogin(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
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
                                        minWidth: 88.0, minHeight: 36.0),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Login',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.only(right: 0.0),
                                ),
                                child: Text(
                                  'Forget Password ?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 60.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(0, 2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/face.png'))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 60.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white,
                                              offset: Offset(0, 2),
                                              blurRadius: 6.0,
                                            ),
                                          ],
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/google.jpg'))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                                onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SignUpScreen();
                                        },
                                      ),
                                    ),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Dont\'t have an Account ?',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      TextSpan(
                                        text: '  Sign Up',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))
                          ]),
                        ),
                      ),
                    ],
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
