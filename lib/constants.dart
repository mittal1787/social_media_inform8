import 'dart:ui';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

const platformColors = {"Facebook": Color(0xFF1877f2),
  "Twitter": Color.fromARGB(255,29, 161, 242),
  "YouTube":Colors.red,
  "Instagram": Color(0xFFc32aa3),
  "Twitch": Color(0xFF9146ff),
  "Tumblr": Color(0xFF35465d),
  "Pinterest": Color.fromARGB(255, 189, 8, 28),
  "Misc": Colors.black};

Map platformFonts = {"Facebook": getFontFamily(androidFontFamily: GoogleFonts.roboto(), iOSFontFamily: GoogleFonts.sacramento()),
  "Twitter": getFontFamily(androidFontFamily: GoogleFonts.roboto(), iOSFontFamily: GoogleFonts.sacramento()),
  "YouTube": getFontFamily(androidFontFamily: TextStyle(fontFamily: "YT Sans"), iOSFontFamily: TextStyle(fontFamily: "YT Sans")),
  "Instagram": getFontFamily(androidFontFamily: GoogleFonts.roboto(), iOSFontFamily: GoogleFonts.sacramento()),
  "Twitch":  getFontFamily(androidFontFamily: TextStyle(fontFamily:"Twitchy.TV"), iOSFontFamily: TextStyle(fontFamily:"Twitchy.TV")),
  "Tumblr":  getFontFamily(androidFontFamily: GoogleFonts.boogaloo(), iOSFontFamily: GoogleFonts.boogaloo()),
  "Pinterest": getFontFamily(androidFontFamily: GoogleFonts.roboto(), iOSFontFamily: GoogleFonts.sacramento()),
  "Misc": getFontFamily(androidFontFamily: GoogleFonts.roboto(), iOSFontFamily: GoogleFonts.sacramento())};

TextStyle getFontFamily({TextStyle androidFontFamily, TextStyle iOSFontFamily}) {
  return Platform.isAndroid ? androidFontFamily : iOSFontFamily;
}

