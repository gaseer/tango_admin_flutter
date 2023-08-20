import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main_screen.dart';

class CustomDropDown extends StatelessWidget {
  final String? value, hint;
  final void Function(String?)? onChanged;
  final List<String> items;
  const CustomDropDown(
      {Key? key,
      required this.value,
      this.onChanged,
      required this.items,
      this.hint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: width * .05),
      width: width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: .5),
      ),
      child: DropdownButton<String>(
        hint: Text(
          hint!,
          style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.w500,
              fontSize: height * 0.017,
              color: Colors.black),
        ),
        isExpanded: true,
        iconSize: 30, // Adjust the icon size
        itemHeight: width * .15,
        value: value,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.w500,
                  fontSize: height * 0.017,
                  color: Colors.black),
            ),
          );
        }).toList(),
        underline: Container(),
      ),
    );
  }
}
