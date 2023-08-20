import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main_screen.dart';

class UploadImage extends StatelessWidget {
  final File? imagePath;
  final void Function()? onTap;
  final void Function()? removeImage;
  const UploadImage({Key? key, this.imagePath, this.onTap, this.removeImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      imagePath == null
          ? InkWell(
              onTap: onTap,
              child: Container(
                width: width * 0.5,
                height: width * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        // color: primaryColor,
                        size: width * 0.1),
                    Text(
                      'Upload Image',
                      style: GoogleFonts.poppins(fontSize: height * 0.019),
                    ),
                  ],
                )),
              ),
            )
          : Container(
              width: width * 0.5,
              height: width * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(imagePath!), fit: BoxFit.fill),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
      imagePath != null
          ? Positioned(
              left: width * 0.43,
              bottom: width * 0.45,
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (buildContext) {
                        {
                          return AlertDialog(
                            title: const Text(' Remove Image'),
                            content:
                                const Text('Do you want to  Remove Image?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.black),
                                  )),
                              TextButton(
                                  onPressed: removeImage,
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ],
                          );
                        }
                      });
                },
                color: Colors.black,
                icon: Icon(
                  Icons.cancel,
                  size: width * 0.1,
                ),
              ),
            )
          : SizedBox(),
    ]);
  }
}

class ShowNetworkImage extends StatelessWidget {
  final String imageUrl;
  final void Function()? onTap;
  const ShowNetworkImage({Key? key, required this.imageUrl, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: width * 0.5,
          height: width * 0.5,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl!), fit: BoxFit.fill),
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        SizedBox(
          height: width * .05,
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (buildContext) {
                  {
                    return AlertDialog(
                      title: const Text(' Update Image'),
                      content: const Text('Confirm to Change?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            )),
                        TextButton(
                          onPressed: onTap,
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  }
                });
          },
          // color: Colors.black,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Change Image'),
              Icon(
                Icons.change_circle,
                size: width * 0.08,
              ),
            ],
          ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(8),
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.black87,
            ), // Change color here
          ),
        ),
      ],
    );
  }
}
