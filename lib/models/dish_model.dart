import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tango_admin/constants.dart';

class DishModel {
  String title;
  String price;
  String category;
  String imageUrl;
  String description;
  String extraItem;
  int orderBy;
  FieldValue uploadTime;

  DishModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.category,
      required this.price,
      required this.uploadTime,
      required this.orderBy,
      required this.extraItem});

  Map<String, dynamic> toMap() {
    return {
      'title': title.toUpperCase(),
      'price': price,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'uploadTime': uploadTime,
      'uploadTime': uploadTime,
      'uploadTime': uploadTime,
    };
  }

  //Just learn thissss
  factory DishModel.fromMap(Map<String, dynamic> map) {
    return DishModel(
        title: map['title'],
        price: map['price'],
        category: map['category'],
        imageUrl: map['imageUrl'],
        uploadTime: map['uploadTime'],
        description: map['description'],
        orderBy: 1,
        extraItem: '');
  }
}

void uploadDish(DishModel dish, context) async {
  try {
    showSnackBar(context, 'Dish Uploaded Successfully', Colors.green);
    Navigator.pop(context);
    Map<String, dynamic> dishData = dish.toMap();
    // Add the data to Firestore collection
    await FirebaseFirestore.instance.collection('dishes').add(dishData);
  } catch (e) {
    print('Error adding dish to Firestore: $e');
  }
}
