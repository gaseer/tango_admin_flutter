import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tango_admin/constants.dart';
import 'package:tango_admin/screens/home_screen.dart';
import 'package:tango_admin/screens/navigate/editDish_screen.dart';

import '../../main_screen.dart';
import '../../widgets/constantAppBar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/dish_model.dart';

class MenuScreen extends StatelessWidget {
  final String? category;

  const MenuScreen({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text("ALL DISH ITEMS",
              style: GoogleFonts.acme(
                textStyle: TextStyle(
                  fontSize: width * .05,
                  color: Colors.black, // Customize the text color
                ),
              ))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('dishes')
            .orderBy('uploadTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: width * .03,
              crossAxisSpacing: width * .03,
              childAspectRatio:
                  0.8, // Adjust this value as needed for the desired aspect ratio
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final data = documents[index];
              String documentId = documents[index].id;
              return InkWell(
                onTap: () => navigateToScreen(context, EditDish(data: data)),
                child: Card(
                  // margin: EdgeInsets.only(left: width * .05),
                  color: Colors.white,
                  elevation: 5.0,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    // side: BorderSide(color: Colors.blueGrey, width: 3.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: width * .4,
                        width: double.infinity,
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: data['imageUrl'].toString(),
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
                      ),
                      SizedBox(height: width * .01),
                      Text(data['title'].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.acme(
                            textStyle: TextStyle(
                              fontSize: width * .04,
                              color: Colors.black, // Customize the text color
                            ),
                          )),
                      SizedBox(height: width * .025),
                      Expanded(
                        child: Text('  \$${data['price']}',
                            style: GoogleFonts.acme(
                              textStyle: TextStyle(
                                fontSize: width * .055,
                                color: Colors.black,
                                // Customize the text color
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void navigateToEditImage(
      BuildContext context, String documentId, Map<String, dynamic> image) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }
}
