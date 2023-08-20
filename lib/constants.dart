import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color primaryColor = Color(0xff810F6A);
Color lightColor = Color(0xffB9149E);

// Function to handle navigation to a specific screen
void navigateToScreen(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    CupertinoPageRoute(builder: (context) => screen),
  );
}

//Function to show Snack Bar
void showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}

//function to make delete = true and pop the screen
void deleteDocument(BuildContext context, data) async {
  if (data == null) return;

  try {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      await data!.reference.delete();
      Navigator.pop(context);
      showSnackBar(context, 'Deleted Successfully', Colors.green);
    }
  } catch (e) {
    print('Error deleting document: $e');
  }
}
