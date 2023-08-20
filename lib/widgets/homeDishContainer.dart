import 'package:flutter/material.dart';

import '../main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DishContainer extends StatelessWidget {
  final VoidCallback onTap;
  final IconData? icon;
  final String name;
  DishContainer({Key? key, required this.name, required this.onTap, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
            top: width * .06, left: width * .05, right: width * .05),
        padding: EdgeInsets.only(
          left: width * .035,
        ),
        height: width * 0.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade500, width: 1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.solid,
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 4),
              ),
              child: CircleAvatar(
                radius: 20,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
                backgroundColor: Color(0xffB9149E),
              ),
            ),
            Text(
              textAlign: TextAlign.center,
              name,
              style: GoogleFonts.acme(
                textStyle: TextStyle(
                  fontSize: width * .04,
                  color: Colors.black, // Customize the text color
                ),
              ),
            ),
            SizedBox(width: width * .1),
          ],
        ),
      ),
    );
  }
}
