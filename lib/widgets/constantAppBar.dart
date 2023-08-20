import 'package:flutter/material.dart';
import 'package:tango_admin/constants.dart';

import '../main_screen.dart';
import '../screens/home_screen.dart';

class ConstantAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ConstantAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 2,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: width * .06),
      ),
      leading: IconButton(
          icon: Icon(
            size: 30,
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (buildContext) {
                  {
                    return AlertDialog(
                      title: const Text('Exit'),
                      content: const Text('Do you want to Exit?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    );
                  }
                });
          }),
    );
  }
}
