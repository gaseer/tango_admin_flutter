import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main_screen.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;
  final int? minLines, maxLines;
  final void Function()? onTap;
  final String? Function(String?)? validate;

  final TextEditingController textEditingController;

  const CustomTextField({
    Key? key,
    required this.text,
    required this.textEditingController,
    this.minLines,
    this.maxLines,
    this.suffixIcon,
    this.keyboardType,
    this.validate,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: width * .05, right: width * .05, top: width * .03),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        controller: textEditingController,
        validator: validate,
        textInputAction:
            maxLines == null ? TextInputAction.next : TextInputAction.none,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType ?? TextInputType.text,
        onTap: onTap,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.black, width: 1)),
            labelText: text,
            labelStyle: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w500,
                fontSize: height * 0.017,
                color: Colors.black),
            hintText: text,
            hintStyle: GoogleFonts.ubuntu(
                fontWeight: FontWeight.w300,
                fontSize: height * 0.019,
                color: Colors.black)),
      ),
    );
  }
}
