import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Error extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
        child: Center(
      child: Text(
          'We are breaking sweat to resolve this. Please try restarting app.',
          style: GoogleFonts.mcLaren(fontSize: 20.0, color: Colors.white)),
    ));
  }
}
