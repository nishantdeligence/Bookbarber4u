import 'package:barber/screens/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'screens/LoginPage.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset('assets/images/logo.png'),
          title: 'BookBarber4U',
          body: 'Shaving  |  Hair Cutting |  Facial',
          footer: Text("Being a barber is about taking care of the people.")),
      PageViewModel(
          image: Image.asset('assets/images/Capture.png'),
          title: 'Why do we use it?',
          body:
              'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
          footer: Text("BookBarber4U")),
      PageViewModel(
          image: Image.asset('assets/images/bg.png'),
          title: 'Contarary to popular',
          body:
              'It is a long established fact that a reader will be distracted by the readable content of a page. ',
          footer: Text("BookBarber4U")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookBarber4U',
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) => Scaffold(
          body: IntroductionScreen(
            done: Icon(Icons.done),
            showSkipButton: true,
            animationDuration: 700,
            skip: Text("Skip"),
            pages: getPages(),
            globalBackgroundColor: Colors.white,
            dotsDecorator: DotsDecorator(
                color: Colors.black, shape: RoundedRectangleBorder()),
            onDone: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ),
      ),
      theme: ThemeData(
        primaryColor: Color(0xFF181818),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
