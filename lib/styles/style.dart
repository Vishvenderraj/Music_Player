import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ourStyle(String type, double size,Color color){
  return GoogleFonts.montserrat(
    textStyle: TextStyle(
      fontWeight: type == "bold"? FontWeight.w700:FontWeight.w300,
      fontSize: size,
      color: color,
      overflow: TextOverflow.ellipsis,
    )
  );
}