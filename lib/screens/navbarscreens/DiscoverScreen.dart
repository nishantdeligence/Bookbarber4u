import 'dart:ui';


import 'package:barber/screens/LoginPage.dart';
import 'package:barber/screens/SaloonProfile.dart';

import 'package:barber/models/category.dart';

import 'package:barber/screens/category_card.dart';
import 'package:barber/screens/customListTile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var currentUser;
  _getCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    return docRef.doc("${user.uid}").snapshots().listen((data) async {
      //print(data.data());

      currentUser = data.data();

      if (mounted) setState(() {});

      //print(currentUser['profile']);

      return currentUser;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black54,
              ),
              child: CircleAvatar(
                //backgroundImage: AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.white,

                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.logout_outlined,
                size: 25,
                color: Colors.black,
              ),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() =>
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage())));
              },
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
                visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
                trailing: Icon(
                  Icons.exit_to_app,
                  size: 25,
                  color: Colors.black,
                ),
                title: Text(
                  'Exit',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                }),
            Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  width: double.infinity,
                  height: 250.0,
                  padding: EdgeInsets.only(bottom: 50.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    image: DecorationImage(
                      image: AssetImage("assets/images/barberlogo.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBar(
                        backgroundColor: Colors.black12.withOpacity(.0),
                        elevation: 0,
                        
                        leading: Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              tooltip: MaterialLocalizations.of(context)
                                  .openAppDrawerTooltip,
                            );
                          },
                        ),
                      ),

                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Find and book best services",
                          style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      // Container(
                      //   width: double.infinity,
                      //   height: 35.0,
                      //   margin: EdgeInsets.symmetric(horizontal: 18.0),
                      //   padding: EdgeInsets.symmetric(horizontal: 15.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(12.0),
                      //     color: Colors.white.withOpacity(.9),
                      //   ),
                      //   child: TextField(
                      //     cursorColor: Colors.black,
                      //     decoration: InputDecoration(
                      //       hintText: "Search Saloon, Spa and Barber",
                      //       border: InputBorder.none,
                      //       icon: Icon(
                      //         Icons.search,
                      //         color: Colors.grey,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.0),
              
              SizedBox(height: 25.0),
              CustomListTile(title: "Top Categories"),
              SizedBox(height: 25.0),
              Container(
                width: double.infinity,
                height: 120.0,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  itemCount: categoryList.length,
                  scrollDirection: Axis.horizontal,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var category = categoryList[index];
                    return CategoryCard(category: category);
                  },
                ),
              ),
              SizedBox(height: 25.0),
              CustomListTile(title: "Best Barbershop"),
              SizedBox(height: 25.0),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Ownership')
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  return Container(
                    width: double.infinity,
                    height: 150.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                       
                        var snap = snapshot.data.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaloonPro(snap)));
                          },
                          child: Container(
                            width: 200.0,
                            margin: EdgeInsets.only(left: 18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.0),
                                    image: DecorationImage(
                                      image: snapshot.data.docs[index]
                                                  ['saloonPictures'][0] !=
                                              ""                                           ? NetworkImage(snapshot.data
                                              .docs[index]['saloonPictures'][0])
                                          : AssetImage(
                                              "assets/images/barber-shop-_151212203429-563.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 140.0,
                                      child: Text(
                                        snapshot.data.docs[index]['saloonName'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.star,
                                      size: 15.0,
                                      color: Colors.yellow,
                                    ),
                                    Text(
                                      snapshot.data.docs[index]['saloonRating'],
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot.data.docs[index]['saloonLocation'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 25.0),
              CustomListTile(title: "Best Haircutshop"),
              SizedBox(height: 25.0),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Ownership')
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(child: CircularProgressIndicator());
                  }
                  //print(snapshot.data);
                  return Container(
                    width: double.infinity,
                    height: 150.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        //print(snapshot.data.docs[index]['saloonPictures']);
                        //print(snapshot.data.docs[index]['saloonServices']);
                        List s = snapshot.data.docs[index]['saloonServices'];
                        var snap = snapshot.data.docs[index];
                        return s.contains("Haircut") == true
                            //print(snapshot.data.docs[index]['saloonName']);
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SaloonPro(snap)));
                                },
                                child: Container(
                                  width: 200.0,
                                  margin: EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          image: DecorationImage(
                                            image: snapshot.data.docs[index]
                                                        ['saloonPictures'][0] !=
                                                    ""
                                                ? NetworkImage(
                                                    snapshot.data.docs[index]
                                                        ['saloonPictures'][0])
                                                : AssetImage(
                                                    "assets/images/barber-shop-_151212203429-563.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 140.0,
                                            child: Text(
                                              snapshot.data.docs[index]
                                                  ['saloonName'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.star,
                                            size: 15.0,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ['saloonRating'],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['saloonLocation'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 25.0),
              CustomListTile(title: "Best Parlourshop"),
              SizedBox(height: 25.0),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Ownership')
                    .orderBy("timestamp", descending: true)
                    .snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Container(child: CircularProgressIndicator());
                  }

                  return Container(
                    width: double.infinity,
                    height: 150.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        //print(snapshot.data.docs[index]['saloonPictures']);
                        //print(snapshot.data.docs[index]['saloonServices']);
                        List s = snapshot.data.docs[index]['saloonServices'];
                        var snap = snapshot.data.docs[index];
                        return s.contains("Parlour") == true

                            //print(snapshot.data.docs[index]['saloonName']);
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SaloonPro(snap)));
                                },
                                child: Container(
                                  width: 200.0,
                                  margin: EdgeInsets.only(left: 18.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          image: DecorationImage(
                                            image: snapshot.data.docs[index]
                                                        ['saloonPictures'][0] !=
                                                    ""
                                                ? NetworkImage(
                                                    snapshot.data.docs[index]
                                                        ['saloonPictures'][0])
                                                : AssetImage(
                                                    "assets/images/barber-shop-_151212203429-563.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 140.0,
                                            child: Text(
                                              snapshot.data.docs[index]
                                                  ['saloonName'],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.star,
                                            size: 15.0,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            snapshot.data.docs[index]
                                                ['saloonRating'],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data.docs[index]
                                            ['saloonLocation'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            :

                            //print(s.contains("Shampoo"));
                            Container();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
