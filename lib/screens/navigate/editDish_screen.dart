import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../../main_screen.dart';
import '../../widgets/CustomFields/customDropDown.dart';
import '../../widgets/CustomFields/customTextField.dart';
import '../../widgets/constantAppBar.dart';
import '../../widgets/uploadImageContainer.dart';

class EditDish extends StatefulWidget {
  final DocumentSnapshot data;
  EditDish({Key? key, required this.data}) : super(key: key);

  @override
  State<EditDish> createState() => _EditDishState();
}

class _EditDishState extends State<EditDish> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dishName = TextEditingController();
  TextEditingController dishPrice = TextEditingController();
  TextEditingController dishItems = TextEditingController();
  TextEditingController orderBy = TextEditingController();
  TextEditingController extraItems = TextEditingController();
  String? photourl;
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
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategory = widget.data['category'];
    dishName = TextEditingController(text: widget.data['title']);
    dishPrice = TextEditingController(text: widget.data['price'].toString());
    dishItems = TextEditingController(text: widget.data['description']);
    extraItems = TextEditingController(text: 'extra');
    orderBy = TextEditingController(text: 'order');
  }

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ConstantAppBar(title: 'Edit Dish'),
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
              image == null
                  ? Container(
                      height: width * .6,
                      width: width * .7,
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          InteractiveViewer(
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.data['imageUrl'],
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) {
                                  if (downloadProgress.totalSize != null &&
                                      downloadProgress.downloaded != null) {
                                    double progress =
                                        downloadProgress.downloaded /
                                            downloadProgress.totalSize!;
                                    return Center(
                                      child: CircularProgressIndicator(
                                          value: progress),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                                errorWidget: (context, url, error) =>
                                    Center(child: Text("Network OFF")),
                              ),
                            ),
                          ),
                          Positioned(
                            right: width * 0.0,
                            top: 0,
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (buildContext) {
                                      {
                                        return AlertDialog(
                                          title: const Text(' Change Image'),
                                          content: const Text(
                                              'Do you want to Change Image?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  _pickImage();
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ],
                                        );
                                      }
                                    });
                              },
                              color: lightColor,
                              icon: Icon(
                                Icons.change_circle,
                                size: width * 0.15,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : UploadImage(
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
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                        context: context,
                        builder: (buildcontext) {
                          return StatefulBuilder(builder: (context, setState) {
                            return loading
                                ? AlertDialog(
                                    title: Text("Updating Please Wait..."),
                                    content: LinearProgressIndicator())
                                : AlertDialog(
                                    title: const Text('Update Dish'),
                                    content: const Text('Confirm to Update?'),
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
                                          setState(() {
                                            loading = true;
                                          });
                                          image != null
                                              ? await uploadImageToFirebase(
                                                  context)
                                              : false;
                                          await FirebaseFirestore.instance
                                              .collection('dishes')
                                              .doc(widget.data.id)
                                              .update({
                                            "title":
                                                dishName.text.toUpperCase(),
                                            "imageUrl": image == null
                                                ? widget.data['imageUrl']
                                                : photourl,
                                            "category":
                                                selectedCategory.toString(),
                                            "price": dishPrice.text,
                                            "editedTime":
                                                FieldValue.serverTimestamp(),
                                            "description": dishItems.text,
                                            "extraItem": extraItems.text,
                                            "orderBy": int.parse(orderBy.text),
                                          });
                                          // uploadDish(dish, context);
                                          showSnackBar(
                                              context,
                                              "Dish Updated Successfully",
                                              Colors.green);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          dishName.clear();
                                          dishPrice.clear();
                                          dishItems.clear();
                                          selectedCategory = null;
                                          image = null;
                                          loading = false;
                                        },
                                      ),
                                    ],
                                  );
                          });
                        });
                  } else {
                    showSnackBar(context, 'Fill in all the fields', Colors.red);
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
