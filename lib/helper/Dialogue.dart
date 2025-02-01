import 'package:flutter/material.dart';

// this class all dialogue should be static

class Dialogue {
  static void showSnakbar(
      BuildContext context, String msg, IconData icon, double size_user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: size_user,
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24), // Add your icon here
              SizedBox(width: 10), // Space between icon and text
              Expanded(
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.normal,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blue.shade400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // circular progress indicator

  static void progressIndicator(BuildContext context) {
    showDialog(context: context, builder: (_) => Center(
      child: CircularProgressIndicator(
        color: Colors.blue.shade400,
        // strokeAlign: BorderSide.strokeAlignCenter,
        strokeWidth: 4.0,
        
      ),
    ));
  }
}
