import 'package:flutter/material.dart';

class AppFonts{
  static const String Montserrat = 'Montserrat';
  static const String PTSans = 'PTSans';
  static const String OpenSans = 'OpenSans';
}

class AppTextStyle{

  static const TextStyle openSans = TextStyle(
  );

  static const TextStyle montserrat = TextStyle(
    fontWeight: FontWeight.w400,
  );

  static TextStyle get normal => openSans.copyWith(fontSize: 14, color: Colors.black);

  static TextStyle get medium => openSans.copyWith(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);

  static TextStyle get bold => openSans.copyWith(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w700);

}