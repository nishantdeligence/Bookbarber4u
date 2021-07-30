import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart';

import 'package:barber/models/image_darta.dart';
import 'package:barber/screens/customAlertTwo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:image_picker/image_picker.dart';

class Saloon extends StatefulWidget {
  var cat; 
  Saloon(this.cat);

  @override
  _SaloonState createState() => _SaloonState();
}

class _SaloonState extends State<Saloon> {
  @override
  Widget build(BuildContext context) {
    var titleOf = widget.cat.title;
    return Scaffold(
      appBar: AppBar(
        title: Text('$titleOf Shops'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Ownership')
            .where('saloonServices', arrayContains: '$titleOf')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Data Not Found'));
          }
          if (snapshot.hasData) {
            QuerySnapshot s = snapshot.data;
            if (s.docs.isEmpty == true) {
              return Center(child: Text('Data Not Found'));
            }
          }
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
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
                    margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
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
                                          ['saloonPictures'] !=
                                      "null"
                                  ? NetworkImage(snapshot.data.docs[index]
                                      ['saloonPictures'])
                                  : AssetImage(
                                      "assets/images/barber-shop-_151212203429-563.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                          child: Row(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 8.0, left: 8.0, top: 4.0),
                          child: Text(
                            snapshot.data.docs[index]['saloonLocation'],
                            overflow: TextOverflow.ellipsis,
                          ),
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
    );
  }
}

class SaloonPro extends StatefulWidget {
  var snap;
  SaloonPro(this.snap);
  @override
  _SaloonProState createState() => _SaloonProState();
}

class _SaloonProState extends State<SaloonPro> {
  File _image;
  String url;

  Future getImage(context) async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
      print('Image Path $_image');
    });

    String fileName = basename(_image.path);

    // Reference firebaseStorageRef = FirebaseStorage.instance
    //     .ref()
    //     .child('user_Images')
    //     .child(FirebaseAuth.instance.currentUser.uid + '_' + fileName);

    //UploadTask up = firebaseStorageRef.putFile(_image);

