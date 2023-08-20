import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tango_admin/models/dish_model.dart';

import '../main_screen.dart';
import '../constants.dart';
import '../widgets/CustomFields/customDropDown.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/CustomFields/customTextField.dart';
import '../widgets/uploadImageContainer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadDish extends StatefulWidget {
  UploadDish({Key? key}) : super(key: key);

  @override
  State<UploadDish> createState() => _UploadDishState();
}

class _UploadDishState extends State<UploadDish> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dishName = TextEditingController();
  TextEditingController extraItems = TextEditingController();
  TextEditingController orderBy = TextEditingController();
  TextEditingController dishPrice = TextEditingController();
  TextEditingController dishItems = TextEditingController();
  String photourl = '';
  String? selectedCategory;

  File? image;

  Future uploadImageToFirebase(BuildContext context) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('dishImages/${image!.path}');
    UploadTask uploadTask = firebaseStorageRef.putFile(image!);
    TaskSnapshot taskSnapshot = (await uploadTask);
    String value = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      photourl = value;
    });
  }

  Future<void> _pickImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      File? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 800,
        maxHeight: 800,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: lightColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      );

      if (croppedImage != null) {
        setState(() {
          image = croppedImage;
        });

        showSnackBar(
            context, 'Image selected and cropped successfully', Colors.green);
        await uploadImageToFirebase(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "UPLOAD DISH",
            style: GoogleFonts.acme(
              textStyle: TextStyle(
                fontSize: width * .06,
                color: Colors.black, // Customize the text color
              ),
            ),
          )),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              //Pick Image with custom widget
              UploadImage(
                onTap: () => _pickImage(),
                imagePath: image,
                removeImage: () {
                  setState(() {
                    image = null;
                  });
                  Navigator.pop(context);
                },
              ),

              ///image
              SizedBox(
                height: height * 0.019,
              ),
              CustomTextField(
                text: 'Dish Name',
                textEditingController: dishName,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Dish Name';
                  }
                  return null;
                },
              ),

              CustomTextField(
                keyboardType: TextInputType.number,
                text: 'Enter Price',
                textEditingController: dishPrice,
                maxLines: 5,
                minLines: 1,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Price';
                  }
                  return null;
                },
              ),
              CustomTextField(
                keyboardType: TextInputType.number,
                text: 'Enter The Order By number',
                textEditingController: orderBy,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: height * 0.019,
              ),
              CustomDropDown(
                onChanged: (value) => setState(() {
                  selectedCategory = value;
                }),
                value: selectedCategory,
                items: [
                  'CHARCOAL SKEWERS',
                  'CHARCOAL CHICKEN',
                  'CHARCOAL ROLLS',
                  'CHARCOAL BURGERS',
                  'SALADS/DIPS/CHIPS/BREAD',
                  'FALFEEL'
                ],
                hint: 'Select the food category',
              ),
              SizedBox(
                height: height * 0.010,
              ),

              CustomTextField(
                text: 'Type all the Dish Items',
                minLines: 2,
                maxLines: 5,
                textEditingController: dishItems,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Dish Items';
                  }
                  return null;
                },
              ),
              CustomTextField(
                text: 'Type Add Items',
                minLines: 1,
                maxLines: 5,
                textEditingController: extraItems,
                validate: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Extra Items';
                  }
                  return null;
                },
              ),

              SizedBox(
                height: height * 0.025,
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate() &&
                      selectedCategory != null) {
                    showDialog(
                        context: context,
                        builder: (buildcontext) {
                          return AlertDialog(
                            title: const Text('Add Dish'),
                            content: const Text('Confirm to Add?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                child: const Text('Yes'),
                                onPressed: () async {
                                  DishModel dish = DishModel(
                                      extraItem: extraItems.text,
                                      orderBy: int.parse(orderBy.text),
                                      title: dishName.text.toUpperCase(),
                                      imageUrl: photourl,
                                      price: dishPrice.text,
                                      uploadTime: FieldValue.serverTimestamp(),
                                      category: selectedCategory.toString(),
                                      description: dishItems.text);

                                  uploadDish(dish, context);

                                  dishName.clear();
                                  dishPrice.clear();
                                  dishItems.clear();
                                  selectedCategory = null;
                                  image = null;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    if (image == null) {
                      showSnackBar(
                          context, 'Please Upload Dish Image', Colors.red);
                    } else if (selectedCategory == null) {
                      showSnackBar(
                          context, 'Please Select Category', Colors.red);
                    } else {
                      showSnackBar(
                          context, 'Fill in all the fields', Colors.red);
                    }
                  }
                },
                child: Container(
                  height: height * 0.05,
                  width: width * 0.3,
                  decoration: BoxDecoration(
                      color: lightColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Upload",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: width * .05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
