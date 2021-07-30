import 'package:barber/models/chat.dart';
import 'package:barber/models/chat_users.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        text: 'Ron',
        secondaryText: 'Hello there ?',
        image: 'assets/images/bestmen.jpg',
        time: 'Now'),
    ChatUsers(
        text: 'Ron',
        secondaryText: 'Want to rescehudle my appoitment',
        image: 'assets/images/bestmen2.jpg',
        time: 'yestarday'),
    ChatUsers(
        text: 'John',
        secondaryText: 'Hi, are you available ?',
        image: 'assets/images/bestmen3.jpg',
        time: '12 Mar'),
    ChatUsers(
        text: 'Rock',
        secondaryText: 'will come soon',
        image: 'assets/images/bestmen5.jpg',
        time: '1 Mar'),
    ChatUsers(
        text: 'Kane',
        secondaryText: 'confirm your timing',
        image: 'assets/images/bestmen.jpg',
        time: '30 Feb'),
    ChatUsers(
        text: 'Batista',
        secondaryText: 'your appoitnment is cancled',
        image: 'assets/images/bestmen2.jpg',
        time: '12 feb'),
    ChatUsers(
        text: 'Michale',
        secondaryText: 'is your visit is conform today ?',
        image: 'assets/images/bestmen2.jpg',
        time: '12 feb'),
    ChatUsers(
        text: 'Traver',
        secondaryText: 'your appoitnment is cancled',
        image: 'assets/images/24.png',
        time: '12 feb'),
    ChatUsers(
        text: 'Freddy',
        secondaryText: 'Please come on time',
        image: 'assets/images/bestmen.jpg',
        time: '12 feb'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Chats",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.indigo[50],
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.indigo,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Add New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: chatUsers.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatUsersList(
                      text: chatUsers[index].text,
                      secondaryText: chatUsers[index].secondaryText,
                      image: chatUsers[index].image,
                      time: chatUsers[index].time,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
