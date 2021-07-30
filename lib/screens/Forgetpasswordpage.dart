import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';

  Future userForgetPass() async {
    final valid = _formKey.currentState.validate();
    if (valid) {
      _formKey.currentState.save();

      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _userEmail)
          .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'A Reset Mail has been sent to this email account ${_userEmail.toString()}'))))
          .catchError((onError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'The account does not exists for that email ${_userEmail.toString()}')));
        print(
            'The account does not exists for that email ${_userEmail.toString()}');
      });
      //Navigator.pop(context);
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
              child: Column(
                children: [
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
                  Container(
                    padding: EdgeInsets.all(30),
                    child: Text(
                      'The Reset Email will be send to your Email Account',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Container(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                            SizedBox(height: 50),
                            Container(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () => userForgetPass(),
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
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), 
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'All Done',
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
