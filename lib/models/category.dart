import 'package:flutter/material.dart';

class Category {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  Category({this.icon, this.subtitle, this.title, this.color});
}

List<Category> categoryList = [
  Category(
    icon: "assets/images/logo.png",
    title: "Hairdye",
    subtitle: "5",
    color: Colors.lightBlue,
  ),
  Category(
    icon: "assets/images/logo.png",
    title: "Haircut",
    subtitle: "59",
    color: Colors.yellow,
  ),
  Category(
    icon: "assets/images/palor.png",
    title: "Parlour",
    subtitle: "23",
    color: Colors.green,
  ),
  Category(
    icon: "assets/images/logo.png",
    title: "Shampoo",
    subtitle: "55",
    color: Colors.pink,
  ),
  Category(
    icon: "assets/images/spa.png",
    title: "Spa",
    subtitle: "15",
    color: Colors.purple,
  ),
  Category(
    icon: "assets/images/logo.png",
    title: "Massage",
    subtitle: "5",
    color: Colors.lightBlue,
  ),
  Category(
    icon: "assets/images/logo.png",
    title: "Shaving",
    subtitle: "59",
    color: Colors.yellow,
  ),
  Category(
    icon: "assets/images/palor.png",
    title: "Facial",
    subtitle: "23",
    color: Colors.green,
  ),
];
