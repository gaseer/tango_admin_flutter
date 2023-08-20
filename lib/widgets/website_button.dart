import 'package:flutter/material.dart';
import 'package:tango_admin/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WebsiteButton extends StatelessWidget {
  final String websiteUrl;

  const WebsiteButton({required this.websiteUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: width * .06, left: width * .25, right: width * .25),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(8),
          backgroundColor: MaterialStateProperty.all<Color>(
            lightColor, // Set the background color to blue grey
          ),
        ),
        onPressed: () {
          launchURL(websiteUrl);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.ads_click),
            SizedBox(
              width: 10,
            ),
            Text(
              'Visit Website',
              style: GoogleFonts.acme(
                textStyle: TextStyle(
                  fontSize: width * .04,
                  color: Colors.white, // Customize the text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