    // await up.whenComplete(() {
    //   print('DONE_____');
    //   firebaseStorageRef.getDownloadURL().then((value) {
    //     url = value;
    //     //print('test--------$value');
    //     FirebaseFirestore.instance
    //         .collection('Users')
    //         .doc(FirebaseAuth.instance.currentUser.uid)
    //         .update({'profile': url});
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    _getreviews();
  }

  _getreviews() {
    FirebaseFirestore.instance
        .collection('Reviews')
        .snapshots()
        .listen((value) {
      value.docs.forEach((element) {
        //print(element.data()['sendedFor']);
        if (element.data()['sendedFor'] == widget.snap['saloonId']) {
          print('yes');
        } else {
          print('no');
        }
      });
    });
    //print(widget.snap['saloonId']);
  }

  var userdatareq;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: Container(child: Center(child: Text(widget.snap['saloonName'])),),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bestmen8.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.photo_album,
                          color: Colors.black,
                        ),
                        child: Text("Gallery",
                            style: TextStyle(color: Colors.black)),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.design_services,
                          color: Colors.black,
                        ),
                        child: Text("Services",
                            style: TextStyle(color: Colors.black)),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.info,
                          color: Colors.black,
                        ),
                        child: Text("About",
                            style: TextStyle(color: Colors.black)),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.rate_review,
                          color: Colors.black,
                        ),
                        child: Text("Reviews",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      children: [
// Gallery
                        Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //IconButton(icon: Icon(Icons.ac_unit), onPressed: () {  },color: Colors.amber,),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SingleImageUpload()));
                                    //getImage(context);
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (_) => AlertDialog(
                                    //     title: Text('Add Pictures For saloon'),
                                    //     content: Container(),
                                    //     actions: [
                                    //       Row(
                                    //           mainAxisAlignment:
                                    //               MainAxisAlignment.center,
                                    //           children: [
                                    //             TextButton(
                                    //                 onPressed: () {},
                                    //                 child: Text('ADD'))
                                    //           ]),
                                    //       TextButton(
                                    //           onPressed: () =>
                                    //               Navigator.of(context).pop(),
                                    //           child: Text('Back')),
                                    //     ],
                                    //   ),
                                    // );
                                  },
                                  child: Text('Add Media'),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: StaggeredGridView.countBuilder(
                                    crossAxisCount: 3,
                                    itemCount: imageList.length,
                                    itemBuilder: (context, index) =>
                                        ImageCard(imageData: imageList[index]),
                                    staggeredTileBuilder: (index) =>
                                        StaggeredTile.count(
                                            (index % 7 == 0) ? 2 : 1,
                                            (index % 7 == 0) ? 2 : 1),
                                    mainAxisSpacing: 8.0,
                                    crossAxisSpacing: 8.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
// Services
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Card(
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.snap['saloonServices']
                                      .map<Widget>(
                                        (items) =>
                                            //print(items);
                                            //Text(items),
                                            Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/palor.png',
                                                  height: 100,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Text(items,
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                            ButtonBar(
                                              children: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.indigo,
                                                  ),
                                                  onPressed: () {
                                                    var saloonId =
                                                        widget.snap['saloonId'];
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        return CustomAlertTwo(
                                                            '$saloonId',
                                                            '$items');
                                                      },
                                                    );
                                                  },
                                                  child: Text('Book Now'),
                                                )
                                              ],
                                            ),
                                            Divider(
                                              height: 10.0,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
// About
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Saloon Name :  '),
                                      Text(widget.snap["saloonName"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Saloon Location :  '),
                                      Text(widget.snap["saloonLocation"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Saloon Opening Time :  '),
                                      Text(widget.snap["saloonOpeningTime"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Saloon Closing Time :  '),
                                      Text(widget.snap["saloonClosingTime"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Wrap(
                                    children: [
                                      Text('Saloon Opening Days :  '),

                                      Row(
                                        children: widget.snap["saloonDays"]
                                            .map<Widget>(
                                              (items) => Text('$items ,'),
                                            )
                                            .toList(),
                                      ),
                                      //Text(widget.snap["saloonDays"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Wrap(
                                    children: [
                                      Text('Saloon Services :  '),
                                      Row(
                                        children: widget.snap["saloonServices"]
                                            .map<Widget>(
                                              (items) => Text('$items ,'),
                                            )
                                            .toList(),
                                      ),
                                      //Text(widget.snap["saloonName"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Saloon Descriptions :  '),
                                      Text(widget.snap["saloonDescription"]),
                                    ],
                                  ),
                                  Divider(
                                    height: 20.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Saloon Others :  '),
                                      Text(widget.snap["saloonOther"]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
// Reviews
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Reviews')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }

                              return ListView.builder(
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  var snapSendedFor =
                                      snapshot.data.docs[index]['sendedFor'];
                                  var snapRequestedBy =
                                      snapshot.data.docs[index]['requestedBy'];
                                  var saloonId = widget.snap['saloonId'];
                                  print(saloonId);

                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(snapRequestedBy)
                                      .snapshots()
                                      .listen((data) {
                                    print('test---4');
                                    userdatareq = data.data();
                                    //print(userdatareq['userName']);
                                  });

                                  if (saloonId == snapSendedFor) {
                                    return Card(
                                      color: Colors.blue,
                                      child: Container(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(18.0),
                                              child: Wrap(children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          '${snapshot.data.docs[index]['userReview']}'),
                                                    ),
                                                  ],
                                                ),
                                               
                                                Container(
                                                  margin: EdgeInsets.only(top: 10.0),
                                                  child: Row(                                                    
                                                    children: [
                                                      Text('by : '),
                                                      SizedBox(
                                                        width: 100.0,
                                                        child: Text(
                                                          '${userdatareq['userName']}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text('rating : '),
                                                      Icon(
                                                        Icons.star,
                                                        size: 15.0,
                                                        color: Colors.yellow,
                                                      ),
                                                      Text(
                                                        '${snapshot.data.docs[index]['userRating']}',
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

                                  return Container();
                                },
                              );

                              
                            }),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class ImageCard extends StatelessWidget {
  ImageCard({this.imageData});

  final ImageData imageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.asset(imageData.imageasset, fit: BoxFit.cover),
    );
  }
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  File imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}

class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  List<Object> images = [];
  Future<File> _imageFile;
  @override
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('Add media'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  File imageF;
  Future _onAddImageClick(int index) async {
    var imageF = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(imageF.path) as Future<File>;
      print('test--------$_imageFile');
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
    _imageFile.then((file) async {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }
}
