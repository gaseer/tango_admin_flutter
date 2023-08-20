import 'package:flutter/material.dart';
import 'package:tango_admin/constants.dart';

import '../main_screen.dart';
import '../widgets/homeDishContainer.dart';
import '../widgets/website_button.dart';
import 'navigate/dishList_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    // Replace this with your Home page content
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text("Dashboard",
                style: GoogleFonts.acme(
                  textStyle: TextStyle(
                    fontSize: width * .065,
                    color: Colors.black, // Customize the text color
                  ),
                ))),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: width * 0.05,
              ),
              Text(" SELECT THE DISH CATEGORY!",
                  style: GoogleFonts.acme(
                    textStyle: TextStyle(
                      fontSize: width * .05,
                      color: Colors.black, // Customize the text color
                    ),
                  )),
              SizedBox(
                height: width * 0.02,
              ),

              //1st ROW
              DishContainer(
                icon: Icons.kebab_dining,
                onTap: () => navigateToScreen(
                    context,
                    const DishListScreen(
                      category: 'CHARCOAL SKEWERS',
                    )),
                name: "CHARCOAL SKEWERS",
              ),
              SizedBox(
                width: width * .015,
              ),
              DishContainer(
                icon: Icons.local_dining,
                onTap: () => navigateToScreen(
                    context,
                    const DishListScreen(
                      category: "CHARCOAL CHICKEN",
                    )),
                name: "CHARCOAL CHICKEN MEALS",
              ),

              //2nd ROW
              DishContainer(
                icon: Icons.brunch_dining_sharp,
                onTap: () => navigateToScreen(
                    context,
                    const DishListScreen(
                      category: "CHARCOAL ROLLS",
                    )),
                name: "CHARCOAL ROLLS / BURGERS",
              ),
              SizedBox(
                width: width * .015,
              ),
              DishContainer(
                icon: Icons.ramen_dining,
                onTap: () => navigateToScreen(
                  context,
                  const DishListScreen(
                    category: "SALADS/DIPS/CHIPS/BREAD",
                  ),
                ),
                name: "SALADS / DIPS / CHIPS / BREAD",
              ),

              DishContainer(
                icon: Icons.fastfood,
                onTap: () => navigateToScreen(
                    context,
                    const DishListScreen(
                      category: "FALFEEL",
                    )),
                name: "FALFEEL",
              ),
              SizedBox(
                width: width * .015,
              ),
              const WebsiteButton(websiteUrl: 'https://tangochicken.com.au/'),
            ],
          ),
        ));
  }
}
